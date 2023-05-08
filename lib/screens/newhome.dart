import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'package:ulam_4_tonyt/reusable_widgets/side_menu.dart';

class RecipeSearchPage extends StatefulWidget {
  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> _searchResults = [];
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
        'https://api.edamam.com/search?q=$_searchQuery&app_id=$appId&app_key=$appKey&from=$_currentPage&to=${_currentPage + _perPage}';

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
        }
      }
    });
    _searchController = TextEditingController();
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
                    _scaffoldKey.currentState!
                        .openDrawer(); // Use the GlobalKey to get a reference to the ScaffoldState
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
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 130,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Column(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => Login()),
                    //         );
                    //       },
                    //       child: CircleAvatar(
                    //         backgroundImage: NetworkImage(
                    //           'https://media.cnn.com/api/v1/images/stellar/prod/220217215855-01-filipino-breakfast-longsilog.jpg?q=h_2133,w_3469,x_0,y_0/w_1280',
                    //         ),
                    //         radius: 46,
                    //       ),
                    //     ),
                    //     SizedBox(height: 8),
                    //     Text('Breakfast', style: TextStyle(fontSize: 15),),
                    //   ],
                    // ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(
                              'https://www.foodnetwork.com/recipes/photos/our-best-breakfast-recipes')),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/breakfast.jpg'),
                            radius: 46,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Breakfast',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(
                              'https://www.allrecipes.com/recipes/16376/healthy-recipes/lunches/')),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/lunch.jpg'),
                            radius: 46,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lunch',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(
                              'https://www.tasteofhome.com/collection/classic-comfort-food-dinners/')),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/dinner.jpg'),
                            radius: 46,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Dinner',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(
                              'https://www.loveandlemons.com/appetizers/')),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/appetizer.jpg'),
                            radius: 46,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Appetizer',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(
                              'https://www.foodnetwork.com/recipes/photos/50-quick-snack-recipes')),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/snack.jpg'),
                            radius: 46,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Snack',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(
                              'https://www.allrecipes.com/recipes/77/drinks/')),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/drinks.jpg'),
                            radius: 46,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Drinks',
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(recipe['url'])) {
          await launch(recipe['url']);
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
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  recipe['label'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.restaurant),
                    SizedBox(width: 4.0),
                    Text(
                      recipe['source'],
                      style: TextStyle(fontSize: 12.0),
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
