import 'package:flutter/material.dart';
import 'auth/register_page.dart';
import 'auth/login_page.dart';
import 'admin/admin_login_page.dart';
import 'admin/admin_dashboard.dart';
import 'admin/add_question_page.dart';

class AppRoutes {
  static const register = '/';
  static const login = '/login';

  static const adminLogin = '/admin';
  static const adminDashboard = '/admin/dashboard';
  static const addQuestion = '/admin/add-question';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());

      case addQuestion:
        return MaterialPageRoute(builder: (_) => const AddQuestionPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("404 - Page not found")),
          ),
        );
    }
  }
}
