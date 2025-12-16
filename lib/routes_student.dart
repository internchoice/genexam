import 'package:flutter/material.dart';

// student pages
import 'auth/register_page.dart';
import 'auth/login_page.dart';
import 'exam/exam_instruction_page.dart';
import 'exam/exam_page.dart';

class StudentRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {

    // 🔹 Student Registration (default)
      case '/':
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );

    // 🔹 Student Login
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

    // 🔹 Exam Instructions
      case '/exam-instructions':
        return MaterialPageRoute(
          builder: (_) => const ExamInstructionPage(),
        );

    // 🔹 Exam Screen
      case '/exam':
        return MaterialPageRoute(
          builder: (_) => const ExamPage(),
        );

    // ❌ BLOCK EVERYTHING ELSE (including /admin)
      default:
        return _accessDenied();
    }
  }

  static Route<dynamic> _accessDenied() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text(
            'Access Denied',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
