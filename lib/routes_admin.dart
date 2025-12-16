import 'package:flutter/material.dart';
import 'admin/admin_login_page.dart';
import 'admin/admin_dashboard.dart';
import 'admin/manage_questions_page.dart';
import 'admin/admin_results_page.dart';

class AdminRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());

      case '/admin/dashboard':
        return MaterialPageRoute(builder: (_) => const AdminDashboard());

      case '/admin/questions':
        return MaterialPageRoute(builder: (_) => const ManageQuestionsPage());

      // case '/admin/results':
      //   return MaterialPageRoute(builder: (_) => const AdminResultsPage());
      case '/admin/results':
        return MaterialPageRoute(builder: (_) => const AdminResultsPage());


      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Admin route not found')),
          ),
        );
    }
  }
}
