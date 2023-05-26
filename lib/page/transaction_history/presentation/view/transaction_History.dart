

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oder_food/page/page_bill_oder/presentation/view/BillOderFood.dart';
import 'package:skeletons/skeletons.dart';
import 'package:intl/intl.dart';

import '../../entity/ModuleBillOderFood.dart';

class transaction_History extends StatefulWidget {
  const transaction_History({Key? key}) : super(key: key);

  @override
  State<transaction_History> createState() => _transaction_HistoryState();
}

class _transaction_HistoryState extends State<transaction_History> {
  bool _isLoading=true;
  DatabaseReference ref=FirebaseDatabase.instance.ref();
  final user=FirebaseAuth.instance.currentUser!;
  late BillOderFood billOderFood;
  List<ModuleBillOderFood> billOderFoodList=[];
  @override
  void initState() {
    GetBillOderCreated();
    Future.delayed(const Duration(seconds: 1),()
    {
      setState(() {
        _isLoading=false;
      });

    });
    super.initState();
  }
  void GetBillOderCreated()
  {
    List<ModuleBillOderFood> billOderFoodListall=[];
    List<ModuleBillOderFood> billOderFoodListNew=[];
    ref.child('BillOderCreated').onValue.listen((event) {
      if(event.snapshot.value==null)
        {
          return;
        }
      Map<Object?,Object?> mapData=event.snapshot.value as Map<Object?,Object?>;
      List<Object?> listdata=mapData.values.toList();
      List<Object> list=listdata.where((element) => element!=null).toList().cast<Object>();
      for(var element in list)
        {
          Map<String,dynamic> map=Map.from(element as dynamic) ;
          billOderFoodListall.add(ModuleBillOderFood.fromSnapshot(map));
        }
      for(var element in billOderFoodListall)
      {
        if(element.moduleCart.uidUser==user.uid)
        {
          billOderFoodListNew.add(element);
        }
      }
      setState(() {
        billOderFoodList=billOderFoodListNew;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: billOderFoodList.isEmpty ?
              Center(
                child: SizedBox(
                    child: Column(
                      children: const [
                        SizedBox(
                          height:150,
                        ),
                        Icon(Icons.feed,size: 200,color: Colors.grey,),
                        Text('Bạn chưa có hóa đơn nào',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),)
                      ],
                    ),
                ),
              )
      :Container(
        child:_isLoading
            ?Skeleton(isLoading:true,skeleton:SkeletonListView(), child: Container())
            :ListView(
            children:billOderFoodList.map((e){
                return GestureDetector(
                  onTap:()
                  {
                    ref.child('BillOderCreated').child(e.id).update({'View':true}).whenComplete(() {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>BillOderFood(moduleBillOderFood: e)));
                    });
                  },
                  child: Card(
                   child:Container(
                     decoration: BoxDecoration(
                         color:e.view ? const Color(0x88888888) :Colors.white,
                         borderRadius: BorderRadius.circular(5)
                     ),
                     child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(15),
                                child: SizedBox(
                                  height: 60,
                                  child: FittedBox(
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/logo_oder_food.png'
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(e.dateOder,style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Colors.black
                                      ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: Text('Thực đơn:${e.moduleCart.dish.nameDish}',style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),),
                                     ),
                                  ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text('Giá :${NumberFormat.decimalPattern().format(e.moduleCart.dish.priceDish).replaceAll(',','.')} VND',style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.orange
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                   ),
                  ),
                );
            }).toList() ,
        )
      ),
    );
  }

}
