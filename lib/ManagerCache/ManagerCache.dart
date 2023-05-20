import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../Dish/Dish.dart';
class ManagerCache {
  Future<void> saveDishListToCache(List<Dish> dishList) async {
    final cacheManager = DefaultCacheManager();

    // Chuyển đổi danh sách món ăn thành chuỗi JSON
    String jsonData = jsonEncode(dishList);

    // Lưu chuỗi JSON vào cache với một tên tệp tin cụ thể
    Uint8List data = Uint8List.fromList(utf8.encode(jsonData));
    final file = await cacheManager.putFile('dishList.json', data);

    // In ra đường dẫn tệp tin đã lưu
    log('Đường dẫn tệp tin cache: ${file.path}');
  }
  Future<List<Dish>> getDishListFromCache() async {
    final cacheManager = DefaultCacheManager();
    // Đường dẫn tệp tin cache
    final cacheDir = await getTemporaryDirectory();
    final filePath = '${cacheDir.path}/dishList.json';
// Kiểm tra xem tệp tin cache có tồn tại không
    FileInfo? fileInfo = await cacheManager.getFileFromCache(filePath);
    bool isCached = fileInfo != null;
    if (isCached) {
      // Đọc dữ liệu từ tệp tin cache
      Uint8List fileData = await fileInfo!.file.readAsBytes();
      String jsonData = utf8.decode(fileData);

      // Chuyển đổi chuỗi JSON thành danh sách món ăn
      List<dynamic> jsonList = jsonDecode(jsonData);
      List<Dish> dishList = jsonList.map((json) => Dish.fromSnapshotApi(json)).toList();

      return dishList;
    }
    return [];

  }



}
