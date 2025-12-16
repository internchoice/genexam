import 'package:flutter/material.dart';

// student
import 'auth/register_page.dart';
import 'auth/login_page.dart';

// admin
import 'admin/admin_login_page.dart';
import 'admin/admin_register_page.dart';
import 'admin/admin_dashboard.dart';

class AppRoutes {
  static const studentRegister = '/';
  static const studentLogin = '/login';

  static const adminLogin = '/admin';
  static const adminRegister = '/admin/register';
  static const adminDashboard = '/admin/dashboard';

  static Route<dynamic> generate(RouteSettings settings) {
    final String path = settings.name ?? '/';

    // 🔐 ADMIN ROUTES (MATCH FIRST)
    if (path == adminLogin) {
      return MaterialPageRoute(builder: (_) => const AdminLoginPage());
    }

    if (path == adminRegister) {
      return MaterialPageRoute(builder: (_) => const AdminRegisterPage());
    }

    if (path == adminDashboard) {
      return MaterialPageRoute(builder: (_) => const AdminDashboard());
    }

    // 👨‍🎓 STUDENT ROUTES
    if (path == studentLogin) {
      return MaterialPageRoute(builder: (_) => const LoginPage());
    }

    if (path == studentRegister) {
      return MaterialPageRoute(builder: (_) => const RegisterPage());
    }

    // ❌ UNKNOWN ROUTE → 404 (NOT student register)
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('404 – Page not found')),
      ),
    );
  }
}
