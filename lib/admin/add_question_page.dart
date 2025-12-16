import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _questionCtrl = TextEditingController();
  final _marksCtrl = TextEditingController(text: "1");

  final List<TextEditingController> _options =
  List.generate(4, (_) => TextEditingController());

  int? _correctIndex;
  bool _loading = false;

  Future<void> _save() async {
    // 🔐 VALIDATION
    if (_questionCtrl.text.trim().isEmpty) {
      _error("Question is required");
      return;
    }

    for (int i = 0; i < 4; i++) {
      if (_options[i].text.trim().isEmpty) {
        _error("Option ${i + 1} cannot be empty");
        return;
      }
    }

    if (_correctIndex == null) {
      _error("Please mark the correct answer");
      return;
    }

    final marks = int.tryParse(_marksCtrl.text.trim());
    if (marks == null || marks <= 0) {
      _error("Marks must be a positive number");
      return;
    }

    setState(() => _loading = true);

    await FirebaseFirestore.instance.collection('questions').add({
      'question': _questionCtrl.text.trim(),
      'options': _options.map((e) => e.text.trim()).toList(),
      'correctIndex': _correctIndex, // 🔑 used for scoring
      'marks': marks,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _toggleCorrect(int index, bool? value) {
    setState(() {
      if (value == true) {
        // Only ONE correct allowed
        _correctIndex = index;
      } else {
        _correctIndex = null;
      }
    });
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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
              controller: _questionCtrl,
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 20),

            for (int i = 0; i < 4; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _correctIndex == i,
                    onChanged: (v) => _toggleCorrect(i, v),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _options[i],
                      decoration: InputDecoration(
                        labelText: "Option ${i + 1}",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            TextField(
              controller: _marksCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Marks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Question"),
            ),
          ],
        ),
      ),
    );
  }
}
