import 'dart:core';

import 'package:firebase_database/firebase_database.dart';


class Dish
{
  final  String  Id;
  final  String urlImageDish;
  final  int priceDish;
  final  int amountBuyDish;
  final String nameDish;
     Dish({required this.Id,required this.urlImageDish,required this.priceDish,required this.amountBuyDish,
  required this.nameDish});
  Map<String, dynamic> toJson() {
    return {
      "Id":this.Id,
      "urlImageDish": this.urlImageDish,
      "priceDish": this.priceDish,
      "amountBuyDish": this.amountBuyDish,
      "nameDish": this.nameDish
    };
  }
  factory Dish.fromSnapshot(Map<String , dynamic> value) {
    return Dish(
        Id: value['Id'],
        urlImageDish: value['urlImageDish'],
        priceDish: value['priceDish'],
        amountBuyDish: value['amountBuyDish'],
        nameDish: value['nameDish']
    );
  }


}