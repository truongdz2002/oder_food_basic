import 'dart:core';

import 'package:firebase_database/firebase_database.dart';


class Dish
{
  final  String  Id;
  final  String urlImageDish;
  final  int priceDish;
  final  int amountBuyDish;
  final String nameDish;
  final String type;
  final double sale;
     Dish({required this.Id,required this.urlImageDish,required this.priceDish,required this.amountBuyDish,
  required this.nameDish,required this.type,required this.sale});
  Map<String, dynamic> toJson() {
    return {
      "Id":this.Id,
      "urlImageDish": this.urlImageDish,
      "priceDish": this.priceDish,
      "amountBuyDish": this.amountBuyDish,
      "nameDish": this.nameDish,
      "type":this.type,
      "sale":this.sale
    };
  }
  factory Dish.fromSnapshot(Map<String , dynamic> value) {
    return Dish(
        Id: value['Id'],
        urlImageDish: value['urlImageDish'],
        priceDish: value['priceDish'],
        amountBuyDish: value['amountBuyDish'],
        nameDish: value['nameDish'],
        type: value['type'],
        sale: value['sale']
    );
  }
  factory Dish.fromSnapshotApi(Map<String , dynamic> value) {
    String priceDishNew=value['priceDish'].toString();
    String amountBuyDishNew=value['amountBuyDish'].toString();
    String saleNew=value['sale'].toString();
    return Dish(
        Id: value['Id'],
        urlImageDish: value['urlImageDish'],
        priceDish: int.tryParse(priceDishNew)!,
        amountBuyDish: int.tryParse(amountBuyDishNew)!,
        nameDish: value['nameDish'],
        type: value['type'],
        sale: double.tryParse(saleNew)!
    );
  }


}