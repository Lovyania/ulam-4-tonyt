import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBbMp8CIK3b752_Gv9_PQtLp9TM0n-5LbU",
          appId: "1:202171125123:web:eda8295f04c38ae128bab6",
          messagingSenderId: "202171125123",
          projectId: "ulam4tonyt"));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edamam Recipe Search',
      home: RecipeSearchPage(),
    );
  }
}
