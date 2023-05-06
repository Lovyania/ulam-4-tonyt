import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/reusable_widgets/reusable_widgets.dart';
import 'package:ulam_4_tonyt/screens/home.dart';
import 'package:ulam_4_tonyt/screens/login.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';
import 'package:ulam_4_tonyt/utils/color_utils.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [hexStringColor("FFFFFF"),
                  hexStringColor("FFFFFF"),
                  hexStringColor("FFFFFF")], begin: Alignment.topCenter, end: Alignment.bottomCenter )),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20,MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(
                        children: <Widget>[
                          logoWidget("assets/user.jpg"),
                          const SizedBox(
                            height: 20,
                          ),
                          reusableTextField("Enter Username", Icons.person_outline, false, _usernameTextController),
                          const SizedBox(
                            height: 20,
                          ),
                          reusableTextField("Enter Email ID", Icons.person_outline, false, _emailTextController),
                          const SizedBox(
                            height: 20,
                          ),
                          reusableTextField("Enter Password", Icons.person_outline, true, _passwordTextController),
                          const SizedBox(
                            height: 20,
                          ),
                          loginSignupButton(context, false,(){
                            FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text,
                                password: _passwordTextController.text)
                                .then((value){
                              print("Account is Registered and Created");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => RecipeSearchPage()));
                            }).onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                          })
                        ]
                    )
                )
            )
        )
    );
  }
}