import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungshopfirebase/models/user_model.dart';
import 'package:ungshopfirebase/utility/my_api.dart';
import 'package:ungshopfirebase/widget/show_list_food.dart';
import 'package:ungshopfirebase/widget/show_list_order.dart';

class ShopService extends StatefulWidget {
  @override
  _ShopServiceState createState() => _ShopServiceState();
}

class _ShopServiceState extends State<ShopService> {
  UserModel userModel;
  Widget currentWidget = ShowListOrder();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLogin();
  }

  Future<Null> findLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.currentUser().then((value) async {
      Firestore firestore = Firestore.instance;
      await firestore
          .collection('User')
          .document(value.uid)
          .snapshots()
          .listen((event) {
        setState(() {
          userModel = UserModel.fromJson(event.data);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: currentWidget,
      drawer: Drawer(
        child: showDrawer(),
      ),
      appBar: AppBar(
        actions: <Widget>[MyAPI().signOutProcess(context)],
        title: Text('Shop Service'),
      ),
    );
  }

  Column showDrawer() {
    return Column(
      children: <Widget>[
        showHead(),
        listOrderMenu(),
        listFoodMenu(),
      ],
    );
  }

  ListTile listOrderMenu() {
    return ListTile(
      leading: Icon(Icons.fastfood),
      title: Text('List Order'),
      onTap: () {
        setState(() {
          currentWidget = ShowListOrder();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile listFoodMenu() {
    return ListTile(
      leading: Icon(Icons.message),
      title: Text('List Food Menu'),
      onTap: () {
        setState(() {
          currentWidget = ShowListFood();
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      accountName: Text(userModel == null ? 'Name ?' : userModel.name),
      accountEmail:
          Text(userModel == null ? 'Email' : 'Email = ${userModel.email}'),
    );
  }
}
