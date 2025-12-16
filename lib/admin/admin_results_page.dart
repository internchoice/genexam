import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminResultsPage extends StatelessWidget {
  const AdminResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exam Results")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attempts')
            .where('status', isEqualTo: 'submitted')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No submissions yet"));
          }

          // 🔑 SORT LOCALLY (Score DESC, EndedAt ASC)
          docs.sort((a, b) {
            final int scoreA = (a['score'] as num).toInt();
            final int scoreB = (b['score'] as num).toInt();

            if (scoreA != scoreB) {
              return scoreB.compareTo(scoreA);
            }

            final Timestamp timeA = a['endedAt'];
            final Timestamp timeB = b['endedAt'];
            return timeA.compareTo(timeB);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final rank = index + 1;

              return Card(
                child: ListTile(
                  leading: _rankIcon(rank),
                  title: Text(
                    data['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Score: ${data['score']} / ${data['totalMarks']}",
                  ),
                  trailing: Text(
                    "#$rank",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _rankIcon(int rank) {
    if (rank == 1) return const Text("🥇", style: TextStyle(fontSize: 26));
    if (rank == 2) return const Text("🥈", style: TextStyle(fontSize: 26));
    if (rank == 3) return const Text("🥉", style: TextStyle(fontSize: 26));
    return const Icon(Icons.person);
  }
}
