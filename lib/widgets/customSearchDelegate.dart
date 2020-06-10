import 'package:flutter/material.dart';
import 'package:onlineshop/model/products.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchItems =
        Provider.of<Products>(context, listen: false).getSearchItems(query);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text("Search Product Items"),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItems = Provider.of<Products>(context).getSearchItems(query);
    return query.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text("Search Product Items"),
              ),
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) => Text(searchItems[index].title),
            itemCount: searchItems.length,
          );
  }
}
