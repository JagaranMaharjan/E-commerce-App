import 'package:flutter/material.dart';
import 'package:onlineshop/model/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: "first",
      title: "Watch",
      price: 5000.0,
      desc: "Best Watch",
      isFavourite: false,
      imageUrl:
      "https://images-na.ssl-images-amazon.com/images/I/81ZKNYBwYlL._AC_SY445_.jpg",
    ),
    Product(
      id: "second",
      title: "TV",
      price: 20000.0,
      desc: "Best TV",
      isFavourite: false,
      imageUrl:
      "https://www.thepasal.com/images/2017/tv/skyworth/e200a/skyworth-43-smart-tv.jpg",
    ),
    Product(
      id: "third",
      title: "Mobile",
      price: 500000.0,
      desc: "Best Mobile",
      isFavourite: false,
      imageUrl:
      "https://images-na.ssl-images-amazon.com/images/I/61-BmjNwoTL._SX522_.jpg",
    ),
    Product(
      id: "forth",
      title: "Watch",
      price: 200.0,
      desc: "Best Watch",
      isFavourite: false,
      imageUrl:
      "https://images-na.ssl-images-amazon.com/images/I/81ZKNYBwYlL._AC_SY445_.jpg",
    ),
  ];

  List<Product> get items {
    return [..._items]; //update sdk version to 2.7.0
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  //show only favourite items
  List<Product> get favourites{
    return _items.where((productItem) {
      return productItem.isFavourite;
    }).toList();
}
}
