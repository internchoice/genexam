import 'package:flutter/material.dart';
import 'add_question_page.dart';
import 'admin_results_page.dart';
import 'manage_questions_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddQuestionPage()),
            ),
            child: const Text("Add Question"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageQuestionsPage()),
            ),
            child: const Text("Manage Questions"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminResultsPage()),
            ),
            child: const Text("View Results"),
          ),
        ],
      ),
    );
  }
}
