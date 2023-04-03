import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oder_food/SignIn_SignOut_Login/Login.dart';
import 'package:oder_food/SignIn_SignOut_Login/ProcessSendOTP.dart';
import 'package:pinput/pinput.dart';
import '../page_Home.dart';
class ConfirmOTP extends StatefulWidget {
  const ConfirmOTP({Key? key}) : super(key: key);

  @override
  State<ConfirmOTP> createState() => _ConfirmOTPState();
}

class _ConfirmOTPState extends State<ConfirmOTP> {
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    ProcessSendOTP processSendOTP=ProcessSendOTP(context);
    String codeOTP='';
    Future<void> ConfirmToLogin()
    async {
      showDialog(context: context, builder: (context)
      {
        return const  Center(child: const CircularProgressIndicator());
      });

      try{
        final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: Login.veryfi,
          smsCode: codeOTP,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Home()));
      }
      catch(e)
      {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Mã OTP quá thời gian hoặc sai",
            timeInSecForIosWeb: 1,
            fontSize: 14,
            textColor: Colors.black,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.grey);
      }
    }
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child:SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 160,
                  margin: const EdgeInsets.all(80),
                  child: const FittedBox(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/logo_oder_food.png'),
                      radius: 120,
                    ),

                  ),

                ),
                const Text("Nhập OTP để xác nhận "),
                const SizedBox(
                  height: 30,
                ),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {codeOTP=value;},
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(onPressed: (){},
                    child:const Text("Gửi lại mã ",
                      style: TextStyle(
                      ),
                    )
                ),
                const  Text('00:00'),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: ConfirmToLogin,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        child:const Text("Xác nhận"
                          ,style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),)
                    )
                  ],
                )

              ],
            ),
          )
      ),
    );
  }
}



