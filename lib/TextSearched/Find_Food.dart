import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import '../Dishes_find.dart';
import 'TextSearched.dart';
class Find_Food extends StatefulWidget {
  const Find_Food({Key? key}) : super(key: key);
  @override
  State<Find_Food> createState() => _Find_FoodState();
}

class _Find_FoodState extends State<Find_Food> {
  bool isloading=true;
   DatabaseReference ref=FirebaseDatabase.instance.ref();
  final user=FirebaseAuth.instance.currentUser!;
  List<TextSearched> listTextSearched=[];
  final TextEditingController _textSearched=TextEditingController();
  @override
  void initState() {
    GetTextSearched();
    Future.delayed(const Duration(milliseconds:300),()
    {
      setState(() {
        isloading=false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      backgroundColor: Colors.white,
      title:GetTitlesearch(),
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon:Icon(Icons.arrow_back_rounded,color: Colors.black,)),
      actions: [
        IconButton(onPressed:(){
          AddTextSearched(_textSearched.text);
        }, icon:Icon(Icons.search,color:Colors.black,))
      ],
      elevation: 8,
    ),
    body: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: isloading ? Skeleton(isLoading: true,skeleton: SkeletonListView(),child: Container(),)
      :
      ListView(
        children:listTextSearched.map((e)
        {
          return Item(e);
        }).toList(),
      ),
    ),
    );
  }
   Widget GetTitlesearch()=>Container(
     height: 35,
     decoration: BoxDecoration(
         color: Colors.grey.withOpacity(0.4),
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: Colors.orange,width: 2)
     ),
     child: Container(
       margin:EdgeInsets.only(left:20,right: 20),
       child: TextField(
         controller:_textSearched,
         textAlign: TextAlign.start,
         autofocus: true,
         style: TextStyle(
             fontSize: 14,
             color: Colors.black
         ),
         decoration: InputDecoration(
             border:InputBorder.none
         ),
       ),
     ),

   );
   void AddTextSearched(String _strtextSeached)
   {
     if(_strtextSeached.isEmpty)
     {
       return;
     }
     TextSearched textSearched=TextSearched(Id: DateTime.now().microsecondsSinceEpoch.toString(), uid:user.uid, textSearched: _strtextSeached);
     for(var element in listTextSearched)
     {
       if(element.textSearched==textSearched.textSearched)
       {
         Navigator.push(context, MaterialPageRoute(builder: (context)=>Dishes_find(textSearched: _strtextSeached)));

         return;
       }

     }
     ref.child('TextSearched').child(textSearched.Id).set(textSearched.ToJson()).then((value) {
       Navigator.push(context, MaterialPageRoute(builder: (context)=>Dishes_find(textSearched: _strtextSeached)));
     });

   }
   void GetTextSearched()
   {
     List<TextSearched> list=[];
     List<TextSearched> listnew=[];
     ref.child('TextSearched').onValue.listen((event) {
       if(event.snapshot.value==null)
       {
         return;
       }
       Map<Object?,Object?> map=event.snapshot.value as  Map<Object?,Object?>;
       List<Object?> listdata=map.values.toList();
       List<Object>  nonNullableList=listdata.where((element) => element!=null).toList().cast<Object>();
       for(var element in nonNullableList)
       {
         Map<String,dynamic> mapdata=Map.from(element as dynamic);
         list.add(TextSearched.FromSnapshot(mapdata));
       }
       for(var element in list)
       {
         if(element.uid==user.uid)
         {
           listnew.add(element);
         }
       }
       setState(() {
         listTextSearched=listnew;
       });
     });
   }
   Widget Item(TextSearched e) => GestureDetector(
     onTap: (){
       setState((){
         _textSearched.text=e.textSearched;
       });
     },
     child: Card(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Text(e.textSearched,style: const TextStyle(
             fontSize:16,
             fontWeight: FontWeight.normal,
             color: Colors.black
         ),),
       ),
     ),
   );
}
