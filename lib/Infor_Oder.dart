import 'dart:core';

class Infor_Oder{
  final String Id;
  final String Uid;
  final String NameUser;
  final String TelephoneDelevery;
  final String AddressDelevery;

  Infor_Oder({ required this.Id,required this.Uid,required this.NameUser,required this.TelephoneDelevery,
    required this.AddressDelevery});
  Map<String,dynamic> toJson()
  {
    return {
      'Id':this.Id,
      'Uid':this.Uid,
      'NameUser':this.NameUser,
      'TelephoneDelivery':this.TelephoneDelevery,
      'AddressDelivery':this.AddressDelevery,
    };
  }
  factory Infor_Oder.fromSnapshot(Map<String,dynamic> value)
  {
    return Infor_Oder(Id: value['Id'], Uid: value['Uid'], NameUser: value['NameUser'], TelephoneDelevery: value['TelephoneDelivery'], AddressDelevery: value['AddressDelivery']);
  }
}