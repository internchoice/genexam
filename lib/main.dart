import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🌐 IMPORTANT FOR WEB (deep links like /admin)
      onGenerateRoute: AppRoutes.generate,

      // 🔑 Decide initial screen
      home: const RootDecider(),
    );
  }
}

///
/// This widget decides what to show on fresh load
/// without mixing admin & student flows
///
class RootDecider extends StatelessWidget {
  const RootDecider({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 🔹 Not logged in → Student Registration (default)
    if (user == null) {
      return Navigator(
        onGenerateRoute: (_) =>
            AppRoutes.generate(const RouteSettings(name: AppRoutes.studentRegister)),
      );
    }

    // 🔹 Logged in → Student Login or Exam (later logic can be added)
    return Navigator(
      onGenerateRoute: (_) =>
          AppRoutes.generate(const RouteSettings(name: AppRoutes.studentLogin)),
    );
  }
}
