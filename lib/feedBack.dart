import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class feedBack extends StatefulWidget {
  const feedBack({Key? key}) : super(key: key);

  @override
  State<feedBack> createState() => _feedBackState();
}

class _feedBackState extends State<feedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Feedback"),
      ),
    );
  }
}
