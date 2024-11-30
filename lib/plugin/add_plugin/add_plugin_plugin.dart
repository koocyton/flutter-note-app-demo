import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/widget/easy_input.dart';
import 'package:onote/widget/easy_ui.dart';

class AddPluginPluginController extends GetxController {
}

class AddPluginPlugin extends GetView<AddPluginPluginController> {

  const AddPluginPlugin({super.key});

  @override
  AddPluginPluginController get controller => Get.put(AddPluginPluginController());

  static void launch(BuildContext context) {
    EasyUI.showBottomModal(
      context: context,
      showDragHandle: true,
      child: const AddPluginPlugin()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:400,
      margin: const EdgeInsets.fromLTRB(0,0,0,0),
      decoration: const BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      padding: const EdgeInsets.all(5),
      child: EasyInput.text(labelText: "AddPlugin")
    );
  }
}