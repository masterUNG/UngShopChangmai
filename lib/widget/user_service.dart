import 'package:flutter/material.dart';
import 'package:ungshopfirebase/utility/my_api.dart';

class UserService extends StatefulWidget {
  @override
  _UserServiceState createState() => _UserServiceState();
}

class _UserServiceState extends State<UserService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[MyAPI().signOutProcess(context)],
        title: Text('User Service'),
      ),
    );
  }
}
