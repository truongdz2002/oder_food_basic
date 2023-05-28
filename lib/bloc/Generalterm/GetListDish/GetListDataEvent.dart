
abstract class GetlistDataEvent {
  const GetlistDataEvent();
  List<Object> get props => [];
}

class GetDishList extends GetlistDataEvent{}
class GetCartListOfUser extends GetlistDataEvent{}