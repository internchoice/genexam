import 'package:flutter/material.dart';
import 'exam_guard.dart';
import 'exam_page.dart';

class ExamInstructionPage extends StatelessWidget {
  const ExamInstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Instructions"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please read carefully:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Text("• This exam can be attempted ONLY ONCE."),
            const Text("• Do NOT minimize or switch the app."),
            const Text("• Do NOT refresh the page (Web)."),
            const Text("• Screen lock or app change will CANCEL exam."),
            const Text("• Timer will not pause."),
            const Text("• Violations = automatic cancellation."),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text("Start Exam"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ExamPage()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
