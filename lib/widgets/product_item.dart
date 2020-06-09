import 'package:flutter/material.dart';
import 'package:onlineshop/model/auth_provider.dart';
import 'package:onlineshop/model/cart_provider.dart';
import 'package:onlineshop/model/product.dart';
import 'package:onlineshop/screens/product_detail.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _loadedProduct = Provider.of<Product>(context,
        listen: false); //retrieve data as object from its model i.e. Product
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetail.routeName,
                arguments: _loadedProduct.id);
          },
          child: Hero(
            tag: 'product${_loadedProduct.id}',
            child: FadeInImage(
              placeholder: AssetImage("assets/images/jagaran.jpg"),
              image: NetworkImage(
                _loadedProduct.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(
            _loadedProduct.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (_, prod, child) {
              return IconButton(
                icon: Icon(
                    prod.isFavourite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  prod.toggleIsFavourite(auth.userId, auth.token);
                },
                color: Theme.of(context).accentColor,
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addToCart(_loadedProduct.id, _loadedProduct.title,
                  _loadedProduct.price);
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Text("Items Added to card"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  textColor: Colors.black87,
                  onPressed: () {
                    cart.removeSingleItem(_loadedProduct.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
