import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungshopfirebase/models/food_model.dart';
import 'package:ungshopfirebase/utility/normal_dialog.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  String name, detail, price;

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                labelText: 'ชื่อ :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget detailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextField(
              onChanged: (value) => detail = value.trim(),
              decoration: InputDecoration(
                labelText: 'รายละเอียด :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget priceForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => price = value.trim(),
              decoration: InputDecoration(
                labelText: 'ราคา :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิิ่มเมนูอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            imageGroup(),
            nameForm(),
            detailForm(),
            priceForm(),
            saveButton()
          ],
        ),
      ),
    );
  }

  RaisedButton saveButton() {
    return RaisedButton.icon(
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'กรุณาเลือก รูปภาพอาหารด้วยคะ');
          } else if (name == null ||
              name.isEmpty ||
              detail == null ||
              detail.isEmpty ||
              price == null ||
              price.isEmpty) {
            normalDialog(context, 'Have Space');
          } else {
            uploadImage();
          }
        },
        icon: Icon(Icons.save),
        label: Text('Save Food Menu'));
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'food$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Food/$nameFile');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    await (await storageUploadTask.onComplete)
        .ref
        .getDownloadURL()
        .then((value) {
      String urlFood = value;
      print('urlFood = $urlFood');
      insertValueToFirebase(urlFood);
    });
  }

  Future<Null> insertValueToFirebase(String urlFood) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    String uidShop = firebaseUser.uid;

    FoodModel foodModel =
        FoodModel(name: name, detail: detail, price: price, urlFood: urlFood);
    Map<String, dynamic> map = foodModel.toJson();

    Firestore firestore = Firestore.instance;
    CollectionReference reference = firestore.collection('FoodMenu');
    await reference
        .document(uidShop)
        .collection('Food')
        .document()
        .setData(map)
        .then((value) => Navigator.pop(context));
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget imageGroup() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 140,
            height: MediaQuery.of(context).size.height * 0.3,
            child: file == null
                ? Image.asset('images/logo.png')
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      );
}
