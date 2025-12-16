import 'package:flutter/material.dart';
import 'add_question_page.dart';
import 'admin_results_page.dart';
import 'manage_questions_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWideScreen
            ? GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: _buildDashboardCards(context),
        )
            : ListView(
          children: _buildDashboardCards(context)
              .map((card) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: card,
          ))
              .toList(),
        ),
      ),
    );
  }

  List<Widget> _buildDashboardCards(BuildContext context) {
    return [
      _DashboardCard(
        title: "Add Question",
        icon: Icons.add_box,
        color: Colors.green.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddQuestionPage()),
        ),
      ),
      _DashboardCard(
        title: "Manage Questions",
        icon: Icons.manage_search,
        color: Colors.orange.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ManageQuestionsPage()),
        ),
      ),
      _DashboardCard(
        title: "View Results",
        icon: Icons.bar_chart,
        color: Colors.blue.shade400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminResultsPage()),
        ),
      ),
    ];
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth > 600 ? 120.0 : 100.0; // smaller height
    final iconSize = screenWidth > 600 ? 40.0 : 32.0; // smaller icon
    final fontSize = screenWidth > 600 ? 16.0 : 14.0; // smaller text

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        shadowColor: Colors.grey.shade300,
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.85), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
