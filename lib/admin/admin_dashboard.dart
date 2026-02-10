// import 'package:flutter/material.dart';
// import 'add_question_page.dart';
// import 'admin_results_page.dart';
// import 'manage_questions_page.dart';
//
// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isWideScreen = screenWidth > 600;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FA),
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//         centerTitle: true,
//         backgroundColor: Colors.blue.shade700,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: isWideScreen
//             ? GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           childAspectRatio: 1.5,
//           children: _buildDashboardCards(context),
//         )
//             : ListView(
//           children: _buildDashboardCards(context)
//               .map((card) => Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: card,
//           ))
//               .toList(),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildDashboardCards(BuildContext context) {
//     return [
//       _DashboardCard(
//         title: "Add Question",
//         icon: Icons.add_box,
//         color: Colors.green.shade400,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddQuestionPage()),
//         ),
//       ),
//       _DashboardCard(
//         title: "Manage Questions",
//         icon: Icons.manage_search,
//         color: Colors.orange.shade400,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const ManageQuestionsPage()),
//         ),
//       ),
//       _DashboardCard(
//         title: "View Results",
//         icon: Icons.bar_chart,
//         color: Colors.blue.shade400,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminResultsPage()),
//         ),
//       ),
//     ];
//   }
// }
//
// class _DashboardCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//
//   const _DashboardCard({
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final cardHeight = screenWidth > 600 ? 120.0 : 100.0; // smaller height
//     final iconSize = screenWidth > 600 ? 40.0 : 32.0; // smaller icon
//     final fontSize = screenWidth > 600 ? 16.0 : 14.0; // smaller text
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         shadowColor: Colors.grey.shade300,
//         child: Container(
//           height: cardHeight,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             gradient: LinearGradient(
//               colors: [color.withOpacity(0.85), color],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   icon,
//                   size: iconSize,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: fontSize,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'add_question_page.dart';
import 'admin_results_page.dart';
import 'manage_questions_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3F51B5),
              Color(0xFF2196F3),
              Color(0xFF00BCD4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome Admin 👋",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Manage your quiz system",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Cards
              Expanded(
                child: GridView(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isWide ? 1.9 : 2.1,
                  ),
                  children: [
                    GlassCard(
                      title: "Add Question",
                      subtitle: "Create new quiz questions",
                      icon: Icons.add_circle_rounded,
                      color: Colors.greenAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddQuestionPage(),
                        ),
                      ),
                    ),
                    GlassCard(
                      title: "Manage Questions",
                      subtitle: "Edit & delete questions",
                      icon: Icons.edit_note_rounded,
                      color: Colors.orangeAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageQuestionsPage(),
                        ),
                      ),
                    ),
                    GlassCard(
                      title: "View Results",
                      subtitle: "Check student performance",
                      icon: Icons.bar_chart_rounded,
                      color: Colors.lightBlueAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminResultsPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const GlassCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
