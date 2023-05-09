import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class informatinAccount extends StatefulWidget {
  const informatinAccount({Key? key}) : super(key: key);

  @override
  State<informatinAccount> createState() => _informatinAccountState();
}

class _informatinAccountState extends State<informatinAccount> {
  final user=FirebaseAuth.instance.currentUser!;
  List<String> listtitle=['Thanh toán','Địa chỉ giao hàng','Chính sách','Trung tâm trợ giúp'];
  final List<Color> iconColors = [
    Colors.red,
    Colors.green,
    Colors.orange,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:NetworkImage(user.photoURL!),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(user.displayName!,style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: double.infinity,
              height:400,
              child: ListView.builder(itemCount:listtitle.length,itemBuilder: (BuildContext context,int index)
              {
                IconData iconData;
                Color iconColor;
                switch (index) {
                  case 0:
                    iconData = Icons.payment;
                    iconColor=iconColors[2];
                    break;
                  case 1:
                    iconData = Icons.location_on;
                    iconColor=iconColors[2];
                    break;
                  case 2:
                    iconData = Icons.feed_rounded;
                    iconColor=iconColors[1];
                    break;
                  default:
                    iconData = Icons.help;
                    iconColor=iconColors[1];
                }
                return Card(
                 child: Row(
                   children: [
                     Icon(iconData,color: iconColor,) ,
                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Text(listtitle[index],
                       style: const TextStyle(
                         fontSize: 16
                       ),),
                     ) ,
                   ],
                 ),
                );
              })
            ),
           
          ],
        ),
      )
    );
  }
 
}


