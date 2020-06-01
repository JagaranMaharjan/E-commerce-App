import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String desc;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.desc,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleIsFavourite(String userId, String authToken) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        "https://onlineshop-abf48.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken";
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
