import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ulam_4_tonyt/reusable_widgets/side_menu.dart';

class ViewedRecipesPage extends StatelessWidget {
  final CollectionReference viewedRecipesRef =
      FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viewed Recipes'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: viewedRecipesRef
            .doc(userId)
            .collection('viewedRecipes')
            .orderBy('viewedAt', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final viewedRecipes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: viewedRecipes.length,
            itemBuilder: (context, index) {
              final viewedRecipe = viewedRecipes[index];
              return ListTile(
                title: Text(viewedRecipe['label'] ?? ''),
                subtitle: Text(viewedRecipe['source'] ?? ''),
                leading: CachedNetworkImage(
                  imageUrl: viewedRecipe['image'] ?? '',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
