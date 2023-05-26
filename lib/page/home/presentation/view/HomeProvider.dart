import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oder_food/page/home/bloc/HomeBloc.dart';
import 'package:oder_food/page/home/bloc/HomeState.dart';

class HomeProvider extends StatelessWidget {
  final Widget child;
  const HomeProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context)=> HomeBloc(),
      child: BlocListener<HomeBloc,HomeState>(listener:(context, state) {
        if (state is HomeLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Success'),
            ),
          );
        }
      } ,child: child,)) ;
  }
}
