import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestpermissionAddress
{
  Future<String> requestPermissionLocal() async {
    String address='';
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      address=await getCurrentAddress();
    }
    return address;
  }
  Future<String> getCurrentAddress() async {
    // Lấy vị trí hiện tại của thiết bị
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // Lấy danh sách các địa điểm dựa trên vị trí đã lấy được
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Lấy thông tin chi tiết địa điểm đầu tiên từ danh sách
    Placemark placemark = placemarks[0];

    // Xây dựng chuỗi địa chỉ bằng cách kết hợp các thuộc tính của địa điểm
    String address = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}';


   return address;

  }
}