import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'package:ulam_4_tonyt/reusable_widgets/side_menu.dart';

class RecipeSearchPage extends StatefulWidget {
  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  List<dynamic> _searchResults = [];

  String _searchQuery = '';
  String _mealType = '';
  String _cuisineType = 'World';

  final List<String> _cuisineTypes = [
    'World',
    'American',
    'Asian',
    'British',
    'Caribbean',
    'Central Europe',
    'Chinese',
    'Eastern Europe',
    'French',
    'Indian',
    'Italian',
    'Japanese',
    'Kosher',
    'Mediterranean',
    'Mexican',
    'Middle Eastern',
    'Nordic',
    'South American',
    'South East Asian'
  ];

  int _totalResults = 0;
  int _currentPage = 0;
  final int _perPage = 10;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      if (_searchQuery != newQuery) {
        _searchQuery = newQuery;
        _searchResults.clear();
      }
    });
  }

  Future<void> _searchRecipes() async {
    const appId = 'c6b66230';
    const appKey = '9ab562577b709b59d7518e6ca96cc2f5';
    final url =
        'https://api.edamam.com/search?q=$_searchQuery&cuisineType=$_cuisineType&app_id=$appId&app_key=$appKey&from=$_currentPage&to=${_currentPage + _perPage}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['hits'];
      final total = jsonDecode(response.body)['count'];
      setState(() {
        _searchResults.addAll(data);
        _totalResults = total;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _querybyMealType() async {
    const appId = 'c6b66230';
    const appKey = '9ab562577b709b59d7518e6ca96cc2f5';
    final url =
        'https://api.edamam.com/search?q=$_mealType&app_id=$appId&app_key=$appKey&from=$_currentPage&to=${_currentPage + _perPage}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['hits'];
      final total = jsonDecode(response.body)['count'];
      setState(() {
        _searchResults.addAll(data);
        _totalResults = total;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_searchResults.length < _totalResults) {
          setState(() {
            _currentPage += _perPage;
          });
          _searchRecipes();
          _querybyMealType();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add a key to the Scaffold widget
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search recipes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      suffixIcon: IconButton(
                        onPressed: _searchRecipes,
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    onChanged: (value) {
                      _updateSearchQuery(value);
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _searchRecipes();
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Food Region: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _cuisineType,
                  onChanged: (String? value) {
                    setState(() {
                      _cuisineType = value!;
                      _searchResults.clear();
                    });
                  },
                  items: _cuisineTypes
                      .map((cuisineType) => DropdownMenuItem<String>(
                            value: cuisineType,
                            child: Text(cuisineType),
                          ))
                      .toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 130,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mealType = "breakfast";
                              _searchResults.clear();
                            });
                            _querybyMealType();
                          },
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/breakfast.jpg'),
                            radius: 46,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Breakfast',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mealType = "lunch";
                              _searchResults.clear();
                            });
                            _querybyMealType();
                          },
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/lunch.jpg'),
                            radius: 46,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lunch',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mealType = "dinner";
                              _searchResults.clear();
                            });
                            _querybyMealType();
                          },
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/dinner.jpg'),
                            radius: 46,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Dinner',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mealType = "snack";
                              _searchResults.clear();
                            });
                            _querybyMealType();
                          },
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/snack.jpg'),
                            radius: 46,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Snack',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Recipes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: ConditionalBuilder(
                condition: _searchResults.isNotEmpty,
                builder: (context) => GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _searchResults.length +
                      (_searchResults.length < _totalResults ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _searchResults.length) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final recipe = _searchResults[index]['recipe'];
                    return RecipeCard(recipe: recipe);
                  },
                ),
                fallback: (context) => const Center(
                  child: Text('Search for a recipe!'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeCard({required this.recipe});

  final CollectionReference viewedRecipesRef =
      FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(recipe['url'])) {
          await launch(recipe['url']);

          final existingRecipe = await viewedRecipesRef
              .doc(userId)
              .collection('viewedRecipes')
              .where('url', isEqualTo: recipe['url'])
              .limit(1)
              .get();

          if (existingRecipe.docs.isEmpty) {
            final recipeData = {
              'label': recipe['label'],
              'image': recipe['image'],
              'source': recipe['source'],
              'url': recipe['url'],
              'viewedAt': FieldValue.serverTimestamp(),
            };
            viewedRecipesRef
                .doc(userId)
                .collection('viewedRecipes')
                .add(recipeData)
                .then((value) => print("Viewed recipe added"))
                .catchError(
                    (error) => print("Failed to add viewed recipe: $error"));
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Card(
          elevation: 2.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 120.0,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: recipe['image'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  recipe['label'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.restaurant),
                    const SizedBox(width: 4.0),
                    Text(
                      recipe['source'],
                      style: const TextStyle(fontSize: 12.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
