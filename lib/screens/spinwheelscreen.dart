import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:ulam_4_tonyt/screens/profile.dart';

import 'login.dart';
import 'newhome.dart';

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

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final selected = BehaviorSubject<int>();
  int rewards = 0;

  List<String> items = [];
  bool fetchChickenAPI = true;
  bool fetchFishAPI = true;
  bool fetchBeefAPI = true;
  bool fetchPorkAPI = true;
  String result = '';
  bool isSpinning = false;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  Future<List<String>> fetchData(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/search?q=$query&app_id=c6b66230&app_key=9ab562577b709b59d7518e6ca96cc2f5'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final hits = jsonResponse['hits'] as List<dynamic>;
      final itemHits =
      hits.map((hit) => hit['recipe']['label'].toString()).toList();
      return List.from(itemHits)..shuffle();
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future<List<String>> fetchDataFromAPI() async {
    if (!fetchChickenAPI && !fetchFishAPI && !fetchBeefAPI && !fetchPorkAPI) {
      // If no checkbox is checked, fetch data from all APIs
      fetchChickenAPI = true;
      fetchFishAPI = true;
      fetchBeefAPI = true;
      fetchPorkAPI = true;
    }

    List<String> items = [];
    if (fetchChickenAPI) {
      items.addAll(await fetchData("chicken"));
    }
    if (fetchFishAPI) {
      items.addAll(await fetchData("fish"));
    }
    if (fetchBeefAPI) {
      items.addAll(await fetchData("beef"));
    }
    if (fetchPorkAPI) {
      items.addAll(await fetchData("pork"));
    }
    items.shuffle();
    return items.take(6).toList();
  }

  Future<void> fetchRecipe(String selectedItemName) async {
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/search?q=$selectedItemName&app_id=c6b66230&app_key=9ab562577b709b59d7518e6ca96cc2f5'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final hits = jsonResponse['hits'] as List<dynamic>;
      final recipe = hits[0]['recipe'] as Map<dynamic, dynamic>;
      final label = recipe['label'];
      final ingredients = recipe['ingredientLines'] as List<dynamic>;
      final ingredientsText = ingredients.join('\n');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text("Selected dish: $label"),
              content: SingleChildScrollView(
                child: Text("Ingredients:\n$ingredientsText"),
              ),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add a key to the Scaffold widget
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer(); // Use the GlobalKey to get a reference to the ScaffoldState
          },
        ),
        title: Text('Food Roulette'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: FutureBuilder<List<String>>(
                future: fetchDataFromAPI(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    items = snapshot.data!;
                    return SizedBox(
                      height: 300,
                      child: FortuneWheel(
                        selected: selected.stream,
                        animateFirst: true,
                        items: [
                          for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                            FortuneItem(child: Text(items[i])),
                          },
                        ],
                        onAnimationEnd: () {
                          final selectedItemName = items[selected.value];
                          setState(() {
                            result = selectedItemName;
                          });
                          fetchRecipe(selectedItemName);
                          selected.add(-1); // add null to the selected stream to stop the wheel from spinning
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          if (!isSpinning) // conditionally render the button
            GestureDetector(
              onTap: () async {
                if (items.isNotEmpty) {
                  final selectedValue = Fortune.randomInt(0, items.length);
                  setState(() {
                    result = items[selectedValue];
                  });
                  await Future.delayed(Duration(milliseconds: 100)); // delay to show the result before spinning
                  selected.add(selectedValue);
                }
              },
              child: Container(
                height: 40,
                width: 120,
                color: Colors.redAccent,
                child: Center(
                  child: Text("SPIN"),
                ),
              ),
            ),

          CheckboxListTile(
            title: Text('Fetch Chicken API'),
            value: fetchChickenAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchChickenAPI = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Fetch Beef API'),
            value: fetchBeefAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchBeefAPI = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Fetch Pork API'),
            value: fetchPorkAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchPorkAPI = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Fetch Fish API'),
            value: fetchFishAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchFishAPI = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }
}