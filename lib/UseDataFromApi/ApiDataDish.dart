
import 'dart:convert';

import 'package:oder_food/Dish/Dish.dart';
import 'package:http/http.dart' as http;

class ApiDataDish{
  Future< List<Dish>> getDataDishApi()
  async {
    List<Dish> dishList=[];
    List<String> priorityList = ['food', 'drink', 'dessert'];
    final response= await http.get(Uri.parse('https://appbansmaytinh.000webhostapp.com/oder_food/apiDish/getDish.php'));
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
}