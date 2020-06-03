import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungshopfirebase/widget/guest.dart';

Future<Null> confirmSignOut(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text('คุณต้องการ Sign Out จริงๆ หรือ'),
      children: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                await auth.signOut().then((value) {
                  // exit(0);
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => Guest(),
                  );
                  Navigator.pushAndRemoveUntil(
                      context, route, (route) => false);
                });
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

class MyAPI {
  IconButton signOutProcess(BuildContext context) => IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () => confirmSignOut(context),
      );

  MyAPI();
}
