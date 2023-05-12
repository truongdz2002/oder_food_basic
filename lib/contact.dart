import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oder_food/RequestPermission/RequestPermissionDevice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletons/skeletons.dart';

import 'Dish/Dish.dart';

class contact extends StatefulWidget {
  const contact({Key? key}) : super(key: key);

  @override
  State<contact> createState() => _contactState();
}

class _contactState extends State<contact> {
 bool  _isLoading=true;
 DatabaseReference ref =FirebaseDatabase.instance.ref();
 int  id=0;
 String text='';
 List<Dish> list=[
   Dish(Id:'1', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/%C4%91%C3%B9i%20g%C3%A0%20chi%C3%AAn%20n%C6%B0%E1%BB%9Bng%20m%E1%BA%AFm.jpg', priceDish:100000, amountBuyDish: 0, nameDish:'Đùi gà chiên mắm', type:'food',sale:0.05),
   Dish(Id:'2', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/b%C3%A1nh%20x%C3%A8o.jpg', priceDish:20000, amountBuyDish: 0, nameDish:'Bánh xèo', type:'food',sale:0.05),
   Dish(Id:'3', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/banh-cuon.jpg', priceDish:100000, amountBuyDish: 0, nameDish:'Bánh cuốn', type:'food',sale:0.05),
   Dish(Id:'4', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/b%C3%A0nhlan.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Bánh flan', type:'dessert',sale:0.05),
   Dish(Id:'5', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/b%C3%BAn_cha.jpg', priceDish:25000, amountBuyDish: 0, nameDish:'Bún chả ', type:'food',sale:0.05),
   Dish(Id:'6', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/ca-ri-ga-cay.jpg', priceDish:50000, amountBuyDish: 0, nameDish:'Cari cay', type:'food',sale:0.05),
   Dish(Id:'7', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/caolau.jpg', priceDish:100000, amountBuyDish: 0, nameDish:'Cao lẩu', type:'food',sale:0.05),
   Dish(Id:'8', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/com_tam.jpg', priceDish:60000, amountBuyDish: 0, nameDish:'Cơm tấm ', type:'food',sale:0.05),
   Dish(Id:'9', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/goicuon.jpg', priceDish:100000, amountBuyDish: 0, nameDish:'Gỏi cuốn', type:'food',sale:0.05),
   Dish(Id:'10', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/nomhoachuoi.jpg', priceDish:100000, amountBuyDish: 0, nameDish:'Nộm hoa chuối', type:'food',sale:0.05),
   Dish(Id:'11', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/ph%E1%BB%9F%20b%C3%B2.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Phở bò ', type:'food',sale:0.05),
   Dish(Id:'12', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/suon-xao-chua-ngot.jpg', priceDish:100000, amountBuyDish: 0, nameDish:'Sườn chua ngọt', type:'food',sale:0.05),
   Dish(Id:'13', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/top-15-hinh-anh-mon-an-ngon-viet-nam-khien-ban-khong-the-roi-mat-7.jpg', priceDish:35000, amountBuyDish: 0, nameDish:'Bún rêu cua', type:'food',sale:0.05),
   Dish(Id:'14', urlImageDish:'https://d1sag4ddilekf6.azureedge.net/cuisine/40/icons/upload-photo-icon_f71f7805786348b694d2a9a886b85cee_1549034196325788582.jpeg', priceDish:50000, amountBuyDish: 0, nameDish:'Cháo sườn', type:'food',sale:0.05),
   Dish(Id:'15', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/PIZZA.jpg', priceDish:100000, amountBuyDish: 0, nameDish:'Pizza', type:'food',sale:0.05),
   Dish(Id:'16', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/tra-hoa-qua.jpg', priceDish:20000, amountBuyDish: 0, nameDish:'Trà hoa quả', type:'drink',sale:0.05),
   Dish(Id:'17', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/matcha-tra-xanh.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Matcha trà xanh', type:'drink',sale:0.05),
   Dish(Id:'18', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/tra-dao-chanh-sa.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Trà đào chanh sả', type:'drink',sale:0.05),
   Dish(Id:'19', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/TRA-SUA-HOKKAIDOU.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Trà sửa hokaidou', type:'drink',sale:0.05),
   Dish(Id:'20', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/cacao-nong.jpg', priceDish:50000, amountBuyDish: 0, nameDish:'Ca cao', type:'drink',sale:0.05),
   Dish(Id:'21', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/socola-da-xay.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Socola đá xay', type:'drink',sale:0.05),
   Dish(Id:'22', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/soda-viet-quat.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Soda việt quất', type:'drink',sale:0.05),
   Dish(Id:'23', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/Ch%C3%A8_%C4%91%E1%BA%ADu_%C4%91%E1%BB%8F.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Chè đậu đỏ', type:'dessert',sale:0.05),
   Dish(Id:'24', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/B%C3%A1nh_chu%E1%BB%91i_n%C6%B0%E1%BB%9Bng.jpg', priceDish:20000, amountBuyDish: 0, nameDish:'Bánh chuối nướng', type:'dessert',sale:0.05),
   Dish(Id:'25', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/B%C3%A1nh_da_l%E1%BB%A3n.jpg', priceDish:10000, amountBuyDish: 0, nameDish:'Bánh da lợn', type:'dessert',sale:0.05),
   Dish(Id:'26', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/S%C6%B0%C6%A1ng%20%20s%C3%A1o%20n%C6%B0%E1%BB%9Bc%20c%E1%BB%91t%20d%E1%BB%ABa.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Sương sáo cốt dừa', type:'dessert',sale:0.05),
   Dish(Id:'27', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/Ch%C3%A8%20d%E1%BB%ABa%20d%E1%BA%A7m.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Chè dừa dầm', type:'dessert',sale:0.05),
   Dish(Id:'28', urlImageDish:'https://appbansmaytinh.000webhostapp.com/Image/B%C3%A1nh%20chu%E1%BB%91i%20h%E1%BA%A5p%20n%C6%B0%E1%BB%9Bc%20c%E1%BB%91t%20d%E1%BB%ABa.jpg', priceDish:30000, amountBuyDish: 0, nameDish:'Bánh chuối cốt dừa', type:'dessert',sale:0.05)
 ];
 late final RequestPermissionDevice requestPermissionDevice;
 Future<void> requestPermissionLocal()
 async {
   PermissionStatus status= await Permission.location.request();
   if(status.isGranted)
     {
       getCurrentAddress();
       showAddress();
     }
   else
     {

     }
 }
 void showAddress()
 {
   ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(content:Text('Thanh hoa'),leading:const Icon(Icons.location_on,color:Colors.orange,),
       backgroundColor: Colors.white,
       elevation:5,
       actions:[
         IconButton(onPressed:(){
           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
         }, icon: const Icon(Icons.disabled_by_default,color: Colors.grey,))
       ]));
 }
 void getCurrentAddress() async {
   Position position = await Geolocator.getCurrentPosition(
     desiredAccuracy: LocationAccuracy.high,
   );

   List<Placemark> placemarks = await placemarkFromCoordinates(
     position.latitude,
     position.longitude,
   );
   Placemark placemark = placemarks[0];
   String address = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}';
   setState(() {
     text=address;
   });


 }

 @override
  void initState() {
    //requestPermissionLocal();
    requestPermissionDevice=RequestPermissionDevice();
    requestPermissionDevice.Intialize();
      Future.delayed(const Duration(seconds: 1),()
      {
        setState(() {
        _isLoading=false;
      });
    });
      super.initState();
  }
  void UpdatedataDish()
  {
    for(var element in list)
      {
        ref.child('dishes').child(element.Id).set(element.toJson());
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        _isLoading
            ? Skeleton(
          isLoading: true,
          skeleton: SkeletonListView(),
          child: Container(),
        )
            : Container(
          child: Center(
            child: ElevatedButton(onPressed:()
                async {
                  UpdatedataDish();
                   //id=id+1;
                 // await  requestPermissionDevice.ShowNotification(id: id, title:'Món ăn oder', body: 'ok');
                }, child: Text(text.isEmpty ? '' : text)),
          ),
        ),
      ),

    );
  }
}
