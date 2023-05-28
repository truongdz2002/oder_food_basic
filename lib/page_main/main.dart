
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oder_food/ManagerCache/ManagerCache.dart';
import 'package:oder_food/bloc/Generalterm/GetListDish/GetListDishBloc.dart';
import 'package:oder_food/bloc/ProcessingPageHome/ProcessingAdressLocal/AddressLocal/AddressLocalBloc.dart';
import 'package:oder_food/page/home/reponsitory/ApiDataDish.dart';
import '../bloc/ProcessingPageDetailDish/ProcessingQuantityDishInCart/CounterBloc.dart';
import '../page/home/entity/Dish.dart';
import '../page/Splash_screen/presentation/view/SlashScreen.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(
    MultiBlocProvider(providers:  [
      BlocProvider<GetListDishBloc>(create: (context) => GetListDishBloc()),
      BlocProvider<CounterBloc>(create: (context) => CounterBloc()),
      BlocProvider<AddressLocalBloc>(create: (context) => AddressLocalBloc())
    ], child: const OderFood())

  );
  //cretateMemoryCache();

}
class OderFood extends StatelessWidget {
  const OderFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SlashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> cretateMemoryCache()
async {
  final ApiDataDish apiDataDish=ApiDataDish();
  final ManagerCache  managerCache=ManagerCache();
  List<Dish> listDish= await apiDataDish.getDataDishApi();
  List<Dish> listDishNew=[];
  managerCache.saveDishListToCache(listDish);

}
