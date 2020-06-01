import 'package:flutter/material.dart';
import 'package:onlineshop/model/auth_provider.dart';
import 'package:onlineshop/model/orders.dart';
import 'package:onlineshop/model/products.dart';
import 'package:onlineshop/screens/edit_product_screen.dart';
import 'package:onlineshop/screens/oder_screen.dart';
import 'package:onlineshop/screens/product_detail.dart';
import 'package:onlineshop/screens/user_product_screen.dart';
import 'package:onlineshop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

import 'model/cart_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        //here it takes value i.e. Auth token from Auth and passes that value
        // into Products
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (BuildContext context, Auth auth, Products previousProducts) {
            return Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId,
            );
          },
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (BuildContext context, Auth auth, Orders previousOrders) {
            return Orders(
              auth.token,
              previousOrders == null ? [] : previousOrders.orders,
            );
          },
        )
      ],
      //here change notifier is used to have data of Products for other class/widget
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          print(auth.isAuth);
          return MaterialApp(
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
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            // initialRoute: "/",
            routes: {
              // "/": (ctx) => ProductOverviewScreen(),
              // "/": (ctx) => AuthScreen(),
              ProductDetail.routeName: (ctx) => ProductDetail(),
              CartScreen.routeName: (ctx) => CartScreen(),
              CartItems.routeName: (ctx) => CartItems(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              // AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
