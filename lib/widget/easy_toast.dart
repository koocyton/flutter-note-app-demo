import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onote/widget/spin_kit.dart';

class EasyToast {

  static void showCenterToast(String text, {Duration duration = const Duration(seconds: 2)}) {
    EasyLoading.dismiss();
    EasyLoading.showToast(
      text,
      duration: duration,
      toastPosition: EasyLoadingToastPosition.center,
    );
  }

  static void showTopToast(String text, {Duration duration = const Duration(seconds: 2)}) {
    EasyLoading.dismiss();
    EasyLoading.showToast(
      text,
      duration: duration,
      toastPosition: EasyLoadingToastPosition.top,
    );
  }

  static void showBottomToast(String? text, {Duration duration = const Duration(seconds: 2)}) {
    EasyLoading.dismiss();
    EasyLoading.showToast(
      text??"",
      duration: duration,
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  static void show(String? text) {
    EasyLoading.dismiss();
    EasyLoading.show(
      status:text,
      indicator: SpinKit.cubeGrid()
    );
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }

  static void snackbar(String text, {SnackPosition snackPosition = SnackPosition.TOP, Duration duration = const Duration(seconds: 3)}) {
    Get.snackbar("", text,
      backgroundColor: Colors.white54,
      titleText: const SizedBox(height: 0),
      snackPosition: snackPosition,
      duration: duration,
      colorText: Colors.black54,
      borderRadius: 7,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16)
    );
  }
}