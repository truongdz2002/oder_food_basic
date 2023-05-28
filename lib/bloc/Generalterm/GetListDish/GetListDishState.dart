import 'package:equatable/equatable.dart';
import 'package:oder_food/page/home/entity/Dish.dart';

abstract class GetListDishState extends Equatable{
  const GetListDishState();
  @override
  List<Object> get props => [];
}
class GetListDishInit extends GetListDishState{}

class GetListDishLoading extends GetListDishState{}

class GetListDishListFood extends GetListDishState{
  final List<Dish> foodList;
  const GetListDishListFood(this.foodList);
}

