import 'package:flutter/material.dart';

// student
import 'auth/register_page.dart';
import 'auth/login_page.dart';

// admin
import 'admin/admin_login_page.dart';
import 'admin/admin_register_page.dart';
import 'admin/admin_dashboard.dart';

class AppRoutes {
  // student
  static const studentRegister = '/';
  static const studentLogin = '/login';

  // admin
  static const adminLogin = '/admin';
  static const adminRegister = '/admin/register';
  static const adminDashboard = '/admin/dashboard';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case studentRegister:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case studentLogin:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());

      case adminRegister:
        return MaterialPageRoute(builder: (_) => const AdminRegisterPage());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("404 - Page not found")),
          ),
        );
    }
  }
}
