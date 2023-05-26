import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oder_food/page/home/entity/Dish.dart';
import 'package:oder_food/page/page_navigation_screen/presentation/view/page_Home.dart';

import '../../../cart/entity/ModuleCart.dart';
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
  List<Dish> listDishes=[];
  List<Dish> listDrink=[];
  TextEditingController edtViewQuantity =TextEditingController();
  @override
  void initState() {
    getDataDishesInCartOfUser();
    getDataDishRealTimeDataBase();
    super.initState();
  }
  Future<void> getDataDishRealTimeDataBase()
  async {
    List<Dish> allDishes = [];
    List<Dish> dishes = [];
    List<Dish> drink = [];
    ref.child('dishes').onValue.listen((event) {
      List<Object?> a=event.snapshot.value as List<Object?>;
      List<Object> nonNullableList = a.where((element) => element != null).toList().cast<Object>() ;
      for (var element in nonNullableList) {
        Map<String, dynamic> map = Map.from(element as dynamic);
        allDishes.add(Dish.fromSnapshot(map));
        for(var element in allDishes)
          {
            if(element.type=='food')
              {
                dishes.add(element);
              }
          }
        for(var element in allDishes)
        {
          if(element.type=='drink')
          {
            drink.add(element);
          }
        }
       setState(() {
         listDishes=dishes;
         listDrink=drink;
       });
        //listDishes.sort((a,b)=>b.amountBuyDish.compareTo(a.amountBuyDish));
      }
    });
  }
  Future<void> getDataDishesInCartOfUser()
  async {
    List<ModuleCart> listall=[];
    List<ModuleCart> list=[];
    ref.child('DishesInCartUser').onValue.listen((event) {
      if(event.snapshot.value==null) return;
      final Map<Object?, Object?> data = event.snapshot.value as Map<Object?, Object?>;
      final List<Object?>listData = data.values.toList();
      List<Object> nonNullableList = listData.where((element) => element != null).toList().cast<Object>() ;
      for(var elemment in nonNullableList)
      {
        Map<String,dynamic> mapData=Map.from(elemment as dynamic);
        listall.add(ModuleCart.fromSnapShot(mapData));
      }
      for(var element in listall)
        {
          if(element.uidUser==user.uid)
            {
              list.add(element);
            }
        }
      setState(() {
        moduleCartList=list;
      });
    });
  }
  void pushDataDishUserWantToBuy(int quantity,Dish dish)
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
      moduleCartList.clear();
      getDataDishesInCartOfUser();
    });
  }
    @override
    Widget build(BuildContext context) {
      edtViewQuantity.text=viewQuantity.toString();
      final Dish dataDish=ModalRoute.of(context)!.settings.arguments as Dish;
      final priceReal=dataDish.priceDish-dataDish.priceDish*dataDish.sale;
      return Scaffold(
        extendBodyBehindAppBar:true,
        appBar: AppBar(
          backgroundColor: Colors.black12,
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
                              padding: const EdgeInsets.all(12),
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
                                      ), child:const Icon(Icons.remove,color: Colors.black),),
                                    ),

                                        SizedBox(
                                            width: 30,
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: TextField(
                                                controller: edtViewQuantity,
                                                readOnly: true,decoration: InputDecoration(border: InputBorder.none),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                        ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(onPressed: ()
                                      {
                                        if(viewQuantity<10 ) {
                                          viewQuantity=viewQuantity+1;
                                        }
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
                                    pushDataDishUserWantToBuy(viewQuantity, dataDish);
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
                        Text('${dataDish.nameDish} ',style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      Text(' Giảm giá ${(dataDish.sale*100).toInt().toString()}%',style: const TextStyle(
                      fontSize: 14,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.normal
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
                          child: Text("${NumberFormat.decimalPattern().format(priceReal).replaceAll(',','.')} VND",style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,

                          ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                       CircleAvatar(
                         backgroundImage: AssetImage('assets/logo_oder_food.png'),
                       ),
                        Padding(
                          padding: EdgeInsets.only(left:8),
                          child: Text('Giao hàng miễn phí cho mọi người '),
                        )
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
                        Text('Món ăn phổ biến ',style:
                        TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange
                        ),),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 230,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:listDishes.map((e)
                        {
                          return items(e);
                        }).toList() ,
                      ),
                    ),
                    Row(
                      children: const [
                        Text('Bạn muốn dùng thêm đồ uống  ',style:
                        TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange
                        ),),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 230,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:listDrink.map((e)
                        {
                          return items(e);
                        }).toList() ,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar:BottomAppBar(
          child:Row(
            children: [
              Stack(
                children: [
                  IconButton(onPressed: (){
                    showModalBottomSheet(context: context, builder:(context)
                    {
                      return cartUser();
                    });
                  }, icon: const Icon(Icons.shopping_basket,color:Colors.orange,size: 35,)),// Icon chính
                  moduleCartList.isEmpty ?
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(moduleCartList.isEmpty ? '' :moduleCartList.length.toString(), // Số thông báo
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  :Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(moduleCartList.isEmpty ? '' :moduleCartList.length.toString(), // Số thông báo
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              ,
               SizedBox(width: 250,child: Text('${NumberFormat.decimalPattern().format(priceReal).replaceAll(',','.')} VND',textAlign: TextAlign.end,style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.normal,
                 fontSize: 18
              ),)),
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: TextButton(onPressed:(){},
                  style: const ButtonStyle(
                    backgroundColor:MaterialStatePropertyAll(Colors.orange)
                  ), child:const Text('Đặt hàng',style:TextStyle(
                  color: Colors.white
                ) ,),
                ),
              )
            ],
          ),
        ),
      );
    }
  Widget items(Dish item)=>GestureDetector(
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const DishDetail(),settings: RouteSettings(
          arguments: item
      ) ));
    },
    child: SizedBox(
      width:200,
      height:180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height:100,
                width: 250,
                child: Image.network(item.urlImageDish,fit:BoxFit.fill,),
              ),
              Text(item.nameDish,style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
              ),
              Text('${NumberFormat.decimalPattern().format(item.priceDish).replaceAll(',','.')}  VND',style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2.85
              ),)
              ,
              Text('${NumberFormat.decimalPattern().format(item.priceDish-item.priceDish*item.sale).replaceAll(',','.')}  VND',style: const TextStyle(
                  fontSize: 14,
                  color: Colors.orange
              ),)
            ],
          ),
        ),
      ),
    ),
  );
  Widget cartUser() => Column(
    children: [
      const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('Giỏ hàng',textAlign: TextAlign.center,style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.orange
        ),),
      ),
      moduleCartList.isEmpty ?
      SizedBox(
        height:350,
        child: Center(
          child: Column(
            children: const [
              Icon(Icons.map_outlined,size: 200,color: Colors.grey,),
              Text('Bạn chưa lựa món ăn để đặt hàng',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),)
            ],
          ),
        ),
      ) :
      SizedBox(
        width:double.infinity,
        height:350,
        child: ListView(
          children:moduleCartList.map((e){
            return itemCart(e);
          }).toList(),
        ),
      ),
    ],
  );
  Widget itemCart(ModuleCart e) =>GestureDetector(
    onTap: ()
    {

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
                    Text('${NumberFormat.decimalPattern().format(e.dish.priceDish-e.dish.priceDish*e.dish.sale).replaceAll(',','.')} VND',style: const TextStyle(
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
              ],
            ),

          ],
        )

    ),
  );

}


