import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulam_4_tonyt/reusable_widgets/side_menu.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _usernameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
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
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: Colors.orangeAccent,
                          ),
                          title: Text(
                            'Bookmarks',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
