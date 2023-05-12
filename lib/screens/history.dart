import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/side_menu.dart';
import 'newhome.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final recipe = history[index];
          return ListTile(
            title: Text(recipe['label']),
            subtitle: Text(recipe['source']),
            leading: CachedNetworkImage(
              imageUrl: recipe['image'],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
}






