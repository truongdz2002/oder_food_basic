import 'package:bloc/bloc.dart';
import 'package:oder_food/UseDataWithFirebase/FirebaseDataDish.dart';

class BlocWithDish extends Bloc<void, List<dynamic>> {
   FirebaseDataDish firebaseDataDish=FirebaseDataDish() ;

  BlocWithDish(this.firebaseDataDish) : super([]);
  @override
  Stream<List<dynamic>> mapEventToStateListDish(void event) async* {
    try {
      // Gọi UserRepository để lấy danh sách người dùng từ API
      final listDish = await firebaseDataDish.getDishes();

      // Cập nhật danh sách người dùng trong trạng thái Bloc
      yield List.from(listDish);
    } catch (e) {
      // Xử lý lỗi nếu có
      // Ví dụ: throw Exception('Error fetching user data: $e');
    }
  }
}
