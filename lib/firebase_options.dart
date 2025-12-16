import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get web => const FirebaseOptions(
    apiKey: "AIzaSyA4YmMgOxXfw60KOHYDe_dOXt-Y2Byr4S0",
    authDomain: "exam-fd0ef.firebaseapp.com",
    projectId: "exam-fd0ef",
    storageBucket: "exam-fd0ef.firebasestorage.app",
    messagingSenderId: "334530970486",
    appId: "1:334530970486:web:07c04629296c37db7e3057",
  );

  static FirebaseOptions get android => web;
  static FirebaseOptions get ios => web;
}
