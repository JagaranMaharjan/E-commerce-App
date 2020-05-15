import 'package:flutter/material.dart';
import 'package:onlineshop/model/cart_provider.dart';
import 'package:onlineshop/screens/cart_screen.dart';
import 'package:onlineshop/widgets/badgeDart.dart';
import 'package:onlineshop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    //final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Shop"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption selectedValues) {
              setState(() {
                if (selectedValues == FilterOption.Favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: FilterOption.Favorites,
                child: Text("Show Favourites"),
              ),
              PopupMenuItem(
                value: FilterOption.All,
                child: Text("Show All"),
              ),
            ],
          ),
          //consumer only affects the part that needs to rebuild rather than refreshing the whole screen
          Consumer<Cart>(
            //consumer always listen to notifier
            builder: (_, cart, child) {
              return Badge(
                value: cart.itemCount.toString(),
                child: child,
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: ProductGrid(_showFavorites),
    );
  }
}
