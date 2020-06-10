import 'package:flutter/material.dart';
import 'package:onlineshop/model/cart_provider.dart';
import 'package:onlineshop/model/orders.dart';
import 'package:onlineshop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart_screen";

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${_cart.totalAmount}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(
                    cart: _cart,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cart.itemCount,
              itemBuilder: (context, index) => CartItems(
                id: _cart.items.values.toList()[index].id,
                title: _cart.items.values.toList()[index].title,
                price: _cart.items.values.toList()[index].price,
                productId: _cart.items.keys.toList()[index], //yo kna
                // gareyko----------
                quantity: _cart.items.values.toList()[index].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cart;
  OrderButton({this.cart});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _order = Provider.of<Orders>(context, listen: false);
    return FlatButton(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              "ORDER NOW",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor),
            ),
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              // Scaffold.of(context).removeCurrentSnackBar();
              if (widget.cart.items.isNotEmpty ||
                  widget.cart.totalAmount != 0) {
                await _order.addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.clearCart();
                setState(() {
                  _isLoading = false;
                });
              }
            },
    );
  }
}
