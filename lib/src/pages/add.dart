import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

File image;

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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

  /* Future pickerGallery() async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((img) {
      
      setState(() {
        image = File(img.path);
      });
    });
  } */

  Future pickerGallery() async {
    var img = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      image = File(img.path);
    });
  }
  

  Future createData(BuildContext context) async {
    print('RUTA DE LA IMAGEM');
    print(image.path);

    String fileName = Path.basename(image.path);

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('$fileName');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print('File Uploaded');
    taskSnapshot.ref.getDownloadURL().then((value) {
      print('Done: $value');
      setState(() {
        fileName = value;
        print('RUTA FILENAME');
        print(fileName);
      });
    });
    /* setState(() {
        filename = fileURL;
      }); */

    var part1 = "https://firebasestorage.googleapis.com/v0/b/estilos-flutter.appspot.com/o/";
    var fullPath = part1 + fileName;

    print('RUTA DE LA IMAGEM COMPLETA');
    print(fullPath);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('ropaEstilos').add({
        'name': '$name',
        'description': '$description',
        'price': '$price',
        'size': '$size',
        'gender': '$gender',
        'type': '$type',
        'image': '$fullPath',
      });
      setState(() => id = ref.documentID);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir prenda'),
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
                    new Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.red),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null
                          ? Text(
                              'Añade una imagen',
                              style: TextStyle(fontSize: 16),
                            )
                          : Image.file(image),
                    ),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image),
                        onPressed: () {
                          pickerGallery();
                        }),
                  ],
                ),
                Divider(),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nombre',
                  ),
                  validator: (val) => val.isEmpty ? 'Ingresa un nombre' : null,
                  onChanged: (val) => name = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
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
                  decoration: InputDecoration(
                    hintText: 'Tipo de prenda',
                  ),
                  validator: (val) =>
                      val.isEmpty ? 'Ingresa un tipo de prenda' : null,
                  onChanged: (val) => type = val,
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  items: tallas.map((size) {
                    return DropdownMenuItem(value: size, child: Text('$size'));
                  }).toList(),
                  validator: (val) => val.isEmpty ? 'Ingresa una talla' : null,
                  onChanged: (val) => setState(() => size = val),
                  hint: Container(
                    width: 150.0,
                    child: Text(
                      'Selecciona una talla',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  items: generos.map((gender) {
                    return DropdownMenuItem(
                        value: gender, child: Text('$gender'));
                  }).toList(),
                  validator: (val) => val.isEmpty ? 'Ingresa un género' : null,
                  onChanged: (val) => setState(() => gender = val),
                  hint: Container(
                    width: 200.0,
                    child: Text(
                      'Selecciona un género',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  createData(context);
                },
                child: Text('Añadir', style: TextStyle(color: Colors.white)),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
