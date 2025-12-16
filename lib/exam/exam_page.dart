import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exam_guard.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final int examDuration = 300;
  int remaining = 300;

  Timer? _timer;
  late ExamGuard _guard;

  List<DocumentSnapshot> questions = [];
  List<int?> answers = [];

  bool loading = true;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _startExam();
  }

  Future<void> _startExam() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('attempts')
        .doc(uid)
        .set({
      'userId': uid,
      'status': 'ongoing',
      'startedAt': FieldValue.serverTimestamp(),
    });

    final qs =
    await FirebaseFirestore.instance.collection('questions').get();

    questions = qs.docs;
    answers = List<int?>.filled(questions.length, null);

    _guard = ExamGuard(onViolation: _cancelExam);
    WidgetsBinding.instance.addObserver(_guard);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (submitting) return;

      setState(() => remaining--);
      if (remaining <= 0) {
        _submitExam();
      }
    });

    setState(() => loading = false);
  }

  Future<void> _submitExam() async {
    if (submitting) return;
    submitting = true;

    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(_guard);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;

      int score = 0;
      int totalMarks = 0;

      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];

        // 🔑 EXPLICIT CASTS (CRITICAL FIX)
        final int marks = (q['marks'] as num).toInt();
        final int correctIndex = (q['correctIndex'] as num).toInt();

        totalMarks += marks;

        if (answers[i] != null && answers[i] == correctIndex) {
          score += marks;
        }
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final displayName =
      userDoc.data()?.containsKey('name') == true
          ? userDoc['name']
          : userDoc['email'];

      await FirebaseFirestore.instance
          .collection('attempts')
          .doc(uid)
          .update({
        'status': 'submitted',
        'answers': answers,
        'score': score,
        'totalMarks': totalMarks,
        'name': displayName,
        'endedAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'hasAttemptedExam': true});

      await FirebaseAuth.instance.signOut();

      _exit("Exam submitted\nScore: $score / $totalMarks");
    } catch (e) {
      submitting = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submit failed: $e")),
      );
    }
  }

  Future<void> _cancelExam() async {
    if (submitting) return;
    submitting = true;

    _timer?.cancel();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('attempts')
        .doc(uid)
        .update({
      'status': 'cancelled',
      'endedAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'hasAttemptedExam': true});

    await FirebaseAuth.instance.signOut();
    _exit("Exam cancelled");
  }

  void _exit(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Exam Finished"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((r) => r.isFirst),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(_guard);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Time Left: ${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}",
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int qi = 0; qi < questions.length; qi++) ...[
            Text(
              questions[qi]['question'],
              style: const TextStyle(fontSize: 18),
            ),
            for (int i = 0; i < questions[qi]['options'].length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: answers[qi],
                title: Text(questions[qi]['options'][i]),
                onChanged: submitting
                    ? null
                    : (v) {
                  setState(() {
                    answers = List<int?>.from(answers);
                    answers[qi] = v;
                  });
                },
              ),
            const Divider(),
          ],
          ElevatedButton(
            onPressed: submitting ? null : _submitExam,
            child: submitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Submit Exam"),
          ),
        ],
      ),
    );
  }
}
