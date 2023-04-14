import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oder_food/Cart/Cart.dart';
import 'package:oder_food/RequestPermission/RequestPermissionDevice.dart';
import 'package:oder_food/TextSearched/Find_Food.dart';
import 'package:oder_food/contact.dart';
import 'package:oder_food/feedBack.dart';
import 'package:oder_food/transaction_History.dart';

import 'SignIn_SignOut_Login/Login.dart';
import 'Dish/Dish.dart';
import 'home/home.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool ischangebackground=true;
  final auth=FirebaseAuth.instance;
  final user=FirebaseAuth.instance.currentUser!;
  final googleSignIn=GoogleSignIn();
  late int indexPage=0;
  final List<Widget> _page=[
    const home(),
    const Cart(),
    const feedBack(),
    const contact(),
    const transaction_History()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Future<void> Sigout()
    async {
      try {
        await auth.signOut();
        await googleSignIn.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
      } catch (error) {
        print("Đã xảy ra lỗi: $error");
      }
    }
    return  Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
        backgroundColor: ischangebackground ? Colors.white : Colors.orange,
          elevation: 0,
        title:getAppBarTitle(),
        centerTitle: true,
      ),
      body: _page[indexPage],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.orange,
        type: BottomNavigationBarType.shifting,
        currentIndex: indexPage,
        onTap:selectIndexPage ,
        backgroundColor:Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
              label:"Trang chủ",
             ),
          BottomNavigationBarItem(icon:Icon(Icons.shopping_cart),label:"Giỏ hàng "),
          BottomNavigationBarItem(icon:Icon(Icons.feed),label:"Phản hồi "),
          BottomNavigationBarItem(icon:Icon(Icons.account_box_sharp),label:"Liên hệ "),
          BottomNavigationBarItem(icon:Icon(Icons.history),label:"Lịch sử giao dịch")
        ],
      ),

    );
  }
  Widget TiltelSearchAppBar()=>InkWell(
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Find_Food()));
    },
    child: Container(
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
            child: Text("Tìm kiếm món ăn ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),),
          )
        ],
      ),
    ),
  );
  Widget SetTittleText(String text)=> Text(text,style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18
  ),);
  void ChangeBackgroundTitleWhite()
  {
    setState(() {
      ischangebackground=true;
    });
  }
  void ChangeBackgroundTitleOrange()
  {
    setState(() {
      ischangebackground=false;
    });
  }
  void selectIndexPage(int index)
  {
    setState(() {
      indexPage=index;
    });
    switch(index)
    {
      case 0: setState(() {
        setState(() {
          ischangebackground=true;
        });
      });
      break;
      case 1:
        setState(() {
          setState(() {
            ischangebackground=false;
          });
        });
        break;
      case 2:
        setState(() {
          setState(() {
            ischangebackground=false;
          });
        });
        break;
      case 3:
        setState(() {
          setState(() {
            ischangebackground=false;
          });
        });
        break;
      case 4:
        setState(() {
          setState(() {
            ischangebackground=false;
          });
        });
        break;
    }
  }
  Widget getAppBarTitle() {
    switch (indexPage) {
      case 0:
        return TiltelSearchAppBar();
      case 1:
        return SetTittleText('Giỏ hàng');
      case 2:
        return SetTittleText("Phản hồi");
      case 3:
        return SetTittleText("Phản hồi");
      case 4:
        return SetTittleText("Lịch sử giao dịch");
      default:
        return TiltelSearchAppBar();
    }
  }
}
