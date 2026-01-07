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
  // ✅ 30 minutes = 1800 seconds
  final int examDuration = 30 * 60;
  int remaining = 30 * 60;

  Timer? _timer;
  late ExamGuard _guard;

  List<DocumentSnapshot> questions = [];
  List<int?> answers = [];
  DocumentSnapshot? userDoc;

  int currentIndex = 0;
  bool loading = true;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _startExam();
  }

  // ✅ FIXED TIMER FORMAT (HH:MM:SS)
  String formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  Future<void> _startExam() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    await FirebaseFirestore.instance.collection('attempts').doc(uid).set({
      'userId': uid,
      'status': 'ongoing',
      'startedAt': FieldValue.serverTimestamp(),
    });

    final qs = await FirebaseFirestore.instance.collection('questions').get();
    questions = qs.docs;
    answers = List<int?>.filled(questions.length, null);

    _guard = ExamGuard(onViolation: _cancelExam);
    WidgetsBinding.instance.addObserver(_guard);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (submitting) return;
      setState(() => remaining--);
      if (remaining <= 0) _submitExam();
    });

    setState(() => loading = false);
  }

  Future<void> _submitExam() async {
    if (submitting) return;
    submitting = true;

    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(_guard);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    int score = 0;
    int totalMarks = 0;

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final int marks = (q['marks'] as num).toInt();
      final int correct = (q['correctIndex'] as num).toInt();
      totalMarks += marks;
      if (answers[i] == correct) score += marks;
    }

    await FirebaseFirestore.instance.collection('attempts').doc(uid).update({
      'status': 'submitted',
      'answers': answers,
      'score': score,
      'totalMarks': totalMarks,
      'name': userDoc!['name'],
      'endedAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'hasAttemptedExam': true});

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ExamFinishedPage(
          score: score,
          total: totalMarks,
          userDoc: userDoc,
        ),
      ),
      (_) => false,
    );
  }

  Future<void> _cancelExam() async {
    if (submitting) return;
    submitting = true;

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

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ExamFinishedPage(
          score: 0,
          total: 0,
          cancelled: true,
          userDoc: userDoc,
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = questions[currentIndex];
    double progress = (currentIndex + 1) / questions.length;
    const optionLetters = ['A', 'B', 'C', 'D'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Exam In Progress"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Q${currentIndex + 1}/${questions.length}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      formatTime(remaining),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.deepPurple[100],
                color: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamFinishedPage extends StatelessWidget {
  final int score;
  final int total;
  final bool cancelled;
  final DocumentSnapshot? userDoc;

  const ExamFinishedPage({
    super.key,
    required this.score,
    required this.total,
    this.cancelled = false,
    this.userDoc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          cancelled ? "Exam Cancelled" : "Exam Finished",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
