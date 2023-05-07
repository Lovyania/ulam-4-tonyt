import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

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

    int itemCount = 8;
    List<String> items = [];

    int selectedAPIsCount = 0;
    if (fetchChickenAPI) selectedAPIsCount++;
    if (fetchFishAPI) selectedAPIsCount++;
    if (fetchBeefAPI) selectedAPIsCount++;
    if (fetchPorkAPI) selectedAPIsCount++;

    int itemsPerAPI = itemCount ~/ selectedAPIsCount;
    int extraItems = itemCount % selectedAPIsCount;

    if (fetchChickenAPI) {
      List<String> chickenItems = await fetchData("chicken");
      if (chickenItems.length > itemsPerAPI) {
        items.addAll(chickenItems.take(itemsPerAPI));
      } else {
        items.addAll(chickenItems);
        extraItems -= (itemsPerAPI - chickenItems.length);
        itemsPerAPI = chickenItems.length;
      }
    }
    if (fetchFishAPI) {
      List<String> fishItems = await fetchData("fish");
      if (fishItems.length > itemsPerAPI) {
        items.addAll(fishItems.take(itemsPerAPI));
      } else {
        items.addAll(fishItems);
        extraItems -= (itemsPerAPI - fishItems.length);
        itemsPerAPI = fishItems.length;
      }
    }
    if (fetchBeefAPI) {
      List<String> beefItems = await fetchData("beef");
      if (beefItems.length > itemsPerAPI) {
        items.addAll(beefItems.take(itemsPerAPI));
      } else {
        items.addAll(beefItems);
        extraItems -= (itemsPerAPI - beefItems.length);
        itemsPerAPI = beefItems.length;
      }
    }
    if (fetchPorkAPI) {
      List<String> porkItems = await fetchData("pork");
      if (porkItems.length > itemsPerAPI) {
        items.addAll(porkItems.take(itemsPerAPI));
      } else {
        items.addAll(porkItems);
        extraItems -= (itemsPerAPI - porkItems.length);
        itemsPerAPI = porkItems.length;
      }
    }

    // If there are extra items, add them to the list by taking one from each API
    if (extraItems > 0) {
      if (fetchChickenAPI && extraItems > 0) {
        items.add(await fetchData("chicken").then((items) => items.first));
        extraItems--;
      }
      if (fetchFishAPI && extraItems > 0) {
        items.add(await fetchData("fish").then((items) => items.first));
        extraItems--;
      }
      if (fetchBeefAPI && extraItems > 0) {
        items.add(await fetchData("beef").then((items) => items.first));
        extraItems--;
      }
      if (fetchPorkAPI && extraItems > 0) {
        items.add(await fetchData("pork").then((items) => items.first));
        extraItems--;
      }
    }

    items.shuffle();
    return items;
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
      key: _scaffoldKey, // Add a key to the Scaffold widget,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!
                .openDrawer(); // Use the GlobalKey to get a reference to the ScaffoldState
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
                          for (int i = 0;
                          i < items.length;
                          i++) ...<FortuneItem>{
                            FortuneItem(child: Text(items[i])),
                          },
                        ],
                        onAnimationEnd: () {
                          final selectedItemName = items[selected.value];
                          setState(() {
                            result = selectedItemName;
                          });
                          fetchRecipe(selectedItemName);
                          selected.add(
                              -1); // add null to the selected stream to stop the wheel from spinning
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
                  await Future.delayed(Duration(
                      milliseconds:
                      100)); // delay to show the result before spinning
                  selected.add(selectedValue);
                }
              },

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  height: 40,
                  width: 120,
                  color: Colors.lightGreen,
                  child: Center(
                    child: Text("SPIN"),

                  ),
                ),
              ),
            ),
          Column(
            children: [
              Text(
                '',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Select meat type',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
          CheckboxListTile(
            title: Text('Chicken'),
            value: fetchChickenAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchChickenAPI = value!; 2; false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Beef'),
            value: fetchBeefAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchBeefAPI = value!; 2; false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Pork'),
            value: fetchPorkAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchPorkAPI = value!; 2; false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Fish'),
            value: fetchFishAPI,
            onChanged: (bool? value) {
              setState(() {
                fetchFishAPI = value!; 2; false;
              });
            },
          ),

        ],
      ),
    );
  }
}