import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/side_menu.dart';
import 'newhome.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required this.history}) : super(key: key);
  final List<Map<String, dynamic>> history;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];

  void _addToHistory(Map<String, dynamic> recipe) {
    setState(() {
      _history.add(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.builder(
        itemCount: widget.history.length,
        itemBuilder: (context, index) {
          final recipe = widget.history[index];
          return ListTile(
            title: Text(recipe['label']),
            subtitle: Text(recipe['source']),
            leading: CachedNetworkImage(
              imageUrl: recipe['image'],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            onTap: () {
              _addToHistory(recipe);
            },
          );
        },
      ),
    );
  }
}






