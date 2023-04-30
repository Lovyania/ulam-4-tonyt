import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ulam_4_tonyt/screens/login.dart';
import 'package:ulam_4_tonyt/screens/spinwheelscreen.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return const TextField(
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
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SpinWheel(),
              )),
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
  int _recipeCount = 20;

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
      theme: ThemeData(primarySwatch: Colors.green),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Ulam 4 Tonyt'),
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://www.foodnetwork.com/recipes/photos/our-best-breakfast-recipes')),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://media.cnn.com/api/v1/images/stellar/prod/220217215855-01-filipino-breakfast-longsilog.jpg?q=h_2133,w_3469,x_0,y_0/w_1280',
                              ),
                              radius: 42,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Breakfast'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://www.allrecipes.com/recipes/16376/healthy-recipes/lunches/')),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://www.realsimple.com/thmb/rwSxx97nZcOoBb-dZ1ouGqSn-Q4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/gut-healthy-lunch-GettyImages-1042075090-b21164b3fffe49af8868078e224a3e79.jpg',
                              ),
                              radius: 42,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Lunch'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://www.tasteofhome.com/collection/classic-comfort-food-dinners/')),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://www.realsimple.com/thmb/fMh6cWLYxsddO3BuSJXanCk1gpI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/easy-dinner-recipes-f768402675e04452b1531360736da8b5.jpg',
                              ),
                              radius: 42,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Dinner'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://www.loveandlemons.com/appetizers/')),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://images.eatsmarter.com/sites/default/files/styles/1600x1200/public/egg-salad-appetizers-613108.jpg',
                              ),
                              radius: 42,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Appetizer'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://www.foodnetwork.com/recipes/photos/50-quick-snack-recipes')),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Chex-Mix-Pile.jpg/640px-Chex-Mix-Pile.jpg',
                              ),
                              radius: 42,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Snack'),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(
                                'https://www.allrecipes.com/recipes/77/drinks/')),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://www.thespruceeats.com/thmb/PKK63OuoTMaezzPYvaq2fy-TB5Y=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/bar101-cocktails-504754220-580e83415f9b58564cf470b9.jpg',
                              ),
                              radius: 42,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Drinks'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
                          padding: const EdgeInsets.all(
                              8.0), // Add padding between cards
                          children: List.generate(recipeData.length, (index) {
                            final recipeImageURL = recipeData[index]['image'];
                            return GestureDetector(
                              onTap: () async {
                                final recipeURL = recipeData[index]['url'];
                                if (await canLaunchUrl(recipeURL)) {
                                  await launchUrl(recipeURL);
                                } else {
                                  throw 'Could not launch $recipeURL';
                                }
                              },
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      recipeImageURL,
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
                backgroundColor: Colors.green,
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
