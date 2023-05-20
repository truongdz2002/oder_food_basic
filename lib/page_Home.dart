import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oder_food/Cart/Cart.dart';
import 'package:oder_food/TextSearched/Find_Food.dart';
import 'package:oder_food/contact.dart';
import 'package:oder_food/informationAccount.dart';
import 'package:oder_food/transaction_History.dart';
import 'SignIn_SignOut_Login/Login.dart';
import 'home/home.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isChangeBackground=true;
  final auth=FirebaseAuth.instance;
  final user=FirebaseAuth.instance.currentUser!;
  final googleSignIn=GoogleSignIn();
  late int indexPage=0;
  int index=0;
  final List<Widget> _page=[
    const home(),
    const Cart(),
    const transaction_History(),
    const contact(),
    const informatinAccount(),

  ];
  @override
  void initState() {
    super.initState();
    //
  }
  Widget buttonTwo(){
    return FloatingActionButton(
      onPressed: (){
      },
      focusElevation: 16.0,
      focusColor: Colors.yellow,
      heroTag: 'information oder',
      elevation: 2.0,
      child: const Icon(Icons.contact_mail_outlined,color: Colors.white,),
    );
  }
  Future<void> signout()
  async {
    showDialog(context: context, builder: (context){
      return const CircularProgressIndicator();
    });
    try {
      await auth.signOut().whenComplete(() {
        Navigator.pop(context);
      });
      await googleSignIn.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));
    } catch (error) {
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
        backgroundColor: isChangeBackground ? Colors.white : Colors.orange,
          elevation: 0,
        title:getAppBarTitle(),
        centerTitle: true,
        actions: [
          isChangeBackground ?
          Stack(
            children: [
              IconButton(onPressed: (){
              }, icon: const Icon(Icons.notifications,color:Colors.orange,size: 25,)),// Icon chính
              Positioned(
                top: 0,
                right:0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('3' , // Số thông báo
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ):
          const Icon(Icons.notifications,color: Colors.orange,)
        ],
      ),
      body: _page[indexPage],
      floatingActionButton:isChangeBackground? AnimatedFloatingActionButton(animatedIconData: AnimatedIcons.view_list,
      fabButtons: [
        processLogout(),
        buttonTwo(),
      ],
       colorStartAnimation: Colors.blueAccent,
       colorEndAnimation: Colors.orange,):null,
      bottomNavigationBar:CurvedNavigationBar(
        onTap:selectIndexPage ,
        backgroundColor:Colors.blueAccent,
        animationDuration: const Duration(milliseconds:400),
        items: const [
           Icon(Icons.home,color: Colors.orange,),
           Icon(Icons.shopping_basket,color: Colors.orange,),
           Icon(Icons.feed,color: Colors.orange,),
           Icon(Icons.account_box_sharp,color: Colors.orange,),
           Icon(Icons.contact_mail_outlined,color: Colors.orange,),
        ],
      ),

    );
  }

  Widget tiltelSearchAppBar()=>InkWell(
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
        children: const [
          Padding(
            padding: EdgeInsets.all(4.0),
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
  Widget setTittleText(String text)=> Text(text,style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18
  ),);
  void changeBackgroundTitleWhite()
  {
    setState(() {
      isChangeBackground=true;
    });
  }
  void changeBackgroundTitleOrange()
  {
    setState(() {
      isChangeBackground=false;
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
          isChangeBackground=true;
        });
      });
      break;
      case 1:
        setState(() {
          setState(() {
            isChangeBackground=false;
          });
        });
        break;
      case 2:
        setState(() {
          setState(() {
            isChangeBackground=false;
          });
        });
        break;
      case 3:
        setState(() {
          setState(() {
            isChangeBackground=false;
          });
        });
        break;
      case 4:
        setState(() {
          setState(() {
            isChangeBackground=false;
          });
        });
        break;
    }
  }
  Widget getAppBarTitle() {
    switch (indexPage) {
      case 0:
        return tiltelSearchAppBar();
      case 1:
        return setTittleText('Giỏ hàng');
      case 2:
        return setTittleText("Hoá đơn");
      case 3:
        return setTittleText("Liên hệ ");
      case 4:
        return setTittleText("");
      default:
        return tiltelSearchAppBar();
    }
  }
  Widget processLogout()=> Container(
    margin: const EdgeInsets.only(left: 40),
    child: FloatingActionButton(onPressed: ()=> showDialog<String>
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
        child: const Text('Bạn chắc chắn muốn đăng xuất'),
      ),
      actions: [
        ElevatedButton(onPressed:(){
          Navigator.of(context).pop();
        },style:ElevatedButton.styleFrom(
            backgroundColor: Colors.orange
        ) , child: const Text('Hủy bỏ'),),
        ElevatedButton(onPressed:()
        {
          Navigator.of(context).pop();
          signout();
        },style:ElevatedButton.styleFrom(
            backgroundColor: Colors.orange
        ), child: const Text('Đồng ý'),
        ),
      ],
    )
    ),
        focusColor: Colors.yellow,
        focusElevation: 16.0,
        heroTag: 'signOut',
        elevation: 2.0,
        child: const Icon(Icons.login_outlined,color: Colors.white,)
    ),
  );
}
