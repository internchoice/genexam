// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AddQuestionPage extends StatefulWidget {
//   const AddQuestionPage({super.key});
//
//   @override
//   State<AddQuestionPage> createState() => _AddQuestionPageState();
// }
//
// class _AddQuestionPageState extends State<AddQuestionPage> {
//   final _questionCtrl = TextEditingController();
//   final _marksCtrl = TextEditingController(text: "1");
//
//   final List<TextEditingController> _options =
//   List.generate(4, (_) => TextEditingController());
//
//   int? _correctIndex;
//   bool _loading = false;
//
//   Future<void> _save() async {
//     if (_questionCtrl.text.trim().isEmpty) {
//       _error("Question is required");
//       return;
//     }
//
//     for (int i = 0; i < 4; i++) {
//       if (_options[i].text.trim().isEmpty) {
//         _error("Option ${i + 1} cannot be empty");
//         return;
//       }
//     }
//
//     if (_correctIndex == null) {
//       _error("Please mark the correct answer");
//       return;
//     }
//
//     final marks = int.tryParse(_marksCtrl.text.trim());
//     if (marks == null || marks <= 0) {
//       _error("Marks must be a positive number");
//       return;
//     }
//
//     setState(() => _loading = true);
//
//     await FirebaseFirestore.instance.collection('questions').add({
//       'question': _questionCtrl.text.trim(),
//       'options': _options.map((e) => e.text.trim()).toList(),
//       'correctIndex': _correctIndex,
//       'marks': marks,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//
//     if (!mounted) return;
//     Navigator.pop(context);
//   }
//
//   void _toggleCorrect(int index, bool? value) {
//     setState(() {
//       _correctIndex = value == true ? index : null;
//     });
//   }
//
//   void _error(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isWideScreen = screenWidth > 600;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Question")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: isWideScreen ? 600 : double.infinity),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Question input
//                 TextField(
//                   controller: _questionCtrl,
//                   decoration: InputDecoration(
//                     labelText: "Question",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   maxLines: 2,
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Options
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       children: List.generate(4, (i) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Checkbox(
//                                 value: _correctIndex == i,
//                                 onChanged: (v) => _toggleCorrect(i, v),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: TextField(
//                                   controller: _options[i],
//                                   decoration: InputDecoration(
//                                     labelText: "Option ${i + 1}",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Marks input
//                 TextField(
//                   controller: _marksCtrl,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Marks",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // Save button
//                 SizedBox(
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _loading ? null : _save,
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       backgroundColor: Colors.blue.shade700,
//                     ),
//                     child: _loading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                       "Save Question",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white,),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AddQuestionPage extends StatefulWidget {
//   const AddQuestionPage({super.key});
//
//   @override
//   State<AddQuestionPage> createState() => _AddQuestionPageState();
// }
//
// class _AddQuestionPageState extends State<AddQuestionPage> {
//   final _questionCtrl = TextEditingController();
//   final _marksCtrl = TextEditingController(text: "1");
//
//   final List<TextEditingController> _options =
//   List.generate(4, (_) => TextEditingController());
//
//   int? _correctIndex;
//   bool _loading = false;
//
//   // 🔥 SECTION VARIABLES
//   String _selectedSection = "Web";
//
//   final List<String> _sections = [
//     "Web",
//     "Flutter",
//     "Quantitative Aptitude",
//     "Verbal Ability",
//     "Reasoning",
//   ];
//
//   // Future<void> _save() async {
//   //   if (_questionCtrl.text.trim().isEmpty) {
//   //     _error("Question is required");
//   //     return;
//   //   }
//   //
//   //   for (int i = 0; i < 4; i++) {
//   //     if (_options[i].text.trim().isEmpty) {
//   //       _error("Option ${i + 1} cannot be empty");
//   //       return;
//   //     }
//   //   }
//   //
//   //   if (_correctIndex == null) {
//   //     _error("Please mark the correct answer");
//   //     return;
//   //   }
//   //
//   //   final marks = int.tryParse(_marksCtrl.text.trim());
//   //   if (marks == null || marks <= 0) {
//   //     _error("Marks must be a positive number");
//   //     return;
//   //   }
//   //
//   //   setState(() => _loading = true);
//   //
//   //   await FirebaseFirestore.instance.collection('questions').add({
//   //     'question': _questionCtrl.text.trim(),
//   //     'options': _options.map((e) => e.text.trim()).toList(),
//   //     'correctIndex': _correctIndex,
//   //     'marks': marks,
//   //     'section': _selectedSection, // ✅ Section stored
//   //     'createdAt': FieldValue.serverTimestamp(),
//   //   });
//   //
//   //   if (!mounted) return;
//   //   Navigator.pop(context);
//   // }
//   Future<void> _save() async {
//     if (_questionCtrl.text.trim().isEmpty) {
//       _error("Question is required");
//       return;
//     }
//
//     for (int i = 0; i < 4; i++) {
//       if (_options[i].text.trim().isEmpty) {
//         _error("Option ${i + 1} cannot be empty");
//         return;
//       }
//     }
//
//     if (_correctIndex == null) {
//       _error("Please mark the correct answer");
//       return;
//     }
//
//     final marks = int.tryParse(_marksCtrl.text.trim());
//     if (marks == null || marks <= 0) {
//       _error("Marks must be a positive number");
//       return;
//     }
//
//     setState(() => _loading = true);
//
//     await FirebaseFirestore.instance.collection('questions').add({
//       'question': _questionCtrl.text.trim(),
//       'options': _options.map((e) => e.text.trim()).toList(),
//       'correctIndex': _correctIndex,
//       'marks': marks,
//       'section': _selectedSection,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//
//     if (!mounted) return;
//
//     // 🔥 Clear form instead of going back
//     _questionCtrl.clear();
//     _marksCtrl.text = "1";
//     for (var controller in _options) {
//       controller.clear();
//     }
//
//     setState(() {
//       _correctIndex = null;
//       _loading = false;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Question added successfully")),
//     );
//   }
//
//   void _toggleCorrect(int index, bool? value) {
//     setState(() {
//       _correctIndex = value == true ? index : null;
//     });
//   }
//
//   void _error(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isWideScreen = screenWidth > 600;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Question")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: ConstrainedBox(
//             constraints:
//             BoxConstraints(maxWidth: isWideScreen ? 600 : double.infinity),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//
//                 // 🔥 SECTION DROPDOWN
//                 DropdownButtonFormField<String>(
//                   value: _selectedSection,
//                   decoration: InputDecoration(
//                     labelText: "Section",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   items: _sections.map((section) {
//                     return DropdownMenuItem(
//                       value: section,
//                       child: Text(section),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedSection = value!;
//                     });
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Question input
//                 TextField(
//                   controller: _questionCtrl,
//                   decoration: InputDecoration(
//                     labelText: "Question",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   maxLines: 2,
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Options Card
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       children: List.generate(4, (i) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Checkbox(
//                                 value: _correctIndex == i,
//                                 onChanged: (v) => _toggleCorrect(i, v),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: TextField(
//                                   controller: _options[i],
//                                   decoration: InputDecoration(
//                                     labelText: "Option ${i + 1}",
//                                     border: OutlineInputBorder(
//                                       borderRadius:
//                                       BorderRadius.circular(12),
//                                     ),
//                                     contentPadding:
//                                     const EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 10),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Marks input
//                 TextField(
//                   controller: _marksCtrl,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Marks",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // Save button
//                 SizedBox(
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _loading ? null : _save,
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       backgroundColor: Colors.blue.shade700,
//                     ),
//                     child: _loading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                       "Save Question",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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

  // 🔹 Section
  String _selectedSection = "Web";

  final List<String> _sections = [
    "Web",
    "Flutter",
    "Quantitative Aptitude",
    "Verbal Ability",
    "Reasoning",
  ];

  int _currentSrNo = 1;

  @override
  void initState() {
    super.initState();
    _loadSrNo();
  }

  // 🔥 Load SR NO dynamically
  Future<void> _loadSrNo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('section', isEqualTo: _selectedSection)
        .get();

    setState(() {
      _currentSrNo = snapshot.docs.length + 1;
    });
  }

  Future<void> _save() async {
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
      'correctIndex': _correctIndex,
      'marks': marks,
      'section': _selectedSection,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    // 🔄 Reset form
    _questionCtrl.clear();
    _marksCtrl.text = "1";
    for (var c in _options) {
      c.clear();
    }

    setState(() {
      _correctIndex = null;
      _loading = false;
    });

    // 🔥 Update SR NO for next question
    await _loadSrNo();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Question added (SR No: $_currentSrNo)")),
    );
  }

  void _toggleCorrect(int index, bool? value) {
    setState(() {
      _correctIndex = value == true ? index : null;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // 🔹 Section Dropdown
            DropdownButtonFormField<String>(
              value: _selectedSection,
              decoration: InputDecoration(
                labelText: "Section",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _sections
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) async {
                setState(() {
                  _selectedSection = value!;
                });
                await _loadSrNo();
              },
            ),

            const SizedBox(height: 16),

            // 🔥 SR NO DISPLAY (BEFORE QUESTION FIELD)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_list_numbered, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    "SR No : $_currentSrNo",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Question
            TextField(
              controller: _questionCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Options
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: List.generate(4, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
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
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Marks
            TextField(
              controller: _marksCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Marks",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Save Question",
                  style: TextStyle(
                    fontSize: 16,
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
