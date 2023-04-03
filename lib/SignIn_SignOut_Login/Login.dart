import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oder_food/SignIn_SignOut_Login/ConfirmOTP.dart';
import 'package:oder_food/SignIn_SignOut_Login/ProcessLoginGoogle.dart';
import 'package:oder_food/SignIn_SignOut_Login/ProcessSendOTP.dart';
import 'package:oder_food/page_Home.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String veryfi='';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String strPhoneNumber="";
  late String strpassWord="";
  bool isPasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    ProcessSendOTP processSendOTP = ProcessSendOTP(context);
    ProcessLoginGoogle processLoginGoogle= ProcessLoginGoogle(context);
    TextEditingController        edtPhoneNumber = TextEditingController();
    FirebaseAuth auth =FirebaseAuth.instance;
    Future<void> LoginPhoneNumber(String phoneNumber) async
    {
      if(phoneNumber.startsWith("0"))
        {
          String s="+84${phoneNumber.substring(1)}";
          showDialog(context: context,builder: (context)
          {
            return const Center(child: CircularProgressIndicator(),);
          });
            await auth.verifyPhoneNumber(
              phoneNumber:s ,
              verificationCompleted:(PhoneAuthCredential credential) async {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg:'Gửi OTP thành công',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black
                );
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ConfirmOTP()));


              } ,
              verificationFailed:(FirebaseAuthException e) async
              {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg:'Lỗi sever ',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black
                );
              },
              codeSent: (String verificationId, int? resendToken) {
                // Lưu verificationId để sử dụng khi xác nhận mã OTP
                   Login.veryfi=verificationId;


              },
              codeAutoRetrievalTimeout:(String verificationId) {
                // Xử lý sau khi hết thời gian chờ mã OTP

              },
            );

        }

    }

    void LoginWithGoogle()
    async {
      processLoginGoogle.LoginWithGoogle();

    }
    void Next()
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
    }

    /* showDialog(context: context, builder: (context)
     {
       return const Center(
         child: CircularProgressIndicator(),
       );
     });*/


    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height:160,
                margin: const EdgeInsets.all(100),
                child: const FittedBox(
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/logo_oder_food.png'
                    ),
                    radius: 120,
                   ),
                ),

              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Center(
                    child: TextField(
                      controller: edtPhoneNumber,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_android),
                        border: InputBorder.none,
                        hintText: 'Số điện thoại '
                      ),
                    ),
                  ),
                ),
              ),
               const SizedBox(
                height: 100,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed:()=>LoginPhoneNumber(edtPhoneNumber.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                      child:  const Text('Đăng nhập'
                      ,style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                      ),)
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Container(
                       height: 50,
                       width: 300,
                       decoration: const BoxDecoration(
                         image: DecorationImage(
                           image: AssetImage('assets/backgroundFacebookLogin.jpg'),
                           fit: BoxFit.cover,
                         ),
                       ),
                       child: ElevatedButton(onPressed: Next, child: null
                       ,style: ElevatedButton.styleFrom(
                           primary: Colors.transparent,
                           elevation: 5
                         ),),
                     ),
                    const SizedBox(
                      height:20,
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/backgroundLoginGoogle.jpg'),
                          fit: BoxFit.cover,
                        ),

                      ),
                      child: ElevatedButton(onPressed:LoginWithGoogle, child: null
                        ,style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,


                        ),),
                    )


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible= !isPasswordVisible;
    });
  }

}

