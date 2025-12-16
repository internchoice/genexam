import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageQuestionsPage extends StatelessWidget {
  const ManageQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Questions")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('questions').snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final q = docs[i];
              return ListTile(
                title: Text(q['question']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      FirebaseFirestore.instance
                          .collection('questions')
                          .doc(q.id)
                          .delete(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
