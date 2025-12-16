import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminResultsPage extends StatelessWidget {
  const AdminResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exam Results")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('attempts')
            .where('status', isEqualTo: 'submitted')
            .snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              return ListTile(
                title: Text("User: ${d['userId']}"),
                subtitle: Text("Score: ${d['score']}"),
              );
            },
          );
        },
      ),
    );
  }
}
