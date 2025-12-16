import 'package:flutter/material.dart';
import 'routes_admin.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/admin',
      onGenerateRoute: AdminRoutes.generate,
    );
  }
}
