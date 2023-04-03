import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../page_Home.dart';

class ProcessLoginGoogle
{
  FirebaseAuth auth=FirebaseAuth.instance;
  late String googleLogin;
  late String Uid;
  late BuildContext context;
  ProcessLoginGoogle(this.context);
  void SetGoogleLogin(String googlelogin)
  {
    googleLogin=googlelogin;
  }
  void SetUID(String Uid)
  {
    Uid=Uid;
  }

  String GetGoogleLogin()
  {
    return googleLogin;
  }
  Future<void> LoginWithGoogle()
  async {
    showDialog(context: context, builder:(context)
    {
      return const Center(child:  CircularProgressIndicator(),);

    },);
    final GoogleSignIn googleUser=GoogleSignIn();
          final GoogleSignInAccount? googleAccount=await googleUser.signIn();
          final GoogleSignInAuthentication googleSignInAuthentication=await googleAccount!.authentication;
          AuthCredential authCredential=GoogleAuthProvider.credential(
            idToken:googleSignInAuthentication.idToken ,
            accessToken:googleSignInAuthentication.accessToken
          );
          UserCredential userCredential=await auth.signInWithCredential(authCredential);
          final User? user=userCredential.user;
          if(user !=null)
            {
              Navigator.pop(context);
              SetGoogleLogin("Success");
              SetUID(user.uid);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()
              ));
            }

        }


  }
