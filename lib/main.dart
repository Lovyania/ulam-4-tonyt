import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "9ab562577b709b59d7518e6ca96cc2f5",
          appId: "c6b66230",
          messagingSenderId: "202171125123",
          projectId: "ulam4tonyt"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edamam Recipe Search',
      home: RecipeSearchPage(),
    );
  }
}
