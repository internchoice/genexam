import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// apps
import 'student_app.dart';
import 'admin_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  final String path = Uri.base.path;

  // 🔥 CRITICAL: Decide app BEFORE UI loads
  if (path.startsWith('/admin')) {
    runApp(const AdminApp());
  } else {
    runApp(const StudentApp());
  }
}
