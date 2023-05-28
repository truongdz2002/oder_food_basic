
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oder_food/page/home/entity/Dish.dart';
import 'package:oder_food/page/home/reponsitory/ApiDataDish.dart';

import 'GetListDataEvent.dart';
import 'GetListDishState.dart';

class GetListDishBloc extends Bloc<GetlistDataEvent,GetListDishState>
{
  GetListDishBloc():super(GetListDishInit()){
    final  ApiDataDish apiDataDish =ApiDataDish();
    on<GetDishList>((event, emit)
    async {
      emit(GetListDishLoading());
      List<Dish> foodList=await apiDataDish.getDataDishApi();
      emit(GetListDishListFood(foodList));
    }
       );
  }
}