import 'package:oder_food/Cart/ModuleCart.dart';
import 'package:oder_food/Infor_Oder.dart';

class ModuleBillOderFood{
  final String Id;
  final ModuleCart moduleCart;
  final String dateOder;
  final Infor_Oder infor_oder;
  final int totalPayment;
  final String methodsPayment;

  ModuleBillOderFood({required this.Id,required this.moduleCart,required this.dateOder,required this.infor_oder,
    required this.totalPayment,required this.methodsPayment});

  Map<String,dynamic> toJson()
  {
    return{
      'Id':this.Id,
      'ModuleCart':this.moduleCart.toJson(),
      'DateOder':this.dateOder,
      'Infor_Oder':this.infor_oder.toJson(),
      'TotalPayment':this.totalPayment,
      'MethodsPayment':this.methodsPayment
    };
  }
  factory ModuleBillOderFood.fromSnapshot(Map<String,dynamic> value)
  {
    Map<String,dynamic> mapModuleCart=Map.from(value['ModuleCart'] as dynamic);
    Map<String,dynamic> mapInfor_Oder=Map.from(value['Infor_Oder'] as dynamic);
    return ModuleBillOderFood(Id: value['Id'], moduleCart:ModuleCart.fromSnapShot(mapModuleCart) , dateOder: value['DateOder'], infor_oder:Infor_Oder.fromSnapshot(mapInfor_Oder), totalPayment: value['TotalPayment'], methodsPayment:value[ 'MethodsPayment']);
  }
  
}