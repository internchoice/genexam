// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'exam_guard.dart';
//
// class ExamPage extends StatefulWidget {
//   const ExamPage({super.key});
//
//   @override
//   State<ExamPage> createState() => _ExamPageState();
// }
//
// class _ExamPageState extends State<ExamPage> {
//   final int examDuration = 1800; // 60 minutes
//   int remaining = 1800;
//
//   Timer? _timer;
//   late ExamGuard _guard;
//
//   List<DocumentSnapshot> questions = [];
//   List<int?> answers = [];
//   DocumentSnapshot? userDoc;
//
//   int currentIndex = 0;
//   bool loading = true;
//   bool submitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startExam();
//   }
//
//   String formatTime(int seconds) {
//     final h = seconds ~/ 1800;
//     final m = (seconds % 1800) ~/ 60;
//     final s = seconds % 60;
//     return "${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}";
//   }
//
//   Future<void> _startExam() async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//
//     // Fetch user info
//     userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//
//     await FirebaseFirestore.instance.collection('attempts').doc(uid).set({
//       'userId': uid,
//       'status': 'ongoing',
//       'startedAt': FieldValue.serverTimestamp(),
//     });
//
//     final qs = await FirebaseFirestore.instance.collection('questions').get();
//     questions = qs.docs;
//     answers = List<int?>.filled(questions.length, null);
//
//     _guard = ExamGuard(onViolation: _cancelExam);
//     WidgetsBinding.instance.addObserver(_guard);
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (submitting) return;
//       setState(() => remaining--);
//       if (remaining <= 0) _submitExam();
//     });
//
//     setState(() => loading = false);
//   }
//
//   Future<void> _submitExam() async {
//     if (submitting) return;
//     submitting = true;
//
//     _timer?.cancel();
//     WidgetsBinding.instance.removeObserver(_guard);
//
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//
//     int score = 0;
//     int totalMarks = 0;
//
//     for (int i = 0; i < questions.length; i++) {
//       final q = questions[i];
//       final int marks = (q['marks'] as num).toInt();
//       final int correct = (q['correctIndex'] as num).toInt();
//       totalMarks += marks;
//       if (answers[i] == correct) score += marks;
//     }
//
//     await FirebaseFirestore.instance.collection('attempts').doc(uid).update({
//       'status': 'submitted',
//       'answers': answers,
//       'score': score,
//       'totalMarks': totalMarks,
//       'name': userDoc!['name'],
//       'endedAt': FieldValue.serverTimestamp(),
//     });
//
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({'hasAttemptedExam': true});
//     await FirebaseAuth.instance.signOut();
//
//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ExamFinishedPage(score: score, total: totalMarks, userDoc: userDoc),
//       ),
//           (_) => false,
//     );
//   }
//
//   Future<void> _cancelExam() async {
//     if (submitting) return;
//     submitting = true;
//
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//
//     await FirebaseFirestore.instance.collection('attempts').doc(uid).update({
//       'status': 'cancelled',
//       'endedAt': FieldValue.serverTimestamp(),
//     });
//
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({'hasAttemptedExam': true});
//     await FirebaseAuth.instance.signOut();
//
//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ExamFinishedPage(score: 0, total: 0, cancelled: true, userDoc: userDoc),
//       ),
//           (_) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final q = questions[currentIndex];
//     double progress = (currentIndex + 1) / questions.length;
//
//     const optionLetters = ['A', 'B', 'C', 'D'];
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("Exam In Progress"),
//         backgroundColor: Colors.deepPurple,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // User Profile Card
//               if (userDoc != null)
//                 Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   elevation: 3,
//                   color: Colors.deepPurple[50],
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.deepPurple,
//                           child: Icon(Icons.person, color: Colors.white, size: 30),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 userDoc!['name'] ?? '',
//                                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "${userDoc!['course'] ?? ''} | Roll No: ${userDoc!['rollNumber'] ?? ''}",
//                                 style: const TextStyle(fontSize: 14, color: Colors.black87),
//                               ),
//                               Text(
//                                 userDoc!['email'] ?? '',
//                                 style: const TextStyle(fontSize: 14, color: Colors.black54),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),
//
//               // Timer & Question Count
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Q${currentIndex + 1}/${questions.length}",
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple[50],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       formatTime(remaining),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Question Card
//               Expanded(
//                 child: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           q['question'],
//                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 20),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: q['options'].length,
//                             itemBuilder: (context, i) {
//                               final isSelected = answers[currentIndex] == i;
//                               return Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 6),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
//                                     foregroundColor: isSelected ? Colors.white : Colors.black87,
//                                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       side: BorderSide(
//                                         color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
//                                       ),
//                                     ),
//                                     elevation: 2,
//                                   ),
//                                   onPressed: submitting
//                                       ? null
//                                       : () {
//                                     setState(() {
//                                       answers = List<int?>.from(answers);
//                                       answers[currentIndex] = i;
//                                     });
//                                   },
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 14,
//                                         backgroundColor: isSelected ? Colors.white : Colors.deepPurple[100],
//                                         child: Text(
//                                           optionLetters[i],
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: isSelected ? Colors.deepPurple : Colors.deepPurple[800]),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Text(
//                                           q['options'][i],
//                                           style: const TextStyle(fontSize: 16),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Navigation & Progress
//               Row(
//                 children: [
//                   if (currentIndex > 0)
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () => setState(() => currentIndex--),
//                         icon: const Icon(Icons.arrow_back),
//                         label: const Text("Previous"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey[600],
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                       ),
//                     ),
//                   if (currentIndex > 0) const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: submitting
//                           ? null
//                           : () {
//                         if (currentIndex < questions.length - 1) {
//                           setState(() => currentIndex++);
//                         } else {
//                           _submitExam();
//                         }
//                       },
//                       icon: Icon(
//                         currentIndex < questions.length - 1 ? Icons.arrow_forward : Icons.check,
//                         color: Colors.white,
//                       ),
//                       label: Text(
//                         currentIndex < questions.length - 1 ? "Next" : "Submit",
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurple,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               LinearProgressIndicator(
//                 value: progress,
//                 backgroundColor: Colors.deepPurple[100],
//                 color: Colors.deepPurple,
//                 minHeight: 6,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ExamFinishedPage extends StatelessWidget {
//   final int score;
//   final int total;
//   final bool cancelled;
//   final DocumentSnapshot? userDoc;
//
//   const ExamFinishedPage({
//     super.key,
//     required this.score,
//     required this.total,
//     this.cancelled = false,
//     this.userDoc,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: Card(
//           margin: const EdgeInsets.all(24),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           elevation: 5,
//           child: Padding(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (userDoc != null)
//                   Column(
//                     children: [
//                       Text(
//                         userDoc!['name'] ?? '',
//                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "${userDoc!['course'] ?? ''} | Roll No: ${userDoc!['rollNumber'] ?? ''}",
//                         style: const TextStyle(color: Colors.black54),
//                       ),
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 Icon(
//                   cancelled ? Icons.cancel : Icons.check_circle,
//                   size: 80,
//                   color: cancelled ? Colors.red : Colors.green,
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   cancelled
//                       ? "Exam Cancelled"
//                       : "Exam Finished\nThank you for completing the exam! Your results will be available soon.",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "You may now close this tab.",
//                   style: TextStyle(color: Colors.grey, fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exam_guard.dart';

class ExamPage extends StatefulWidget {
  final String category;

  const ExamPage({super.key, required this.category});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final int examDuration = 1800;
  int remaining = 1800;

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

  String formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  Future<void> _startExam() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    await FirebaseFirestore.instance.collection('attempts').doc(uid).set({
      'userId': uid,
      'status': 'ongoing',
      'startedAt': FieldValue.serverTimestamp(),
      'domain': widget.category,
    });

    List<String> orderedSections = [
      "Quantitative Aptitude",
      "Verbal Ability",
      "Reasoning",
    ];

    if (!orderedSections.contains(widget.category)) {
      orderedSections.add(widget.category);
    }

    List<DocumentSnapshot> allQuestions = [];

    for (String section in orderedSections) {
      final qs = await FirebaseFirestore.instance
          .collection('questions')
          .where('section', isEqualTo: section)
          .get();

      allQuestions.addAll(qs.docs);
    }

    questions = allQuestions;
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
        builder: (_) =>
            ExamFinishedPage(score: score, total: totalMarks),
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
        builder: (_) =>
        const ExamFinishedPage(score: 0, total: 0, cancelled: true),
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

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("${widget.category} Exam")),
        body: const Center(
          child: Text("No questions available."),
        ),
      );
    }

    final q = questions[currentIndex];

    int total = questions.length;
    int answered = answers.where((a) => a != null).length;
    int remainingQ = total - answered;

    const optionLetters = ['A', 'B', 'C', 'D'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("${widget.category} Exam"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${currentIndex + 1} of $total",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    formatTime(remaining),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statusBox("Total", total, Colors.black),
                    _statusBox("Answered", answered, Colors.green),
                    _statusBox("Remaining", remainingQ, Colors.red),
                    _statusBox("Current", currentIndex + 1, Colors.blue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Section: ${q['section']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        q['question'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: q['options'].length,
                          itemBuilder: (context, i) {
                            final isSelected =
                                answers[currentIndex] == i;
                            return Container(
                              margin:
                              const EdgeInsets.symmetric(vertical: 6),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? Colors.deepPurple
                                      : Colors.white,
                                  foregroundColor: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    side: BorderSide(
                                        color: isSelected
                                            ? Colors.deepPurple
                                            : Colors.grey.shade300),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    answers[currentIndex] = i;
                                  });
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                      isSelected
                                          ? Colors.white
                                          : Colors.deepPurple[100],
                                      child: Text(
                                        optionLetters[i],
                                        style: TextStyle(
                                            color: isSelected
                                                ? Colors.deepPurple
                                                : Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(q['options'][i]),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                if (currentIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          setState(() => currentIndex--),
                      child: const Text("Previous"),
                    ),
                  ),
                if (currentIndex > 0)
                  const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex < total - 1) {
                        setState(() => currentIndex++);
                      } else {
                        _submitExam();
                      }
                    },
                    child: Text(
                        currentIndex < total - 1
                            ? "Next"
                            : "Submit"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBox(String title, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ExamFinishedPage extends StatelessWidget {
  final int score;
  final int total;
  final bool cancelled;

  const ExamFinishedPage({
    super.key,
    required this.score,
    required this.total,
    this.cancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  cancelled ? Icons.cancel : Icons.check_circle,
                  size: 80,
                  color: cancelled ? Colors.red : Colors.green,
                ),
                const SizedBox(height: 20),
                Text(
                  cancelled
                      ? "Exam Cancelled"
                      : "Exam Completed",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
