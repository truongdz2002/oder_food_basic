import 'package:oder_food/Cart/ModuleCart.dart';
import 'package:oder_food/Infor_Oder.dart';

class ModuleBillOderFood{
  final String id;
  final ModuleCart moduleCart;
  final String dateOder;
  final Infor_Oder infor_oder;
  final int totalPayment;
  final String methodsPayment;
  final bool view;

  ModuleBillOderFood({required this.id,required this.moduleCart,required this.dateOder,required this.infor_oder,
    required this.totalPayment,required this.methodsPayment,required this.view});

  Map<String,dynamic> toJson()
  {
    return{
      'Id':id,
      'ModuleCart':moduleCart.toJson(),
      'DateOder':dateOder,
      'Infor_Oder':infor_oder.toJson(),
      'TotalPayment':totalPayment,
      'MethodsPayment':methodsPayment,
      'View':view
    };
  }
  factory ModuleBillOderFood.fromSnapshot(Map<String,dynamic> value)
  {
    Map<String,dynamic> mapModuleCart=Map.from(value['ModuleCart'] as dynamic);
    Map<String,dynamic> mapinforOder=Map.from(value['Infor_Oder'] as dynamic);
    return ModuleBillOderFood(id: value['Id'], moduleCart:ModuleCart.fromSnapShot(mapModuleCart) , dateOder: value['DateOder'], infor_oder:Infor_Oder.fromSnapshot(mapinforOder), totalPayment: value['TotalPayment'], methodsPayment:value[ 'MethodsPayment'],view: value['View']);
  }
  
}