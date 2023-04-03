import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class find_Food extends StatefulWidget {
  const find_Food({Key? key}) : super(key: key);

  @override
  State<find_Food> createState() => _find_FoodState();
}

class _find_FoodState extends State<find_Food> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ), onPressed: () {
            Navigator.pop(context);
        },
        ),
      )
      ,
    );
  }
}
