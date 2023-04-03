import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SlashScreen/SlashScreen.dart';
import 'firebase_options.dart';
import 'SignIn_SignOut_Login/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(

    home: SlashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
