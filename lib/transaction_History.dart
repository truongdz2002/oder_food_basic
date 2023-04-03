

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oder_food/BillOderFood.dart';
import 'package:skeletons/skeletons.dart';
import 'package:intl/intl.dart';

import 'ModuleBillOderFood.dart';

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
          billOderFoodListNew.add(ModuleBillOderFood.fromSnapshot(map));
        }
      for(var element in billOderFoodListNew)
      {
        if(element.moduleCart.uidUser==user.uid)
        {
          billOderFoodList.add(element);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        child:_isLoading
            ?Skeleton(isLoading:true,skeleton:SkeletonListView(), child: Container())
            :ListView(
            children:billOderFoodList.map((e){
                return GestureDetector(
                  onTap:()
                  {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>BillOderFood(moduleBillOderFood: e)));
                  },
                  child: Card(
                   child:Row(
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
                );
            }).toList() ,
        )
      ),
    );
  }

}
