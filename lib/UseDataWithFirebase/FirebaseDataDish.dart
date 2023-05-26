import 'package:firebase_database/firebase_database.dart';

import '../page/home/entity/Dish.dart';

class FirebaseDataDish
{
  final ref=FirebaseDatabase.instance.ref();
  Future<List<Dish>> getDishes() async {
    List<Dish> dishes = [];
    List<String> priorityList = ['food', 'drink', 'dessert'];
    ref
        .child('dishes')
        .onValue
        .listen((event) {
      List<Object?> a = event.snapshot.value as List<Object?>;
      List<Object> nonNullableList = a
          .where((element) => element != null)
          .toList()
          .cast<Object>();
      for (var element in nonNullableList) {
        Map<String, dynamic> map = Map.from(element as dynamic);
        dishes.add(Dish.fromSnapshot(map));
        dishes.sort((a, b) {
          {
            final priorityA = priorityList.indexOf(a.type);
            final priorityB = priorityList.indexOf(b.type);
            return priorityA.compareTo(priorityB);
          }
        });
      }
    });
    return dishes;
  }
}
