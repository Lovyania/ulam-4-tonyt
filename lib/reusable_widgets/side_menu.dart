import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ulam_4_tonyt/screens/history.dart';

import 'package:ulam_4_tonyt/screens/profile.dart';
import 'package:ulam_4_tonyt/screens/login.dart';
import 'package:ulam_4_tonyt/screens/spinwheelscreen.dart';
import 'package:ulam_4_tonyt/screens/newhome.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

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
          if (FirebaseAuth.instance.currentUser == null) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ProfilePage()));
          }
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
                backgroundImage: AssetImage('assets/users.png'),
              ),
              SizedBox(height: 12),
              FirebaseAuth.instance.currentUser == null
                  ? Text('Guest', style: TextStyle(fontSize: 24, color: Colors.white))
                  : Text(
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      'Welcome!'),
              FirebaseAuth.instance.currentUser == null
                  ? Text('Sign Up to access other features!', style: TextStyle(fontSize: 16, color: Colors.white))
                  : Text(
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
              leading: const Icon(Icons.workspaces_outline),
              title: const Text('Food Roulette'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SpinWheel(),
              )),
            ),
            FirebaseAuth.instance.currentUser == null
                ? ListTile(
                    leading: const Icon(Icons.login_outlined),
                    title: const Text('Log In'),
                    onTap: () =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    )),
                  )
                : Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.history_outlined),
                        title: const Text('History'),
                        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HistoryPage(history: [],),
                        )),
                      ),
                      SizedBox(height: 18),
                      ListTile(
                        leading: const Icon(Icons.logout_outlined),
                        title: const Text('Log Out'),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => RecipeSearchPage(),
                          ));
                        },
                      ),
                    ],
                ),
          ],
        ),
      );
}
