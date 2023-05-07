import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/reusable_widgets/side_menu.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';
import 'package:ulam_4_tonyt/screens/signup.dart';
import 'package:ulam_4_tonyt/utils/color_utils.dart';
import '../reusable_widgets/reusable_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add a key to the Scaffold widget
      drawer: const DrawerMenu(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!
                .openDrawer(); // Use the GlobalKey to get a reference to the ScaffoldState
          },
        ),
        title: Text('Log In'),
        backgroundColor: Colors.green,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringColor("FFFFFF"),
            hexStringColor("FFFFFF"),
            hexStringColor("FFFFFF")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                  child: Column(children: <Widget>[
                    logoWidget("assets/user.jpg"),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Your Email", Icons.person_outline,
                        false, _emailTextController),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Your Password", Icons.lock_outline,
                        true, _passwordTextController),
                    SizedBox(
                      height: 30,
                    ),
                    loginSignupButton(context, true, () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        setState(() {
                          _errorMessage = null;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeSearchPage()));
                      }).catchError((error) {
                        setState(() {
                          _errorMessage = "Invalid email or password";
                        });
                      });
                    }),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    signupOption()
                  ])))),
    );
  }

  Row signupOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignupPage()));
          },
          child: const Text(" Sign Up Here! ",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
