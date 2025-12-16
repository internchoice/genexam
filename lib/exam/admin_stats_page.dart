import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminStatsPage extends StatelessWidget {
  const AdminStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exam Statistics")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attempts')
            .where('status', isEqualTo: 'submitted')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No data"));
          }

          int totalScore = 0;
          int totalMarks = 0;
          int passCount = 0;

          for (final d in docs) {
            totalScore += d['score'] as int;
            totalMarks += d['totalMarks'] as int;
            if ((d['score'] / d['totalMarks']) >= 0.4) {
              passCount++;
            }
          }

          final avg = totalScore / docs.length;
          final passPercent =
          (passCount / docs.length * 100).toStringAsFixed(1);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _card("Average Score", avg.toStringAsFixed(2)),
                _card("Pass Percentage", "$passPercent %"),
                _card("Total Students", docs.length.toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
