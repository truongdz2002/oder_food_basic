import 'package:get/get.dart';
import '../responsive/responsive.dart';

/// Lấy size theo kích thước màn hình
///
/// Các giá trị nhỏ hơn 10 pixel nên để nguyên giá trị
extension RatioScreen on num {
  static const WIDTH_DESIGN = 375;
  static const HEIGHT_DESIGN = 812;
  static const WIDTH_DESKTOP = 1366;
  static const HEIGHT_DESKTOP = 768;

  double get w {
    var widthRatio = Get.width / getWidthDesign;
    return widthRatio * this;
  }

  double get h {
    var heightRatio = Get.height / getHeightDesign;
    return heightRatio * this;
  }

  int get getWidthDesign {
    if (Responsive.isDesktop(Get.context!)) {
      return WIDTH_DESKTOP;
    } else {
      return WIDTH_DESIGN;
    }
  }

  int get getHeightDesign {
    if (Responsive.isDesktop(Get.context!)) {
      return HEIGHT_DESKTOP;
    } else {
      return HEIGHT_DESIGN;
    }
  }

// double get sp {
//   var widthRatio = Get.width / 375;
//   var heightRatio = Get.height / 812;
//   var scaleFontSize = min(widthRatio, heightRatio);
//   return this * scaleFontSize;
// }
}
