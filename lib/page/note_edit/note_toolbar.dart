import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/page/note_edit/note_edit_page.dart';
import 'package:onote/page/note_edit/note_toolbar_utils.dart';
import 'package:logger/logger.dart';

class NoteToolbar extends GetView<NoteEditController> {

  const NoteToolbar({super.key});

  static Logger logger = Logger();

  @override
  NoteEditController get controller => Get.find<NoteEditController>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>IndexedStack(
      alignment: Alignment.center,
      index: controller.currentMenuIndexRx.value,
      children: [
        const SizedBox(),
        NoteToolbarUtils(),
      ]
    ));
  }
}
