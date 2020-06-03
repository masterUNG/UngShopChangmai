import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ungshopfirebase/utility/normal_dialog.dart';
import 'package:ungshopfirebase/widget/rider_service.dart';
import 'package:ungshopfirebase/widget/shop_service.dart';
import 'package:ungshopfirebase/widget/user_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String typeUser, name, email, password;
  double lat, lng;
  Location location = Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        // print('lat = $lat, lng = $lng');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (name == null ||
              name.isEmpty ||
              email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'กรุณากรอกทุกช่อง คะ');
          } else if (typeUser == null) {
            normalDialog(context, 'กรุณาเลือกชนิดของ User ด้วย คะ');
          } else {
            registerThread();
          }
        },
        child: Icon(Icons.cloud_upload),
      ),
      body: showContent(),
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
    );
  }

  Future<Null> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      String uid = value.user.uid;
      print('Register Success uid ==>> $uid');
      insertValueToFirestore(uid);
    }).catchError((value) {
      String string = value.message;
      normalDialog(context, string);
    });
  }

  Future<Null> insertValueToFirestore(String uid) async {
    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Email'] = email;
    map['TypeUser'] = typeUser;
    map['Lat'] = lat;
    map['Lng'] = lng;

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('User');
    await collectionReference.document(uid).setData(map).then((value) {
      print('Success Insert');
      if (typeUser == 'User') {
        routeToService(UserService());
      }else if (typeUser == 'Shop') {
        routeToService(ShopService());
      } else {
        routeToService(RiderService());
      }
    });
  }

  void routeToService(Widget widget) {
     MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameForm(),
            userRadio(),
            shopRadio(),
            riderRadio(),
            emailForm(),
            passwordForm(),
            lat == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : showMap(),
          ],
        ),
      );

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myID'),
        position: LatLng(lat, lng),
        infoWindow:
            InfoWindow(title: 'You Here', snippet: 'Lat = $lat, Lng = $lng'),
      ),
    ].toSet();
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16.0);

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  Widget userRadio() => Container(
        width: 150.0,
        child: Row(
          children: <Widget>[
            Radio(
              value: 'User',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value;
                });
              },
            ),
            Text('ผู้ซื้อ')
          ],
        ),
      );

  Widget shopRadio() => Container(
        width: 150.0,
        child: Row(
          children: <Widget>[
            Radio(
              value: 'Shop',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value;
                });
              },
            ),
            Text('ร้านค้า')
          ],
        ),
      );

  Widget riderRadio() => Container(
        width: 150.0,
        child: Row(
          children: <Widget>[
            Radio(
              value: 'Rider',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value;
                });
              },
            ),
            Text('ผู้ส่ง')
          ],
        ),
      );

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

  Widget emailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value.trim(),
              decoration: InputDecoration(
                labelText: 'Email :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextField(
              onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(
                labelText: 'Password :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
