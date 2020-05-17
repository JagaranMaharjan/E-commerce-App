import 'package:flutter/material.dart';
import 'package:onlineshop/model/orders.dart';
import 'package:onlineshop/widgets/app_drawer.dart';
import 'package:onlineshop/widgets/order_items.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = "/orderScreen";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).orders;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) => OrderItems(orderData[index]),
        itemCount: orderData.length,
      ),
    );
  }
}
