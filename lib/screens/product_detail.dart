import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/model/products.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const String routeName = "/product_detail_screen";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments
        as String; // retrieve value of arguments as object i.e. String which was send by ProductItem widget
    final _selectedProduct = Provider.of<Products>(context, listen: false)
        .findById(id); // retrieve value as object according to its id
    return Scaffold(
      /*appBar: AppBar(
        title: Text(_selectedProduct.title),
      ),*/
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 470,
            pinned: true,
            //title: Text(_selectedProduct.title),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_selectedProduct.title),
              background: Hero(
                child: Container(
                  height: 470,
                  width: double.infinity,
                  child: Image.network(
                    _selectedProduct.imageUrl,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                tag: "products$id",
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "\$ ${_selectedProduct.price.toString()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    _selectedProduct.desc,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
