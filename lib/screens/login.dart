import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/screens/home.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';
import 'package:ulam_4_tonyt/screens/profile.dart';
import 'package:ulam_4_tonyt/screens/signup.dart';
import 'package:ulam_4_tonyt/screens/spinwheelscreen.dart';
import 'package:ulam_4_tonyt/utils/color_utils.dart';
import '../reusable_widgets/reusable_widgets.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    ),
  );

  Widget buildHeader(BuildContext context) => Material(
      color: Colors.green,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(),
          ));
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                    'https://www.citypng.com/public/uploads/preview/white-user-member-guest-icon-png-image-31634946729lnhivlto5f.png'),
              ),
              SizedBox(height: 12),
              Text(
                'Flutter App',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ));
  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => RecipeSearchPage(),
              )),
        ),
        ListTile(
          leading: const Icon(Icons.login_outlined),
          title: const Text('Log In'),
          onTap: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Login(),
              )),
        ),
        ListTile(
          leading: const Icon(Icons.workspaces_outline),
          title: const Text('Food Roulette'),
          onTap: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SpinWheel(),
              )),
        ),
      ],
    ),
  );
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey, // Add a key to the Scaffold widget
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer(); // Use the GlobalKey to get a reference to the ScaffoldState
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
                  child: Column(
                      children: <Widget>[
                        logoWidget("assets/user.jpg"),
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
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => signup()));
          },
          child: const Text(
              " Sign Up Here! ",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
        )
      ],
    );
  }
}
