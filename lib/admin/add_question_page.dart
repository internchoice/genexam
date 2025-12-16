import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _question = TextEditingController();
  final _options = List.generate(4, (_) => TextEditingController());
  int _correctIndex = 0;
  bool _loading = false;

  Future<void> _save() async {
    setState(() => _loading = true);

    await FirebaseFirestore.instance.collection('questions').add({
      'question': _question.text.trim(),
      'options': _options.map((e) => e.text.trim()).toList(),
      'correctIndex': _correctIndex,
      'marks': 1,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Question")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _question,
              decoration: const InputDecoration(labelText: "Question"),
            ),
            const SizedBox(height: 20),

            for (int i = 0; i < 4; i++)
              RadioListTile<int>(
                value: i,
                groupValue: _correctIndex,
                title: TextField(
                  controller: _options[i],
                  decoration:
                  InputDecoration(labelText: "Option ${i + 1}"),
                ),
                onChanged: (v) => setState(() => _correctIndex = v!),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: const Text("Save Question"),
            ),
          ],
        ),
      ),
    );
  }
}
