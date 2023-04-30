import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "8583514940e95377b00342510d52d724",
          appId: "cd4b33ae",
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
