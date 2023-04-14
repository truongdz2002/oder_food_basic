import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'SlashScreen/SlashScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(const MaterialApp(
    home: SlashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
