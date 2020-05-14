import 'package:flutter/material.dart';
import 'package:onlineshop/widgets/product_grid.dart';

enum FilterOption {Favorites, All}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Shop"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption selectedValues){
              setState(() {
                if(selectedValues == FilterOption.Favorites){
                  _showFavorites = true;
                }else{
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
        ],
      ),

      body: ProductGrid(_showFavorites),
    );
  }
}
