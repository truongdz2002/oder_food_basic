import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oder_food/page/home/entity/Dish.dart';
import 'package:oder_food/UseDataWithFirebase/FirebaseDataDish.dart';
import 'package:skeletons/skeletons.dart';
import 'package:intl/intl.dart';


import '../../detailDish/presentation/view/DishDetail.dart';
class Dishes_find extends StatefulWidget {
  final String textSearched;
   Dishes_find({Key? key,required this.textSearched}) : super(key: key);

  @override
  State<Dishes_find> createState() => _Dishes_findState();
}

class _Dishes_findState extends State<Dishes_find>  with TickerProviderStateMixin{
  late TabController _tabController;
  List<Dish> listDishes=[];
  late final FirebaseDataDish firebaseDataDish=FirebaseDataDish();
  final DatabaseReference ref=FirebaseDatabase.instance.ref();
  bool _isLoading=true;
  @override
  void initState() {
    _tabController=TabController(length: 2,vsync: this);
    getDataDishFind();
    Future.delayed( const Duration(seconds:1),(){
      setState(() {
        _isLoading=false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.white,
        title:TiltelSearchAppBar(),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_rounded,color: Colors.black,),),
        bottom:TabBar(
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: [
            Tab(text: "Món ăn đặt nhiều ",),
            Tab(text: "Món ăn giảm giá"),
          ],
        ) ,
      ),
      body:TabBarView(
        controller: _tabController,
        children: [
          Container(
            child:_isLoading
                  ?Skeleton(isLoading: true, skeleton:SkeletonListView(), child:Container())
            :Center(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
                children:listDishes.map((e){
                  return Item(e);
                }).toList() ,
              ),
            ),
          ),
          Container(
            child:_isLoading
                ?Skeleton(isLoading: true, skeleton:SkeletonListView(), child:Container())
                :Center(
              child: Text('aaaaa'),
            ),
          )
        ],
      ),
    );
  }
  Widget TiltelSearchAppBar()=>InkWell(
    onTap: ()
    {
      Navigator.pop(context);
    },
    child:Container(
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.orange,width: 1.4),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.search,color: Colors.grey),
          ),
          Center(
            child: Text(widget.textSearched,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),),
          )
        ],
      ),
    ),
  );
  Future<void> getDataDishFind()
  async {
    List<Dish> list=[];
    ref.child('dishes').onValue.listen((event) {
      log(event.snapshot.value.toString());
      if(event.snapshot.value==null)
      {
        return;
      }
      List<Object?> a=event.snapshot.value as List<Object?>;
      List<Object> nonNullableList = a.where((element) => element != null).toList().cast<Object>() ;
      for (var element in nonNullableList) {
        Map<String, dynamic> map = Map.from(element as dynamic);
        list.add(Dish.fromSnapshot(map));
      }
      for(var element in list)
      {
        if(element.nameDish.toUpperCase().contains(widget.textSearched.toUpperCase()))
        {
          listDishes.add(element);
        }
      }
    });

  }
  Widget Item(Dish e) =>GestureDetector(
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> DishDetail(e)));
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height:100,
              width: 250,
              child: Image.network(e.urlImageDish,fit:BoxFit.fill,),
            ),
            Text(e.nameDish,style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
            ),
            Text('${NumberFormat.decimalPattern().format(e.priceDish).replaceAll(',','.')}  VND',style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2.85
            ),)
            ,
            Text('${NumberFormat.decimalPattern().format(e.priceDish).replaceAll(',','.')}  VND',style: const TextStyle(
                fontSize: 14,
                color: Colors.orange
            ),)
          ],
        ),
      ),
    ),
  );
}



