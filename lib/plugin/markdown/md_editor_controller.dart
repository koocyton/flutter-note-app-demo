import 'package:get/get.dart';

class MdEditorController extends GetxController {

  // 传入的参数
  // Get.toNamed("${route}", arguments: {"arg1": value1});
  dynamic pageArgs = Get.arguments;

  @override
  void onInit() {
    if (pageArgs!=null && pageArgs['note']!=null) {
    }
    super.onInit();
  }
}
