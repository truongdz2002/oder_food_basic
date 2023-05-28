
import 'dart:convert';

import 'package:oder_food/api/AddressUrl/AddressUrl.dart';
import 'package:oder_food/page/home/entity/Dish.dart';
import 'package:http/http.dart' as http;

class ApiDataDish{
  Future< List<Dish>> getDataDishApi()
  async {
    List<Dish> dishList=[];
    List<String> priorityList = ['food', 'drink', 'dessert'];
    final response= await http.get(Uri.parse(AddressUrL.baseUrl+AddressUrL.listDish));
    List<dynamic> dataDish=[];
    if(response.statusCode==200)
    {
      dataDish=jsonDecode(response.body);
    }
    else
    {
      throw Exception('Lỗi khi tải dữ liệu từ API');
    }
    for(var element in dataDish)
    {
      dishList.add(Dish.fromSnapshotApi(element));
    }
    dishList.sort((a, b) {
      {
        final priorityA = priorityList.indexOf(a.type);
        final priorityB = priorityList.indexOf(b.type);
        return priorityA.compareTo(priorityB);
      }
    });
    return dishList;
  }
  Future<List<Dish>> getFoodList()
  async {
    List<Dish> dishList=[];
    List<Dish> dishListAll=await getDataDishApi();
    for(var element in dishListAll) {
     if(element.type=='food')
       {
         dishList.add(element);
       }
    }
    return  dishList;
  }
  Future<List<Dish>> getDrinkList()
  async {
    List<Dish> dishList=[];
    List<Dish> dishListAll=await getDataDishApi();
    for(var element in dishListAll) {
      if(element.type=='drink')
      {
        dishList.add(element);
      }
    }
    return  dishList;
  }
  Future<List<Dish>> getDessertList()
  async {
    List<Dish> dishList=[];
    List<Dish> dishListAll=await getDataDishApi();
    for(var element in dishListAll) {
      if(element.type=='dessert')
      {
        dishList.add(element);
      }
    }
    return  dishList;
  }
}