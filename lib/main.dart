import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/helper/customRoute.dart';
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

void main() => runApp(SplashClass());

class SplashClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
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
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (BuildContext context, Auth auth, Orders previousOrders) {
            return Orders(
              auth.token,
              previousOrders == null ? [] : previousOrders.orders,
              auth.userId,
            );
          },
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
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTranisitionBuilder(),
            TargetPlatform.iOS: CustomPageTranisitionBuilder(),
          }),
        ),
        home: SplashBetween(),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ProductDetail.routeName: (ctx) => ProductDetail(),
          CartScreen.routeName: (ctx) => CartScreen(),
          CartItems.routeName: (ctx) => CartItems(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
          // AuthScreen.routeName: (ctx) => AuthScreen(),
        },
        //onUnknownRoute: AuthScreen,
      ),
    );
  }
}

class SplashBetween extends StatefulWidget {
  @override
  _SplashBetweenState createState() => _SplashBetweenState();
}

class _SplashBetweenState extends State<SplashBetween> {
  bool isInit = true;
  bool isLogin = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      checkLogin();
    }
    isInit = false;
  }

  void checkLogin() async {
    isLogin = await Provider.of<Auth>(context, listen: false).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen.navigate(
        fit: BoxFit.cover,
        transitionsBuilder: (ctx, animation, second, child) {
          var begin = Offset(-1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeIn));
          var offSetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offSetAnimation,
            child: child,
          );
        },
        name: "assets/images/splash.flr",
        backgroundColor: Colors.blueGrey,
        startAnimation: "Untitled",
        loopAnimation: "Untitled",
        until: () => Future.delayed(
          Duration(seconds: 3),
        ),
        alignment: Alignment.center,
        next: (_) => isLogin ? ProductOverviewScreen() : AuthScreen(),
      ),
    );
  }
}
