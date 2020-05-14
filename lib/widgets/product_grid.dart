import 'package:flutter/material.dart';
import 'package:onlineshop/model/product.dart';
import 'package:onlineshop/model/products.dart';
import 'package:onlineshop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool isFavourite;
  ProductGrid(this.isFavourite);
  @override
  Widget build(BuildContext context) {
    final products = isFavourite?Provider.of<Products>(context).favourites
    :Provider.of<Products>(context).items;//retrieve data as object from dummy database in a list
    return GridView.builder(
      //itemCount: products.items.length,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3/2,
      ),
      itemBuilder: (ctx, index) => Consumer<Products>(
        builder: (key, builder, _){
          return ChangeNotifierProvider.value(value: products[index],//here change notifier is used to send data for other widget i.e. Product Item
              child:ProductItem()
          );
        },
      )
    );
  }
}
