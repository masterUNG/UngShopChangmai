import 'package:flutter/material.dart';
import 'package:ungshopfirebase/widget/add_food_menu.dart';

class ShowListFood extends StatefulWidget {
  @override
  _ShowListFoodState createState() => _ShowListFoodState();
}

class _ShowListFoodState extends State<ShowListFood> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        showListFoodMenu(),
        addMenuFood(),
      ],
    );
  }

  Widget addMenuFood() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => AddFoodMenu(),
                  );Navigator.push(context, route);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Text showListFoodMenu() {
    return Text('This is List Food Menu');
  }
}
