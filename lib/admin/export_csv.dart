import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> exportResultsToCSV(BuildContext context) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('attempts')
      .where('status', isEqualTo: 'submitted')
      .orderBy('score', descending: true)
      .get();

  if (snapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No data to export")),
    );
    return;
  }

  final buffer = StringBuffer();
  buffer.writeln("Rank,Name,Score,Total Marks");

  for (int i = 0; i < snapshot.docs.length; i++) {
    final d = snapshot.docs[i];
    buffer.writeln(
      "${i + 1},${d['name']},${d['score']},${d['totalMarks']}",
    );
  }

  final bytes = buffer.toString();
  final blob = html.Blob([bytes], 'text/csv');
  final url = html.Url.createObjectUrlFromBlob(blob);

  html.AnchorElement(href: url)
    ..setAttribute("download", "exam_results.csv")
    ..click();

  html.Url.revokeObjectUrl(url);
}
