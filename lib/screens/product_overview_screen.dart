import 'package:flutter/material.dart';
import 'package:onlineshop/model/cart_provider.dart';
import 'package:onlineshop/model/products.dart';
import 'package:onlineshop/screens/cart_screen.dart';
import 'package:onlineshop/widgets/app_drawer.dart';
import 'package:onlineshop/widgets/badgeDart.dart';
import 'package:onlineshop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const String routeName = "productOverviewScreen";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    //final cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: AppDrawer(),
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
              return cart.itemCount == 0
                  ? child
                  : Badge(
                      value: cart.itemCount.toString(),
                      child: child,
                    );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
                //Scaffold.of(context).removeCurrentSnackBar();
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavorites),
    );
  }
}
