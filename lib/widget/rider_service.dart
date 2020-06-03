import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungshopfirebase/utility/my_api.dart';

class RiderService extends StatefulWidget {
  @override
  _RiderServiceState createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Service'),
        actions: <Widget>[MyAPI().signOutProcess(context)],
      ),
    );
  }

  IconButton signOutProcess() => IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () => confirmSignOut(),
      );

  Future<Null> confirmSignOut() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการ Sign Out จริงๆ หรือ'),
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () async{
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signOut().then((value) => exit(0));
                },
                child: Text('Sign Out'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancle'),
              )
            ],
          )
        ],
      ),
    );
  }
}
