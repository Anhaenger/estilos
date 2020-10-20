import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot ds;
  DetailPage({this.ds});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController nameInputController;
  TextEditingController descriptionInputController;
  TextEditingController priceInputController;
  TextEditingController sizeInputController;
  TextEditingController genderInputController;
  TextEditingController typeInputController;
  TextEditingController imageInputController;

  String productImage;
  String id;
  String name;
  String description;
  String price;
  String size;
  String gender;
  String type;

  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    nameInputController = 
    TextEditingController(text: widget.ds.data["name"]);
    descriptionInputController =
        TextEditingController(text: widget.ds.data["description"]);
    priceInputController = 
    TextEditingController(text: widget.ds.data["price"]);
    sizeInputController = 
    TextEditingController(text: widget.ds.data["size"]);
    genderInputController =
        TextEditingController(text: widget.ds.data["gender"]);
    typeInputController = 
    TextEditingController(text: widget.ds.data["type"]);
    productImage = widget.ds.data["image"];
    print(productImage);
  }

  Future getPost() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("ropaEstilos").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la prenda'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 400.0,
              width: 400.0,
              child: productImage == ''
                  ? Text('')
                  : Image(
                      fit: BoxFit.fitWidth,
                      image: CachedNetworkImageProvider(productImage),
                    ),
            ),
            Container(
              width: 350.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: [
                        Text(
                          nameInputController.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 350.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          priceInputController.text,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(width: 30.0),
                        Text(
                          'Talla:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          sizeInputController.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                genderInputController.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            Divider(),
            Container(
              width: 380.0,
              child: Text(
                descriptionInputController.text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
