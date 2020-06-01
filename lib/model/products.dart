import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshop/exceptions/http_exception.dart';
import 'package:onlineshop/model/product.dart';

class Products with ChangeNotifier {
  final String _authToken;
  final String _userId;
  List<Product> _items = [
    /*Product(
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
    ),   */
  ];

  Products(this._authToken, this._items, this._userId);

  List<Product> get items {
    return [..._items]; //update sdk version to 2.7.0
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  //show only favourite items
  List<Product> get favourites {
    return _items.where((productItem) {
      return productItem.isFavourite;
    }).toList();
  }

//this functions add new products
  Future<void> addNewProduct(Product product) async {
    final url =
        "https://onlineshop-abf48.firebaseio.com/products.json?auth=$_authToken";
    /*const test = "http://ip.jsontest.com/";
    http.get(test).then((response) {
      print(response.statusCode);
      //print(response.body);
    });
    //if status code is 200 then we are ready to add new product  */
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'desc': product.desc,
            'imageUrl': product.imageUrl,
            //'isFavourite': product.isFavourite,
          }));

      print(json.decode(response.body)['name']);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        desc: product.desc,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //fetch product from database
  Future<void> fetchAndSetProducts() async {
    final url = "https://onlineshop-abf48.firebaseio.com/products"
        ".json?auth=$_authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData.toString());
      final favoriteResponse = await http.get("https://onlineshop-abf48"
          ".firebaseio.com/userFavorites/$_userId.json?auth=$_authToken");
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodValue) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodValue['title'],
          price: double.parse(prodValue['price'].toString()),
          imageUrl: prodValue['imageUrl'],
          desc: prodValue['desc'],
          isFavourite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
        _items = loadedProduct;
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //this function update the product details
  Future<void> updateProduct(String id, Product upProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url =
            "https://onlineshop-abf48.firebaseio.com/products/$id.json?auth=$_authToken";
        await http.patch(
          url,
          body: json.encode(
            {
              'title': upProduct.title,
              'price': upProduct.price,
              'desc': upProduct.desc,
              'imageUrl': upProduct.imageUrl,
              'isFavourite': upProduct.isFavourite,
            },
          ),
        );
        _items[prodIndex] = upProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error.message);
      throw error;
    }
  }

  //    this function delete the current product
  Future<void> deleteProduct(String id) async {
    final url =
        "https://onlineshop-abf48.firebaseio.com/products/$id.json?auth=$_authToken";
    final existingProductIndex = items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException("Could not delete product");
      } else {
        existingProduct = null;
      }
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
  }
}
