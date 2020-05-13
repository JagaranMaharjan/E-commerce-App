import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final double price;
  final String desc;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required  this.title,
    @required  this.price,
    @required  this.desc,
    @required this.imageUrl,
    this.isFavourite=false
  });
}