import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungshopfirebase/widget/rider_service.dart';
import 'package:ungshopfirebase/widget/shop_service.dart';
import 'package:ungshopfirebase/widget/signin_page.dart';
import 'package:ungshopfirebase/widget/signup_page.dart';
import 'package:ungshopfirebase/widget/user_service.dart';

class Guest extends StatefulWidget {
  @override
  _GuestState createState() => _GuestState();
}

class _GuestState extends State<Guest> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser != null) {
      Firestore firestore = Firestore.instance;
      CollectionReference reference = firestore.collection('User');
      await reference.document(firebaseUser.uid).snapshots().listen((event) {
        String typeUser = event.data['TypeUser'];
        print('typeUser ==>> $typeUser');

         if (typeUser == 'User') {
        routeToService(UserService());
      }else if (typeUser == 'Shop') {
        routeToService(ShopService());
      } else {
        routeToService(RiderService());
      }
    

       });
    }
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
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text('Guest'),
      ),
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          signInMenu(),
          signUpMenu(),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      accountName: Text('Guest'),
      accountEmail: Text('Please Login'),
    );
  }

  ListTile signInMenu() => ListTile(
        onTap: () {
          routeToPage(SignInPage());
        },
        subtitle: Text('สำหรับ ผู้ซื้อ, ร้านค้า และ ผู้ส่ง'),
        title: Text('ลงชื่อเข้าใช้งาน'),
        leading: Icon(
          Icons.fingerprint,
          size: 36.0,
        ),
      );

  void routeToPage(Widget widget) {
    Navigator.pop(context);
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, route);
  }

  ListTile signUpMenu() => ListTile(
        onTap: () => routeToPage(SignUpPage()),
        subtitle: Text('สำหรับ สมัครเพื่อใช้งาน'),
        title: Text('สมัครสมาชิก'),
        leading: Icon(
          Icons.account_box,
          size: 36.0,
        ),
      );
}
