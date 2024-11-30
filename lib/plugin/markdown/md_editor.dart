import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/plugin/markdown/md_editor_controller.dart';

class MdEditor extends GetView<MdEditorController> {

  const MdEditor({super.key});

  @override
  MdEditorController get controller => Get.put(MdEditorController());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}