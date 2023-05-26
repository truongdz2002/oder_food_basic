import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oder_food/ManagerCache/ManagerCache.dart';
import 'package:oder_food/UseDataFromApi/ApiDataDish.dart';
import '../page/home/entity/Dish.dart';
import '../page/Splash_screen/presentation/view/SlashScreen.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(
      const MaterialApp(
    home: SlashScreen(),
    debugShowCheckedModeBanner: false,
  ),
  );
  //cretateMemoryCache();

}
Future<void> cretateMemoryCache()
async {
  final ApiDataDish apiDataDish=ApiDataDish();
  final ManagerCache  managerCache=ManagerCache();
  List<Dish> listDish= await apiDataDish.getDataDishApi();
  List<Dish> listDishNew=[];
  managerCache.saveDishListToCache(listDish);

}
