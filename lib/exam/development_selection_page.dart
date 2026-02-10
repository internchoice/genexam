// import 'package:flutter/material.dart';
// import 'exam_page.dart';
//
// class DevelopmentSelectionPage extends StatelessWidget {
//   const DevelopmentSelectionPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FA),
//       appBar: AppBar(
//         title: const Text("Select Exam Category"),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildOptionCard(
//               context,
//               title: "Web Development",
//               icon: Icons.web,
//               category: "web",
//             ),
//             const SizedBox(height: 20),
//             _buildOptionCard(
//               context,
//               title: "App Development",
//               icon: Icons.phone_android,
//               category: "app",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOptionCard(
//       BuildContext context, {
//         required String title,
//         required IconData icon,
//         required String category,
//       }) {
//     return SizedBox(
//       width: double.infinity,
//       height: 80,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ExamPage(category: category),
//             ),
//           );
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 28, color: Colors.white),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'exam_page.dart';

class DevelopmentSelectionPage extends StatelessWidget {
  const DevelopmentSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Select Exam Category"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionCard(
              context,
              title: "Web Development",
              icon: Icons.web,
              category: "Web", // ✅ EXACT MATCH
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: "Flutter Development",
              icon: Icons.phone_android,
              category: "Flutter", // ✅ EXACT MATCH
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required String category,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ExamPage(category: category),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
