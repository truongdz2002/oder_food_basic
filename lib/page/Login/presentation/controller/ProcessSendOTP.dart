// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ProcessSendOTP{
    late  String verificationId;
    late  int ok =0;
    FirebaseAuth auth=FirebaseAuth.instance;
    late BuildContext context;
    ProcessSendOTP(this.context);
    void SetOK(int Ok)
    {
      ok=Ok;
    }
    int GetOK()
    {
      return ok;
    }
    void SetVerificationId(String idVertification)
    {
      verificationId=idVertification;
    }
    String GetVerificationId()
    {
      return this.verificationId;
    }
    void SendOTPToSMS(String phoneNumber)
    async {
     showDialog(context: context, builder:(context)
     {
       return const Center(child:  CircularProgressIndicator(),);

     },);
      await auth.verifyPhoneNumber(
           phoneNumber:phoneNumber ,
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
            SetOK(1);


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
            SetVerificationId(verificationId);

          },
          codeAutoRetrievalTimeout:(String verificationId) {
            // Xử lý sau khi hết thời gian chờ mã OTP
            SetVerificationId(verificationId);
          },
      );
      
    }
    void Check()
    {
      if(GetOK()==1)
      {

      }
    }



}