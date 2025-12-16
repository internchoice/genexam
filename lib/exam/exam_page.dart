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
  final int examDuration = 300; // 5 minutes
  int remaining = 300;

  Timer? _timer;
  late ExamGuard _guard;

  List<DocumentSnapshot> questions = [];
  Map<String, int> answers = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _startExam();
  }

  Future<void> _startExam() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // 🔒 Lock attempt
    await FirebaseFirestore.instance.collection('attempts').doc(uid).set({
      'userId': uid,
      'status': 'ongoing',
      'startedAt': FieldValue.serverTimestamp(),
    });

    final qs = await FirebaseFirestore.instance
        .collection('questions')
        .get();

    questions = qs.docs;

    _guard = ExamGuard(onViolation: _cancelExam);
    WidgetsBinding.instance.addObserver(_guard);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => remaining--);
      if (remaining <= 0) _submitExam();
    });

    setState(() => loading = false);
  }

  Future<void> _cancelExam() async {
    _timer?.cancel();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('attempts').doc(uid).update({
      'status': 'cancelled',
      'endedAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'hasAttemptedExam': true});

    await FirebaseAuth.instance.signOut();
    _exit("Exam Cancelled due to rule violation");
  }

  Future<void> _submitExam() async {
    _timer?.cancel();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    int score = 0;
    for (final q in questions) {
      final correct = q['correctIndex'];
      if (answers[q.id] == correct) {
        score += (q['marks'] as int);
      }
    }

    await FirebaseFirestore.instance.collection('attempts').doc(uid).update({
      'status': 'submitted',
      'answers': answers,
      'score': score,
      'endedAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'hasAttemptedExam': true});

    await FirebaseAuth.instance.signOut();
    _exit("Exam Submitted. Score: $score");
  }

  void _exit(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Exam Finished"),
        content: Text(message),
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
        title: Text("Time Left: ${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final q in questions) ...[
            Text(q['question'], style: const TextStyle(fontSize: 18)),
            for (int i = 0; i < q['options'].length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: answers[q.id],
                title: Text(q['options'][i]),
                onChanged: (v) =>
                    setState(() => answers[q.id] = v!),
              ),
            const Divider()
          ],
          ElevatedButton(
            onPressed: _submitExam,
            child: const Text("Submit Exam"),
          )
        ],
      ),
    );
  }
}
