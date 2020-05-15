import 'package:flutter/material.dart';
import 'package:onlineshop/model/product.dart';
import 'package:onlineshop/screens/product_detail.dart';
import 'package:onlineshop/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';

import 'model/cart_provider.dart';
import 'model/products.dart';
import 'screens/cart_screen.dart';
import 'package:onlineshop/widgets/cart_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        )
      ],
      //here change notifier is used to have data of Products for other class/widget
      child: MaterialApp(
          title: "Shopping Market",
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: "font3",
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(brightness: Brightness.dark),
            textTheme: TextTheme(
              body1: TextStyle(fontFamily: "font2", fontSize: 16),
            ),
          ),
          initialRoute: "/",
          routes: {
            "/": (ctx) => ProductOverviewScreen(),
            ProductDetail.routeName: (ctx) => ProductDetail(),
            CartScreen.routeName: (ctx) => CartScreen(),
            CartItems.routeName: (ctx) => CartItems(),
          }),
    );
  }
}