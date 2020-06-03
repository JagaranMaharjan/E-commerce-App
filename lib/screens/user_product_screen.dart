import 'package:flutter/material.dart';
import 'package:onlineshop/model/products.dart';
import 'package:onlineshop/widgets/app_drawer.dart';
import 'package:onlineshop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "/userProductScreen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final _productData = Provider.of<Products>(context);
    // print(_productData.items[0].id);
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(
                    builder: (ctx, products, _) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: products.items.length,
                        itemBuilder: (context, index) => UserProductItem(
                          title: products.items[index].title,
                          imgUrl: products.items[index].imageUrl,
                          id: products.items[index].id,
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
