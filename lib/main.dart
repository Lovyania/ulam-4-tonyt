import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ulam_4_tonyt/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: "AIzaSyBbMp8CIK3b752_Gv9_PQtLp9TM0n-5LbU",
    appId: "1:202171125123:web:eda8295f04c38ae128bab6",
    messagingSenderId: "202171125123",
    projectId: "ulam4tonyt"
  ));
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class RecipeSearchBar extends StatefulWidget {
  @override
  _RecipeSearchBarState createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends State<RecipeSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Recipes',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
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
      color: Colors.blue.shade700,
      child: InkWell(
        onTap: () {
          // User can click to navigate to user profile page
          // Navigator.pop(context);
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => UserPage(),
          // ));
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: Column(
            children: const [
              CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                    'https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/60320/angry-emoji-clipart-xl.png'),
              ),
              SizedBox(height: 12),
              Text(
                'Flutter App',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              Text(
                'example@email.com',
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
                builder: (context) => MyApp(),
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Updates'),
              onTap: () {},
            ),
            const Divider(color: Colors.black),
            ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text('Plugins'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              onTap: () {},
            ),
          ],
        ),
      );
}

class _MyAppState extends State<MyApp> {
  List<dynamic> recipeData = [];

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/search?q=chicken&app_id=cd4b33ae&app_key=8583514940e95377b00342510d52d724'));
    final data = json.decode(response.body);
    setState(() {
      recipeData =
          data['hits'].map((recipe) => recipe['recipe']).toList().sublist(0, 4);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Recipe App'),
          ),
          drawer: const NavigationDrawer(),
          body: Column(
            children: [
              RecipeSearchBar(),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Image.network(
                            'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                            height: 42.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(24.0),
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Breakfast'),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Image.network(
                            'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                            height: 42.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(24.0),
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Lunch'),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Image.network(
                            'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                            height: 42.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(24.0),
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Dinner'),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Image.network(
                            'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                            height: 42.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(24.0),
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Appetizer'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Recommendations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: recipeData.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : LayoutBuilder(
                        builder: (context, constraints) => GridView.count(
                          crossAxisCount: constraints.maxWidth > 600
                              ? 4
                              : 2, // Change the number of columns based on screen width
                          childAspectRatio:
                              0.75, // Adjust the aspect ratio of the cards
                          padding:
                              EdgeInsets.all(8.0), // Add padding between cards
                          children: List.generate(recipeData.length, (index) {
                            final recipeImageURL = recipeData[index]['image'];
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    'https://pbs.twimg.com/media/FXnfSbfXgAIBK6Z.png',
                                    height: 100.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      recipeData[index]['label'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
