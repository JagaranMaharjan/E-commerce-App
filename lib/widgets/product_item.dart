import 'package:flutter/material.dart';
import 'package:onlineshop/model/product.dart';
import 'package:onlineshop/screens/product_detail.dart';
import 'package:provider/provider.dart';
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _loadedProduct = Provider.of<Product>(context);//retrieve data as object from its model i.e. Product
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, ProductDetail.routeName, arguments:_loadedProduct.id);
          },
          child: Image.network(
            _loadedProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(_loadedProduct.title, textAlign: TextAlign.center,),
          leading: IconButton(
            icon: Icon(_loadedProduct.isFavourite?Icons.favorite:Icons.favorite_border),
            onPressed: (){
              _loadedProduct.toggleIsFavourite();
            },
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
