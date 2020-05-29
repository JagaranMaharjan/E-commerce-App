import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.dateTime, this.products, this.amount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  //add items for cart
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = "https://onlineshop-abf48.firebaseio.com/orders.json";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'title': cp.title,
                    })
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            dateTime: DateTime.now(),
            products: cartProducts),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //fetching orders data from the firebase
  Future<void> fetchAndSetOrders() async {
    const url = "https://onlineshop-abf48.firebaseio.com/orders.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> _loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      print(
        extractedData.toString(),
      );
      extractedData.forEach(
        (orderId, orderData) {
          _loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: double.parse(
                orderData['amount'].toString(),
              ),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      price: double.parse(
                        item['price'].toString(),
                      ),
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
                  )
                  .toList(),
              dateTime: DateTime.parse(
                orderData['dateTime'],
              ),
            ),
          );
        },
      );
      //print(id);
      _orders = _loadedOrders;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
  /*
  // fetching order from the firebase
  Future<void> fetchAndSetOrders() async {
    const url = "https://onlineshop-abf48.firebaseio.com/orders.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> _loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      print(
        extractedData.toString(),
      );
      extractedData.forEach(
        (orderId, orderData) {
          _loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: double.parse(
                orderData['amount'].toString(),
              ),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      price: double.parse(
                        item['price'].toString(),
                      ),
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
                  )
                  .toList(),
              dateTime: DateTime.parse(
                orderData['dateTime'],
              ),
            ),
          );
        },
      );
      _orders = _loadedOrders;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }     */
}
