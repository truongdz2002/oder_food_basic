import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oder_food/RequestPermission/RequestPermissionDevice.dart';
import 'package:skeletons/skeletons.dart';

class contact extends StatefulWidget {
  const contact({Key? key}) : super(key: key);

  @override
  State<contact> createState() => _contactState();
}

class _contactState extends State<contact> {
 bool  _isLoading=true;
 int  id=0;
 late final RequestPermissionDevice requestPermissionDevice;
  @override
  void initState() {
    requestPermissionDevice=RequestPermissionDevice();
    requestPermissionDevice.Intialize();
      Future.delayed(const Duration(seconds: 1),()
      {
        setState(() {
      _isLoading=false;
      });
    });
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        _isLoading
            ? Skeleton(
          isLoading: true,
          skeleton: SkeletonListView(),
          child: Container(),
        )
            : Container(
          child: Center(
            child: ElevatedButton(onPressed:()
                async {
                   id=id+1;
                  await  requestPermissionDevice.ShowNotification(id: id, title:'Món ăn oder', body: 'ok');
                }, child:const Text('baaaaa')),
          ),
        ),
      ),

    );
  }
}
