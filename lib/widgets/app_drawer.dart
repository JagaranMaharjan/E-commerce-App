import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineshop/helper/customRoute.dart';
import 'package:onlineshop/model/auth_provider.dart';
import 'package:onlineshop/screens/auth_screen.dart';
import 'package:onlineshop/screens/oder_screen.dart';
import 'package:onlineshop/screens/product_overview_screen.dart';
import 'package:onlineshop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isInit = true;
  String email = "";
  String userType = "";
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit) {
      getUserData();
    }
    isInit = false;
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    setState(() {
      email = extractedData["email"];
      userType = extractedData["userType"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final acontext = Scaffold.of(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Jagaran Maharjan'),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars0.githubusercontent.com/u/60642304?s=460&u=4b205d76b1b1ba4bcae663fa6a5e764eac85ae3d&v=4'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, OrderScreen.routeName);
              Navigator.of(context).pushReplacement(
                CustomRoute(builder: (context) => OrderScreen()),
              );
            },
          ),
          userType == "client"
              ? Container()
              : Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Manage Products'),
                      onTap: () {
                        /* Navigator.pushReplacementNamed(
                    context,
                    UserProductScreen.routeName,
                  ); */
                        Navigator.of(context).pushReplacement(
                          CustomRoute(
                              builder: (context) => UserProductScreen()),
                        );
                      },
                    ),
                  ],
                ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop();
              //Navigator.of(context).dispose();

              //Navigator.of(context).pushReplacementNamed("/");
              // Navigator.of(context).pop();
              //Navigator.pop(context);

              await Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
