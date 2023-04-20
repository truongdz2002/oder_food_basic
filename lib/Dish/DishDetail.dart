import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oder_food/Dish/Dish.dart';
import 'package:oder_food/page_Home.dart';

import '../Cart/ModuleCart.dart';
class DishDetail extends StatefulWidget {
  const DishDetail({Key? key}) : super(key: key);

  @override
  State<DishDetail> createState() => _DishDetailState();
}

class _DishDetailState extends State<DishDetail> {
  int  viewQuantity=1;
  List<ModuleCart> moduleCartList=[];
  DatabaseReference ref=FirebaseDatabase.instance.ref();
  final user=FirebaseAuth.instance.currentUser!;
  late ModuleCart moduleCart;
  TextEditingController edtViewQuantity =TextEditingController();
  @override
  void initState() {
    GetDataDishesInCartOfUser();
    super.initState();
  }
  Future<void> GetDataDishesInCartOfUser()
  async {
    List<ModuleCart> list=[];
    await  ref.child('DishesInCartUser').onValue.listen((event) {
      final Map<Object?, Object?> data = event.snapshot.value as Map<Object?, Object?>;
      final List<Object?>listData = data.values.toList();
      List<Object> nonNullableList = listData.where((element) => element != null).toList().cast<Object>() ;
      for(var elemment in nonNullableList)
      {
        Map<String,dynamic> mapData=Map.from(elemment as dynamic);
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
  void PushDataDishUserWantToBuy(int quantity,Dish dish)
  {
    moduleCart=ModuleCart(Id:DateTime.now().microsecondsSinceEpoch.toString() , uidUser: user.uid, quantity: quantity, dish: dish);
    ref.child('DishesInCartUser').child(moduleCart.Id).set(moduleCart.toJson()).
    then((value) {
      Fluttertoast.showToast(
          msg:'Thêm vào giỏ hàng  thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16,
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
      Navigator.pop(context);
    });
  }
    @override
    Widget build(BuildContext context) {
      edtViewQuantity.text=viewQuantity.toString();
      final Dish dataDish=ModalRoute.of(context)!.settings.arguments as Dish;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          elevation: 1,
          title: const Text("Chi tiết món ăn",style: TextStyle(
              color: Colors.white
          ),),
          actions: [
            IconButton(onPressed: (){
              showModalBottomSheet(context:context, builder: (context)
              {
                return Container(
                  height: 250,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child:Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: SizedBox(
                                width: 200,
                                child: Image.network(dataDish.urlImageDish,fit: BoxFit.cover),
                              ),
                            ),
                            Column(
                              children: [
                                Text(dataDish.nameDish,style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                                ),
                                Text('${NumberFormat.decimalPattern().format(dataDish.priceDish).replaceAll(',','.')} VND',style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.orange
                                ),
                                ),
                                Row(
                                   mainAxisAlignment: MainAxisAlignment.center
                                  ,children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(onPressed: ()
                                      {
                                        if(viewQuantity>1)
                                          {
                                            viewQuantity=viewQuantity-1;
                                            edtViewQuantity.text=viewQuantity.toString();
                                          }
                                      },style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                          minimumSize:const Size(30, 30),
                                          elevation: 4
                                      ), child:Icon(Icons.remove,color: Colors.black),),
                                    ),

                                        Container(
                                            width: 30,
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: TextField(
                                                controller: edtViewQuantity,
                                                readOnly: true,decoration: InputDecoration(border: InputBorder.none),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                        ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(onPressed: ()
                                      {
                                        if(viewQuantity<10 )
                                          viewQuantity=viewQuantity+1;
                                          edtViewQuantity.text=viewQuantity.toString();

                                      },style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white, minimumSize:const Size(30, 30),
                                        elevation: 4,
                                      ), child:const Icon(Icons.add, color: Colors.black,),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed:(){ Navigator.pop(context);},
                                style:ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange
                                ), child: const Text('Hủy bỏ'),
                              ),
                              ElevatedButton(onPressed: ()
                                  {
                                    for(var element in moduleCartList)
                                      {
                                        if(element.dish.nameDish==dataDish.nameDish)
                                          {
                                            Fluttertoast.showToast(
                                                msg:'Món ăn đã có trong giỏ hàng  ',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                fontSize: 16,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.black
                                            );
                                            Navigator.pop(context);
                                            return;
                                          }
                                      }
                                    PushDataDishUserWantToBuy(viewQuantity, dataDish);
                                  },
                                  style:ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange
                                  ), child: const Text('Thêm vào giỏ hàng')),
                            ],
                          ),
                        )
                      ],
                    )
                );
              });
            }, icon:const Icon(Icons.add_shopping_cart))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.network(dataDish.urlImageDish,fit: BoxFit.cover,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(dataDish.nameDish,style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Giá:",style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("${NumberFormat.decimalPattern().format(dataDish.priceDish).replaceAll(',','.')} VND",style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2.85
                          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("${NumberFormat.decimalPattern().format(dataDish.priceDish).replaceAll(',','.')} VND",style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,

                          ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.orange,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: const [
                        Text('Mô tả món ăn ',style:
                        TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange
                        ),),
                      ],
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      );
    }
  }

