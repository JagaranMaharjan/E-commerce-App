import 'package:flutter/material.dart';
import 'package:onlineshop/model/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItems extends StatelessWidget {
  static const String routeName = "/cart_items";
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItems({this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(DateTime.now()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        cart.removeFromCart(productId);   
      },
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: EdgeInsets.only(right: 20),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  child: Text("\$$price"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total Price: \$${price*quantity}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
