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
  Future<void> loginWithGoogle() async {
    // Hiển thị hộp thoại tiến trình cho đến khi đăng nhập hoàn tất
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Khởi tạo đối tượng GoogleSignIn
    final GoogleSignIn googleUser = GoogleSignIn();

    // Đăng nhập bằng tài khoản Google
    final GoogleSignInAccount? googleAccount = await googleUser.signIn();

    // Lấy thông tin xác thực từ tài khoản Google đã đăng nhập
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleAccount!.authentication;

    // Tạo AuthCredential từ thông tin xác thực Google
    AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    // Đăng nhập vào Firebase với AuthCredential
    UserCredential userCredential =
    await auth.signInWithCredential(authCredential);

    // Lấy thông tin người dùng từ UserCredential
    final User? user = userCredential.user;

    // Kiểm tra nếu người dùng đăng nhập thành công
    if (user != null) {
      // Đóng hộp thoại tiến trình
      Navigator.pop(context);

      // Lưu trạng thái đăng nhập Google thành công
      // Lưu UID của người dùng

      // Điều hướng đến trang chủ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }
  }



}
