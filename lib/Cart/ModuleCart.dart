import 'package:oder_food/Dish/Dish.dart';

class   ModuleCart{
   final String Id;
   final String uidUser;
   final int quantity;
   final Dish  dish;

   ModuleCart({required this.Id,required this.uidUser,required this.quantity,required this.dish});
   Map<String,dynamic> toJson()
   {
     return
         {
           'Id':this.Id,
           'Uid':this.uidUser,
           'dish':this.dish.toJson(),
           'quantity':this.quantity
         };
   }
   factory ModuleCart.fromSnapShot(Map<String,dynamic> value)
   {
     Map<String,dynamic> mapDish=Map.from(value['dish'] as dynamic);
     return ModuleCart(Id: value['Id'], uidUser: value['Uid'], quantity:value['quantity'], dish: Dish.fromSnapshot(mapDish));
   }
}