import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/screens/home.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';
import 'package:ulam_4_tonyt/screens/signup.dart';
import 'package:ulam_4_tonyt/utils/color_utils.dart';
import '../reusable_widgets/reusable_widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RecipeSearchPage())),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringColor("FFABAB"),
                hexStringColor("FFABAB"),
                hexStringColor("FFABAB")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                  child: Column(
                      children: <Widget>[
                        logoWidget("assets/LOGO.png"),
                        SizedBox(
                          height: 30,
                        ),
                        reusableTextField("Enter Your Email", Icons.person_outline, false, _emailTextController),
                        SizedBox(
                          height: 30,
                        ),
                        reusableTextField("Enter Your Password", Icons.lock_outline, true, _passwordTextController),
                        SizedBox(
                          height: 30,
                        ),
                        loginSignupButton(context, true, (){
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text).then((value){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => RecipeSearchPage()));
                          });
                        }),
                        signupOption()
                      ]
                  )
              )
          )
      ),
    );
  }
  Row signupOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => signup()));
          },
          child: const Text(
              " Sign Up Here! ",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
        )
      ],
    );
  }
}
