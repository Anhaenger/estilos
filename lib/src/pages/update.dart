import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

File image;
String filename;

class UpdateProduct extends StatefulWidget {
  final DocumentSnapshot ds;
  UpdateProduct({this.ds});
  @override
  _UpdateProduct createState() => _UpdateProduct();
}

class _UpdateProduct extends State<UpdateProduct> {
  String productImage;
  TextEditingController nameInputController;
  TextEditingController descriptionInputController;
  TextEditingController priceInputController;
  TextEditingController sizeInputController;
  TextEditingController genderInputController;
  TextEditingController typeInputController;
  TextEditingController imageInputController;

  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  final List<String> tallas = ['S', 'M', 'L'];
  final List<String> generos = ['Femenino', 'Masculino'];

  String name;
  String description;
  String price;
  String size;
  String gender;
  String type;

  Future pickerGallery() async {
    var img = await ImagePicker().getImage(source: ImageSource.gallery);
    if (img != null) {
      image = File(img.path);
      setState(() {
        image = File(img.path);
        print(image);
      });
    }
  }

  Future uploadFile(BuildContext context) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('${Path.basename(image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print('File Uploaded');
    taskSnapshot.ref.getDownloadURL().then((fileURL) {
      setState(() {
        filename = fileURL;
      });
    });

    print('FILENAME');
    print(filename);

    Firestore.instance
        .collection('ropaEstilos')
        .document(widget.ds.documentID)
        .updateData({
      'name': nameInputController.text,
      'description': descriptionInputController.text,
      'price': priceInputController.text,
      'size': sizeInputController.text,
      'gender': genderInputController.text,
      'type': typeInputController.text,
      'image': '$filename',
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    nameInputController = TextEditingController(text: widget.ds.data["name"]);
    descriptionInputController =
        TextEditingController(text: widget.ds.data["description"]);
    priceInputController = TextEditingController(text: widget.ds.data["price"]);
    sizeInputController = TextEditingController(text: widget.ds.data["size"]);
    genderInputController =
        TextEditingController(text: widget.ds.data["gender"]);
    typeInputController = TextEditingController(text: widget.ds.data["type"]);
    productImage = widget.ds.data["image"];
    print(productImage);
  }

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("ropaEstilos").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar información'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140.0,
                      width: 140.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.red),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: productImage == ''
                          ? Text('Edit')
                          : Image(
                              image: CachedNetworkImageProvider(productImage),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.2),
                      child: Container(
                        height: 140.0,
                        width: 140.0,
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.red),
                        ),
                        padding: new EdgeInsets.all(5.0),
                        child: image == null
                            ? Text('Actualiza la imagen')
                            : Image.file(image),
                      ),
                    ),
                    Divider(),
                    IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                Divider(),
                TextFormField(
                  controller: nameInputController,
                  decoration: InputDecoration(
                    hintText: 'Nombre',
                  ),
                  validator: (val) => val.isEmpty ? 'Ingresa un nombre' : null,
                  onChanged: (val) => name = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: descriptionInputController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Descripción',
                  ),
                  validator: (val) =>
                      val.isEmpty ? 'Ingresa una descripción' : null,
                  onChanged: (val) => description = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: priceInputController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Precio',
                  ),
                  validator: (val) => val.isEmpty ? 'Ingresa un precio' : null,
                  onChanged: (val) => price = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: sizeInputController,
                  decoration: InputDecoration(
                    hintText: 'Talla',
                  ),
                  validator: (val) => val.isEmpty ? 'Ingresa una talla' : null,
                  onChanged: (val) => size = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: genderInputController,
                  decoration: InputDecoration(
                    hintText: 'Género',
                  ),
                  validator: (val) => val.isEmpty ? 'Ingresa un género' : null,
                  onChanged: (val) => gender = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: typeInputController,
                  decoration: InputDecoration(
                    hintText: 'Tipo de prenda',
                  ),
                  validator: (val) =>
                      val.isEmpty ? 'Ingresa un tipo de prenda' : null,
                  onChanged: (val) => type = val,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child:
                    Text('Actualizar', style: TextStyle(color: Colors.white)),
                color: Colors.red,
                onPressed: () {
                  uploadFile(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
