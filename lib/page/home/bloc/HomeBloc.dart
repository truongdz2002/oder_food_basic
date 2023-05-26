
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oder_food/UseDataFromApi/ApiDataDish.dart';
import 'package:oder_food/page/home/bloc/HomeEvent.dart';
import 'package:oder_food/page/home/bloc/HomeState.dart';
class HomeBloc extends Bloc<HomeEvent,HomeState>
{
  HomeBloc():super(HomeInitial()){
      final ApiDataDish  apiDataDish=ApiDataDish();
      on<HomeGetList>((event, emit) async {
          emit(HomeLoading());
          final dishList= await  apiDataDish.getDataDishApi();
          emit(HomeLoaded(dishList));


    });
  }

}