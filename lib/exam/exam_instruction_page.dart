// import 'package:flutter/material.dart';
// import 'exam_page.dart';
//
// class ExamInstructionPage extends StatefulWidget {
//   const ExamInstructionPage({super.key});
//
//   @override
//   State<ExamInstructionPage> createState() => _ExamInstructionPageState();
// }
//
// class _ExamInstructionPageState extends State<ExamInstructionPage> {
//   bool agreed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FA),
//       appBar: AppBar(
//         title: const Text("Exam Instructions"),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             /// Scrollable instructions
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Important Exam Guidelines",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Divider(height: 30),
//
//                         InstructionText("This exam can be attempted ONLY ONCE."),
//                         InstructionText("Do NOT minimize, close, or switch the application during the exam."),
//                         InstructionText("Do NOT refresh or reload the page at any time."),
//                         InstructionText("Pressing the BACK button will IMMEDIATELY TERMINATE the exam.", isWarning: true),
//                         InstructionText("Locking the screen or switching to another app will CANCEL the exam.", isWarning: true),
//                         InstructionText("The exam timer will NOT pause under any circumstances."),
//                         InstructionText("Ensure a stable internet connection before starting the exam."),
//                         InstructionText("Use of multiple devices is strictly prohibited.", isWarning: true),
//                         InstructionText("Do NOT open any other apps, tabs, or notifications during the exam.", isWarning: true),
//                         InstructionText("Any attempt to cheat, copy, or use external resources will result in disqualification.", isWarning: true),
//                         InstructionText("Answers must be saved before time expires; unsaved answers will not be counted."),
//                         InstructionText("Once submitted, the exam CANNOT be resumed or retaken.", isWarning: true),
//                         InstructionText("Any violation of the above rules will lead to AUTOMATIC exam submission.", isWarning: true),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             /// Agreement Checkbox
//             CheckboxListTile(
//               value: agreed,
//               onChanged: (value) {
//                 setState(() {
//                   agreed = value ?? false;
//                 });
//               },
//               title: const Text(
//                 "I have read and agree to all the instructions above.",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               controlAffinity: ListTileControlAffinity.leading,
//             ),
//
//             const SizedBox(height: 10),
//
//             /// Start Exam Button
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: agreed ? Colors.blue : Colors.grey,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: agreed
//                     ? () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const ExamPage(),
//                     ),
//                   );
//                 }
//                     : null,
//                 child: const Text(
//                   "START EXAM",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Reusable instruction text widget
// class InstructionText extends StatelessWidget {
//   final String text;
//   final bool isWarning;
//
//   const InstructionText(
//       this.text, {
//         super.key,
//         this.isWarning = false,
//       });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             isWarning ? Icons.warning_amber_rounded : Icons.circle,
//             size: isWarning ? 22 : 8,
//             color: isWarning ? Colors.red : Colors.black,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
//                 color: isWarning ? Colors.red : Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'development_selection_page.dart';
import 'exam_page.dart';

class ExamInstructionPage extends StatefulWidget {
  const ExamInstructionPage({super.key});

  @override
  State<ExamInstructionPage> createState() => _ExamInstructionPageState();
}

class _ExamInstructionPageState extends State<ExamInstructionPage> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Exam Instructions"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Scrollable instructions
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Important Exam Guidelines",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(height: 30),

                        InstructionText("This exam can be attempted ONLY ONCE."),
                        InstructionText("Do NOT minimize, close, or switch the application during the exam."),
                        InstructionText("Do NOT refresh or reload the page at any time."),
                        InstructionText("Pressing the BACK button will IMMEDIATELY TERMINATE the exam.", isWarning: true),
                        InstructionText("Locking the screen or switching to another app will CANCEL the exam.", isWarning: true),
                        InstructionText("The exam timer will NOT pause under any circumstances."),
                        InstructionText("Ensure a stable internet connection before starting the exam."),
                        InstructionText("Use of multiple devices is strictly prohibited.", isWarning: true),
                        InstructionText("Do NOT open any other apps, tabs, or notifications during the exam.", isWarning: true),
                        InstructionText("Any attempt to cheat, copy, or use external resources will result in disqualification.", isWarning: true),
                        InstructionText("Answers must be saved before time expires; unsaved answers will not be counted."),
                        InstructionText("Once submitted, the exam CANNOT be resumed or retaken.", isWarning: true),
                        InstructionText("Any violation of the above rules will lead to AUTOMATIC exam submission.", isWarning: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Agreement Checkbox
            CheckboxListTile(
              value: agreed,
              onChanged: (value) {
                setState(() {
                  agreed = value ?? false;
                });
              },
              title: const Text(
                "I have read and agree to all the instructions above.",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 10),

            /// Start Exam Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: agreed ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: agreed
                    ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      // builder: (_) => const ExamPage(),
                      builder: (_) => const DevelopmentSelectionPage(),

                    ),
                  );
                }
                    : null,
                child: const Text(
                  "START EXAM",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable instruction text widget
class InstructionText extends StatelessWidget {
  final String text;
  final bool isWarning;

  const InstructionText(
      this.text, {
        super.key,
        this.isWarning = false,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarning ? Icons.warning_amber_rounded : Icons.circle,
            size: isWarning ? 22 : 8,
            color: isWarning ? Colors.red : Colors.black,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
                color: isWarning ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
