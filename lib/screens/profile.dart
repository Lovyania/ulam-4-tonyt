import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulam_4_tonyt/screens/spinwheelscreen.dart';

import 'login.dart';
import 'newhome.dart';

void main() {
  runApp(Profile());
}

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

class Profile extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _usernameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        key: _scaffoldKey, // Add a key to the Scaffold widget
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer(); // Use the GlobalKey to get a reference to the ScaffoldState
            },
          ),
        ),
        body: Container(
          color: Colors.lightGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                maxRadius: 70,
                backgroundImage: AssetImage("assets/users.png"),
              ),
              SizedBox(height: 30),
              Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Profile',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: Colors.orangeAccent,
                          ),
                          title: Text(
                            'Bookmarks',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        Divider(height: 20, color: Colors.grey),
                        ListTile(
                          leading: Icon(
                            Icons.restaurant_menu,
                            color: Colors.orangeAccent,
                          ),
                          title: Text(
                            'Recipes',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
