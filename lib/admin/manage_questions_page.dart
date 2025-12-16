import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageQuestionsPage extends StatelessWidget {
  const ManageQuestionsPage({super.key});

  void _deleteQuestion(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Question"),
        content: const Text("Are you sure you want to delete this question?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('questions').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Question deleted")),
      );
    }
  }

  void _editQuestion(BuildContext context, DocumentSnapshot doc) {
    final questionCtrl = TextEditingController(text: doc['question']);
    final marksCtrl = TextEditingController(text: doc['marks'].toString());
    final List<TextEditingController> optionCtrls =
    List.generate(4, (i) => TextEditingController(text: doc['options'][i]));
    int? correctIndex = doc['correctIndex'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Question"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: questionCtrl,
                decoration: const InputDecoration(labelText: "Question"),
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < 4; i++)
                Row(
                  children: [
                    Checkbox(
                      value: correctIndex == i,
                      onChanged: (v) {
                        correctIndex = v! ? i : null;
                        (context as Element).markNeedsBuild(); // refresh dialog
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: optionCtrls[i],
                        decoration: InputDecoration(labelText: "Option ${i + 1}"),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              TextField(
                controller: marksCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Marks"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final question = questionCtrl.text.trim();
              final marks = int.tryParse(marksCtrl.text.trim()) ?? 1;
              final options = optionCtrls.map((e) => e.text.trim()).toList();

              if (question.isEmpty || options.any((o) => o.isEmpty) || correctIndex == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields and mark correct answer")),
                );
                return;
              }

              await FirebaseFirestore.instance.collection('questions').doc(doc.id).update({
                'question': question,
                'options': options,
                'correctIndex': correctIndex,
                'marks': marks,
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Question updated")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Questions")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('questions').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No questions found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final q = docs[index];
              final options = List<String>.from(q['options'] ?? []);
              final marks = q['marks'] ?? 1;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q['question'] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Marks: $marks | Options: ${options.length}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editQuestion(context, q),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: "Edit Question",
                          ),
                          IconButton(
                            onPressed: () => _deleteQuestion(context, q.id),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Delete Question",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
