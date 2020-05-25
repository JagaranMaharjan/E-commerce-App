import 'package:flutter/material.dart';
import 'package:onlineshop/model/products.dart';
import 'package:onlineshop/widgets/app_drawer.dart';
import 'package:onlineshop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "/userProductScreen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _productData = Provider.of<Products>(context);
    print(_productData.items[0].id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _productData.items.length,
          itemBuilder: (context, index) => UserProductItem(
            title: _productData.items[index].title,
            imgUrl: _productData.items[index].imageUrl,
            id: _productData.items[index].id,
          ),
        ),
      ),
    );
  }
}
