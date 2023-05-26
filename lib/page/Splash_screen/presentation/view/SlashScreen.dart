import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oder_food/page/page_navigation_screen/presentation/view/page_Home.dart';

import '../../../../RequestPermission/RequestPermissionDevice.dart';
import '../../../Login/presentation/view/Login.dart';
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));

      }
      else
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Container(
          color: Colors.white,
          height: 160,
          child: const FittedBox(
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/logo_oder_food.png'
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ) ,
    );
  }
}
