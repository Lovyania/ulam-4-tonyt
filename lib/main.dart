import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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
          body: Column(
            children: [
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
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Image.network(
                        'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                        height: 64.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24.0),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Image.network(
                        'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                        height: 64.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24.0),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Image.network(
                        'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                        height: 64.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24.0),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Image.network(
                        'https://cf.shopee.ph/file/712f1fcc094e5d3fd3a2407e07077539',
                        height: 64.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24.0),
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                    ),
                  ],
                ),
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
