import 'package:equatable/equatable.dart';
import 'package:oder_food/page/home/entity/Dish.dart';

abstract class HomeState extends Equatable{
  @override
  List<Object> get props=>[];
}
class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Dish> dish;
   HomeLoaded(this.dish);
}