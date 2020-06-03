import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungshopfirebase/utility/normal_dialog.dart';
import 'package:ungshopfirebase/widget/rider_service.dart';
import 'package:ungshopfirebase/widget/shop_service.dart';
import 'package:ungshopfirebase/widget/user_service.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String email = '', password = '';

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextField(
              obscureText: true,
              onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(
                labelText: 'Password :',
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

  Future<Null> checkAuthen() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      Firestore firestore = Firestore.instance;
      await firestore
          .collection('User')
          .document(value.user.uid)
          .snapshots()
          .listen((event) {
            String typeUser = event.data['TypeUser'];
            print('######## typeUser ===>>> $typeUser');
             if (typeUser == 'User') {
        routeToService(UserService());
      }else if (typeUser == 'Shop') {
        routeToService(ShopService());
      } else {
        routeToService(RiderService());
      }
          });
    }).catchError((value) {
      String string = value.message;
      normalDialog(context, string);
    });
  }

  void routeToService(Widget widget) {
     MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        onPressed: () => checkAuthen(),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            emailForm(),
            passwordForm(),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('ลงชื่อเข้าใช้งาน'),
      ),
    );
  }
}
