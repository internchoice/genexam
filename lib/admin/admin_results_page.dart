// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class AdminResultsPage extends StatelessWidget {
// //   const AdminResultsPage({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF4F6FA),
// //       appBar: AppBar(
// //         title: const Text("Exam Results"),
// //         centerTitle: true,
// //         backgroundColor: Colors.blue.shade700,
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FirebaseFirestore.instance
// //             .collection('attempts')
// //             .where('status', isEqualTo: 'submitted')
// //             .snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.hasError) {
// //             return Center(
// //               child: Text(
// //                 "Error: ${snapshot.error}",
// //                 textAlign: TextAlign.center,
// //                 style: const TextStyle(color: Colors.red),
// //               ),
// //             );
// //           }
// //
// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //
// //           final docs = snapshot.data!.docs;
// //
// //           if (docs.isEmpty) {
// //             return const Center(
// //               child: Text(
// //                 "No submissions yet",
// //                 style: TextStyle(fontSize: 16, color: Colors.grey),
// //               ),
// //             );
// //           }
// //
// //           // Sort by score DESC, then end time ASC
// //           docs.sort((a, b) {
// //             final int scoreA = (a['score'] as num).toInt();
// //             final int scoreB = (b['score'] as num).toInt();
// //             if (scoreA != scoreB) return scoreB.compareTo(scoreA);
// //
// //             final Timestamp timeA = a['endedAt'];
// //             final Timestamp timeB = b['endedAt'];
// //             return timeA.compareTo(timeB);
// //           });
// //
// //           return ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: docs.length,
// //             itemBuilder: (context, index) {
// //               final data = docs[index];
// //               final rank = index + 1;
// //               final score = data['score'] ?? 0;
// //               final totalMarks = data['totalMarks'] ?? 0;
// //
// //               return Card(
// //                 margin: const EdgeInsets.only(bottom: 12),
// //                 elevation: 3,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                   child: Row(
// //                     children: [
// //                       _rankWidget(rank),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               data['name'] ?? "Unknown",
// //                               style: const TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 16,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 4),
// //                             Text(
// //                               "Score: $score / $totalMarks",
// //                               style: const TextStyle(
// //                                 color: Colors.grey,
// //                                 fontSize: 14,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Text(
// //                         "#$rank",
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 18,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _rankWidget(int rank) {
// //     switch (rank) {
// //       case 1:
// //         return const Text("🥇", style: TextStyle(fontSize: 26));
// //       case 2:
// //         return const Text("🥈", style: TextStyle(fontSize: 26));
// //       case 3:
// //         return const Text("🥉", style: TextStyle(fontSize: 26));
// //       default:
// //         return const Icon(Icons.person, color: Colors.grey);
// //     }
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AdminResultsPage extends StatefulWidget {
//   const AdminResultsPage({super.key});
//
//   @override
//   State<AdminResultsPage> createState() => _AdminResultsPageState();
// }
//
// class _AdminResultsPageState extends State<AdminResultsPage> {
//
//   String _selectedDomain = "Web";
//
//   final List<String> _domains = [
//     "Web",
//     "Flutter",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FA),
//       appBar: AppBar(
//         title: const Text("Exam Results"),
//         centerTitle: true,
//         backgroundColor: Colors.blue.shade700,
//       ),
//       body: Column(
//         children: [
//
//           // 🔥 DOMAIN DROPDOWN
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: DropdownButtonFormField<String>(
//               value: _selectedDomain,
//               decoration: InputDecoration(
//                 labelText: "Filter by Domain",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               items: _domains.map((domain) {
//                 return DropdownMenuItem(
//                   value: domain,
//                   child: Text(domain),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedDomain = value!;
//                 });
//               },
//             ),
//           ),
//
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('attempts')
//                   .where('status', isEqualTo: 'submitted')
//                   .where('domain', isEqualTo: _selectedDomain)
//                   .snapshots(),
//               builder: (context, snapshot) {
//
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       "Error: ${snapshot.error}",
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   );
//                 }
//
//                 if (!snapshot.hasData) {
//                   return const Center(
//                       child: CircularProgressIndicator());
//                 }
//
//                 final docs = snapshot.data!.docs;
//
//                 if (docs.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No submissions for this domain.",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   );
//                 }
//
//                 // 🔥 SORT BY SCORE DESC THEN TIME ASC
//                 docs.sort((a, b) {
//                   final int scoreA = (a['score'] as num).toInt();
//                   final int scoreB = (b['score'] as num).toInt();
//                   if (scoreA != scoreB) {
//                     return scoreB.compareTo(scoreA);
//                   }
//
//                   final Timestamp timeA = a['endedAt'];
//                   final Timestamp timeB = b['endedAt'];
//                   return timeA.compareTo(timeB);
//                 });
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//
//                     final data = docs[index];
//                     final rank = index + 1;
//                     final score = data['score'] ?? 0;
//                     final totalMarks = data['totalMarks'] ?? 0;
//
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       elevation: 3,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12),
//                         child: Row(
//                           children: [
//                             _rankWidget(rank),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     data['name'] ?? "Unknown",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "Domain: ${data['domain']}",
//                                     style: const TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.blueGrey,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Score: $score / $totalMarks",
//                                     style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Text(
//                               "#$rank",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _rankWidget(int rank) {
//     switch (rank) {
//       case 1:
//         return const Text("🥇", style: TextStyle(fontSize: 26));
//       case 2:
//         return const Text("🥈", style: TextStyle(fontSize: 26));
//       case 3:
//         return const Text("🥉", style: TextStyle(fontSize: 26));
//       default:
//         return const Icon(Icons.person, color: Colors.grey);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminResultsPage extends StatefulWidget {
  const AdminResultsPage({super.key});

  @override
  State<AdminResultsPage> createState() => _AdminResultsPageState();
}

class _AdminResultsPageState extends State<AdminResultsPage> {

  String _selectedDomain = "Web";

  final List<String> _domains = ["Web", "Flutter"];

  Future<void> _downloadPdf(List<QueryDocumentSnapshot> docs) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [

          pw.Text(
            "Exam Results - $_selectedDomain",
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headers: ["Rank", "Name", "Score"],
            data: List.generate(docs.length, (index) {
              final data = docs[index];
              final score = data['score'] ?? 0;
              final total = data['totalMarks'] ?? 0;

              return [
                "${index + 1}",
                data['name'] ?? "Unknown",
                "$score / $total",
              ];
            }),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Exam Results"),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Download PDF",
            onPressed: () async {

              final snapshot = await FirebaseFirestore.instance
                  .collection('attempts')
                  .where('status', isEqualTo: 'submitted')
                  .where('domain', isEqualTo: _selectedDomain)
                  .get();

              final docs = snapshot.docs;

              docs.sort((a, b) {
                final int scoreA = (a['score'] as num).toInt();
                final int scoreB = (b['score'] as num).toInt();
                return scoreB.compareTo(scoreA);
              });

              await _downloadPdf(docs);
            },
          )
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedDomain,
              decoration: InputDecoration(
                labelText: "Filter by Domain",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _domains.map((domain) {
                return DropdownMenuItem(
                  value: domain,
                  child: Text(domain),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDomain = value!;
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attempts')
                  .where('status', isEqualTo: 'submitted')
                  .where('domain', isEqualTo: _selectedDomain)
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No submissions found."),
                  );
                }

                docs.sort((a, b) {
                  final int scoreA = (a['score'] as num).toInt();
                  final int scoreB = (b['score'] as num).toInt();
                  return scoreB.compareTo(scoreA);
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    final rank = index + 1;
                    final score = data['score'];
                    final total = data['totalMarks'];

                    return Card(
                      child: ListTile(
                        leading: Text("#$rank"),
                        title: Text(data['name'] ?? "Unknown"),
                        subtitle: Text("Score: $score / $total"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
