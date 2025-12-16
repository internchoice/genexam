import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminStatsPage extends StatelessWidget {
  const AdminStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Exam Statistics"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
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
            return const Center(
              child: Text(
                "No data available",
                style: TextStyle(fontSize: 18),
              ),
            );
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
          final passPercent = (passCount / docs.length * 100).toStringAsFixed(1);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _statCard(
                  icon: Icons.bar_chart,
                  title: "Average Score",
                  value: avg.toStringAsFixed(2),
                  color: Colors.deepPurple,
                ),
                _statCard(
                  icon: Icons.check_circle,
                  title: "Pass Percentage",
                  value: "$passPercent%",
                  color: Colors.green,
                ),
                _statCard(
                  icon: Icons.people,
                  title: "Total Students",
                  value: docs.length.toString(),
                  color: Colors.orange,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      shadowColor: color.withOpacity(0.5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
