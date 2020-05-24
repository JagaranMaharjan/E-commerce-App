import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/model/product.dart';
import 'package:onlineshop/model/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/editProductScreen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;

  var _editedProduct = Product(
    id: null,
    title: "",
    price: 0,
    imageUrl: "",
    desc: "",
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imgUrlFocusNode.addListener((_updateImageUrl));
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlFocusNode.dispose();
    _imgUrlController.dispose();
  }

  //save form and validate
  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .addNewProduct(_editedProduct);
    }
    Navigator.pop(context);
  }

  //instea dof model router----
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      final String productId = ModalRoute.of(context).settings.arguments;
      print("i am from did change depencey");
      print(productId);
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
          'desc': _editedProduct.desc,
        };
        _imgUrlController.text = _editedProduct.imageUrl;
      }
    } else {
      _isInit = false;
    }
  }

  var initValues = {
    'title': "",
    'price': "",
    'imageUrl': "",
    'desc': "",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedProduct.id != null
            ? Text("Edit Product")
            : Text("Add "
                "Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            color: Colors.green,
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Title",
              ),
              initialValue: initValues['title'],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Title must not be empty';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: value.trimLeft().trim(),
                  desc: _editedProduct.desc,
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                  id: _editedProduct.id,
                );
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Price",
              ),
              initialValue: initValues['price'],
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Price must not be empty";
                }
                if (double.tryParse(value) == null) {
                  return "Price must be in a number format";
                }
                if (double.parse(value) <= 0) {
                  return "Price must not be less than 0";
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.title,
                  desc: _editedProduct.desc,
                  imageUrl: _editedProduct.imageUrl,
                  price: double.parse(value),
                  id: _editedProduct.id,
                );
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Description",
              ),
              initialValue: initValues['desc'],
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descFocusNode,
              validator: (value) {
                if (value.isEmpty) {
                  return "Description must not be empty";
                }
                if (value.length < 10) {
                  return "Description length must be at least of 10 words";
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.title,
                  desc: value.trim(),
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                  id: _editedProduct.id,
                );
              },
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 8, right: 8),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: _imgUrlController.text.isEmpty
                      ? Center(child: Text("Enter a url"))
                      : FittedBox(
                          child: Image.network(_imgUrlController.text),
                        ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Image Url",
                    ),
                    // initialValue: initValues['imageUrl'],
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    focusNode: _imgUrlFocusNode,
                    controller: _imgUrlController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Iamge Url must not be empty";
                      }
                      if (!value.startsWith("http") &&
                          !value.startsWith("https")) {
                        return "Iamge url is not valid";
                      }
                      if (!value.endsWith(".png") &&
                          !value.endsWith(".jpg") &&
                          !value.endsWith(".jpeg") &&
                          !value.endsWith(".JPG")) {
                        return "Image Url is not valid";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        desc: _editedProduct.desc,
                        imageUrl: value.trim(),
                        price: _editedProduct.price,
                        id: _editedProduct.id,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
