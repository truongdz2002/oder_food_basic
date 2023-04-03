import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oder_food/page_Home.dart';

import '../RequestPermission/RequestPermissionDevice.dart';
import '../SignIn_SignOut_Login/Login.dart';
class SlashScreen extends StatefulWidget {
  const SlashScreen({Key? key}) : super(key: key);

  @override
  State<SlashScreen> createState() => _SlashScreenState();
}

class _SlashScreenState extends State<SlashScreen> {
  @override
   void initState(){
    super.initState();
    AutoLogin();
  }
  Future<void> AutoLogin()
  async {
    final user = await FirebaseAuth.instance.currentUser;
    Timer(const Duration(seconds: 3), () {
      if(user==null)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));

      }
      else
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Container(
          height: 160,
          child: FittedBox(
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/logo_oder_food.png'
              ),
            ),
          ),
        ),
      ) ,
    );
  }
}
