import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oder_food/Cart/ModuleCart.dart';
import 'package:oder_food/Infor_Oder.dart';
import 'package:oder_food/ModuleBillOderFood.dart';
import 'package:oder_food/RequestPermission/RequestPermissionDevice.dart';
import 'package:skeletons/skeletons.dart';
import 'package:intl/intl.dart';
import '../Dish/Dish.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  TextEditingController edtPhoneNumber=TextEditingController();
  TextEditingController edtAddressDelivery=TextEditingController();
  TextEditingController edtNameUser=TextEditingController();
  List<ModuleCart> moduleCartList=[];
  int ok=0;
  Infor_Oder? infor_oder;
  ModuleCart? moduleCart;
  List<Infor_Oder> inforOderList=[];
  final user=FirebaseAuth.instance.currentUser!;
    bool _isLoading=true;
    int txtTotalMoneyDish=0;
    int  viewQuantity=1;
    int id=0;
    String messageNotification='';
    final RequestPermissionDevice requestPermissionDevice=RequestPermissionDevice();
    TextEditingController edtViewQuantity=TextEditingController();
    final DatabaseReference ref=FirebaseDatabase.instance.ref();
  @override
  void initState() {
    GetDataDishesInCartOfUser();
    GetInforOderOfUser();
    requestPermissionDevice.Intialize();
    Future.delayed(const Duration(seconds: 3),()
    {
          setState(() {
            _isLoading=false;
          });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          //List Dishes In Cart Of User
          SizedBox(
            height: 630,
            child: _isLoading
                   ?Skeleton(isLoading:_isLoading, skeleton: SkeletonListView(), child: Container())
                   :ListView(
                    children: moduleCartList.map((e)
                    {
                      //Item List
                      return Item(e);
                    }).toList(),
                  ),
                ),
           //Progress Oder
           Container(
             color: Colors.green,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                 children: [
                   const Padding(
                     padding: EdgeInsets.all(8.0),
                     child: Text('Tổng tiền :',style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 16,
                       color: Colors.black
                     ),
                     ),
                   ),
                   SizedBox(
                     width: 180
                     ,child: Text('${txtTotalMoneyDish.toString()} VND',style: const TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 16,
                         color: Colors.orange
                     ),
                     ),
                   ),
                   Container(
                     margin: const EdgeInsets.only(left:5),
                     child: ElevatedButton(onPressed:(){
                       if(moduleCart==null)
                       {
                         Fluttertoast.showToast(msg: 'Bạn chưa chọn món ăn để đặt hàng', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, fontSize: 16, backgroundColor: Colors.grey, textColor: Colors.black);
                         return;
                       }
                       else
                         {
                           //Show AlerDialog Get Infor Oder
                           showDialog<String>(context: context, builder: (context)=>AlertDialogAddInforbuyOder());
                         }

                       SetdataInforUserOder();
                     },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.orange
                       ), child:const Text('Đặt hàng',style:TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                     )
                     ),
                     ),
                   )
                 ],
               ),
             ),
           )
        ],
      )
    );
  }
  void PushBillOderCreated()
  {
    showDialog(context: context, builder: (context)
    {
      return const  Center(child: const CircularProgressIndicator());
    });
    String formattedDate = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());
    Infor_Oder inforOderNew=Infor_Oder(Id:DateTime.now().microsecondsSinceEpoch.toString(), Uid:user.uid, NameUser:edtNameUser.text, TelephoneDelevery:edtPhoneNumber.text, AddressDelevery: edtAddressDelivery.text);
    ModuleBillOderFood moduleBillOderFood=ModuleBillOderFood(Id:DateTime.now().microsecondsSinceEpoch.toString(), moduleCart:moduleCart!, dateOder:formattedDate, infor_oder: inforOderNew, totalPayment: moduleCart!.dish!.priceDish, methodsPayment: 'Tiền mặt');
    ref.child('BillOderCreated').child(moduleBillOderFood.Id).set(moduleBillOderFood.toJson()).then((value)
    {
      id=id+1;
      messageNotification='Bạn đã đặt thành công món  ${moduleBillOderFood.moduleCart.dish.nameDish} ,${moduleBillOderFood.moduleCart.quantity} suất với tổng tiền là ${moduleBillOderFood.totalPayment} VND ';
      Fluttertoast.showToast(msg: 'Đặt hàng  thành công', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, fontSize: 16, backgroundColor: Colors.grey, textColor: Colors.black);
      requestPermissionDevice.ShowNotification(id: id, title:'Đặt hàng thành công', body: messageNotification);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }
  Future<void> GetDataDishesInCartOfUser()
  async {
    List<ModuleCart> list=[];
    ref.child('DishesInCartUser').onValue.listen((event) {
      if(event.snapshot.value==null)
      {
        return;
      }
      final Map<Object?, Object?> data = event.snapshot.value as Map<Object?, Object?>;
      final List<Object?>listData = data.values.toList();
      List<Object> nonNullableList = listData.where((element) => element != null).toList().cast<Object>() ;
      for(var element in nonNullableList)
      {
        Map<String,dynamic> mapData=Map.from(element as dynamic);
        list.add(ModuleCart.fromSnapShot(mapData));
      }
      for(var element in list)
      {
        if(element.uidUser==user.uid)
        {
          moduleCartList.add(element);
        }
      }
    });
  }
  void DeleteDishInCartUser(String Id) {
    showDialog(context: context, builder: (context)
    {
      return const  Center(child: const CircularProgressIndicator());
    });
    ref.child('DishesInCartUser').child(Id).remove().then((value) {
      Fluttertoast.showToast(msg: 'Xoá món ăn khỏi giỏ hàng thành công', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, fontSize: 16, backgroundColor: Colors.grey, textColor: Colors.black);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      ok=1;
    });
  }
  void AddInforDeliveryOfUser()
  {
    Infor_Oder inforOderNew=Infor_Oder(Id:DateTime.now().microsecondsSinceEpoch.toString(), Uid:user.uid, NameUser:edtNameUser.text, TelephoneDelevery:edtPhoneNumber.text, AddressDelevery: edtAddressDelivery.text);
    if(inforOderNew.AddressDelevery.isEmpty || inforOderNew.TelephoneDelevery.isEmpty || inforOderNew.NameUser.isEmpty)
    {
      Fluttertoast.showToast(msg:'Chưa có thông tin để giao hàng', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, fontSize: 16, backgroundColor: Colors.grey, textColor: Colors.black);
      return;
    }
    if(infor_oder!=null)
    {
      if(infor_oder?.NameUser==edtNameUser.text && infor_oder?.TelephoneDelevery==edtPhoneNumber.text && infor_oder?.AddressDelevery==edtAddressDelivery.text)
      {
        return;
      }
    }
    else
    {
      ref.child('Infor_Oder').child(inforOderNew.Id).set(inforOderNew.toJson());
    }
  }
  void UpdateListDishesInCartOfUser()
  {
    ref.child('DishesInCartUser').onChildRemoved.listen((event) {

      Map<String,dynamic> mapDataRemoved=Map.from(event.snapshot.value as dynamic);
      ModuleCart moduleCart=ModuleCart.fromSnapShot(mapDataRemoved);

      for(var element in moduleCartList)
      {
        if(moduleCart.Id==element.Id)
        {
            moduleCartList.remove(element);
        }
      }
    });
  }
  void CheckClickDishes()
  {

  }
  void SetdataInforUserOder()
  {
    for(var element in inforOderList)
    {
      if(element.Uid==user.uid)
      {
        infor_oder=element;
        edtAddressDelivery.text=infor_oder!.AddressDelevery;
        edtPhoneNumber.text=infor_oder!.TelephoneDelevery;
        edtNameUser.text=infor_oder!.NameUser;
      }
    }
  }
  void GetInforOderOfUser()
  {
    ref.child('Infor_Oder').onValue.listen((event) {
      if(event.snapshot.value==null)
      {
        return;
      }
      final Map<Object?, Object?> data = event.snapshot.value as Map<Object?, Object?>;
      final List<Object?>listData = data.values.toList();
      List<Object> nonNullableList = listData.where((element) => element != null).toList().cast<Object>() ;
      for(var elemment in nonNullableList)
      {
        Map<String,dynamic> mapData=Map.from(elemment as dynamic);
        inforOderList.add(Infor_Oder.fromSnapshot(mapData));
      }
    });
  }
  Widget ProgressDeleteItemInCart(ModuleCart e)=>Container(
    margin: const EdgeInsets.only(left: 40),
    child: ElevatedButton(onPressed: ()=> showDialog<String>
      (context: context, builder: (context)=>AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10) ),
          side:BorderSide(
              color: Colors.orange,
              width: 1
          )
      ),
      title: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.orange,
                    width: 1
                )
            )
        ),
        alignment: Alignment.center,
        child: const Text('Thông báo'),
      ),
      content: Container(
        height: 50,
        alignment: Alignment.center,
        child: const Text('Bạn muốn xóa món ăn này khỏi giỏ hàng'),
      ),
      actions: [
        ElevatedButton(onPressed:(){
          Navigator.of(context).pop();
        },style:ElevatedButton.styleFrom(
            backgroundColor: Colors.orange
        ) , child: const Text('Hủy bỏ'),),
        ElevatedButton(onPressed:()
        {
            DeleteDishInCartUser(e.Id);
            if(ok==1)
              {
                setState(() {
                  moduleCartList.remove(e);
                  ok=0;
                });

              }//
        },style:ElevatedButton.styleFrom(
            backgroundColor: Colors.orange
        ), child: const Text('Đồng ý'),
        ),
      ],//
    )
    )
        ,style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            elevation: 2
        ), child: const Text('Xóa',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white
        ),)),
  );
   Widget AlertDialogAddInforbuyOder()=>AlertDialog(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.orange, width: 4)),
     title: Container(alignment: Alignment.center, decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.orange, width: 2))
     ),
       child: Text('Thông tin giao hàng',style: TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.bold
       ),),
     ),
     content: Container(
       height: 300,
       child: SingleChildScrollView(
         child: Column(
           children: [
             Container(
               height: 45,
               width: double.infinity,
               margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
               decoration: BoxDecoration(
                   color: Colors.grey.withOpacity(0.4),
                   borderRadius: BorderRadius.circular(16)
               ),
               child: Padding(
                 padding: const EdgeInsets.only(left: 15.0),
                 child: Center(
                   child: TextField(
                     controller: edtNameUser,
                     keyboardType: TextInputType.text,
                     decoration: const InputDecoration(
                         prefixIcon: Icon(Icons.account_circle_rounded),
                         border: InputBorder.none,
                         hintText:'Tên người nhận hàng'
                     ),
                   ),
                 ),
               ),
             ),
             const SizedBox(
               height: 20,
             ),
             Container(
               height: 45,
               margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
               decoration: BoxDecoration(
                   color: Colors.grey.withOpacity(0.4),
                   borderRadius: BorderRadius.circular(16)
               ),
               child: Padding(
                 padding: const EdgeInsets.only(left: 15.0),
                 child: Center(
                   child: TextField(
                     controller: edtPhoneNumber,
                     keyboardType: TextInputType.phone,
                     decoration: const InputDecoration(
                         border: InputBorder.none,
                         prefixIcon: Icon(Icons.phone_android),
                         hintText: 'Số điện thoại '
                     ),
                   ),
                 ),
               ),
             ),
             const SizedBox(
               height: 20,
             ),
             Container(
               height: 45,
               margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
               decoration: BoxDecoration(
                   color: Colors.grey.withOpacity(0.4),
                   borderRadius: BorderRadius.circular(16)
               ),
               child: Padding(
                 padding: const EdgeInsets.only(left: 15.0),
                 child: Center(
                   child: TextField(
                     controller: edtAddressDelivery,
                     keyboardType: TextInputType.text,
                     decoration: const InputDecoration(
                         border: InputBorder.none,
                         prefixIcon:Icon(Icons.cabin),
                         hintText: 'Địa chỉ giao hàng '
                     ),
                   ),
                 ),
               ),
             ),
             ElevatedButton(onPressed:()
             {
               AddInforDeliveryOfUser();
               PushBillOderCreated();
             },style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.orange,
                 elevation: 4
             ), child:
             Text('Xác nhận', style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 16,
                 color: Colors.white
             )
               ,)
             )
           ],
         ),
       ),
     ),
   );
  Widget Item(ModuleCart e) =>GestureDetector(
    onTap: ()
    {
      setState(() {
        txtTotalMoneyDish=e.quantity*e.dish.priceDish;
        moduleCart=e;
      });
    },
    child: Card(
        child:Column(
          children:[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    width: 120,
                    child: Image.network(e.dish.urlImageDish,fit: BoxFit.cover),
                  ),
                ),
                Column(
                  children: [
                    Text(e.dish.nameDish,style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black
                    ),
                    ),
                    Text('${NumberFormat.decimalPattern().format(e.dish.priceDish).replaceAll(',','.')} VND',style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center
                      ,children: [
                      const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Số lượng: ')
                      ),
                      SizedBox(
                        width: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: edtViewQuantity,
                            readOnly: true,
                            decoration: InputDecoration(border: InputBorder.none,
                                hintText: e.quantity.toString()),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                    )
                  ],
                ),
                ProgressDeleteItemInCart(e),
              ],
            ),

          ],
        )

    ),
  );
}




