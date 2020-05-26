import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  //total length of cart
  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  //this adds items to cart
  void addToCart(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (exitingCartItem) => CartItem(
              id: exitingCartItem.id,
              title: exitingCartItem.title,
              price: exitingCartItem.price,
              quantity: exitingCartItem.quantity + 1));
    } else {
      //no items in cart
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    //print("i m here");
    print(_items);
    notifyListeners();
  }

  //get total amount
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, carItem) {
      total += carItem.quantity * carItem.price;
    });
    return total;
  }

  //remove single items from cart
  void removeFromCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  //clear cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }

  //remove single items
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else {
      if (_items[productId].quantity > 1) {
        _items.update(productId, (existingCartItem) {
          return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1,
          );
        });
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }
}
