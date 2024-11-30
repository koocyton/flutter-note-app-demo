import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/main.dart';
import 'package:onote/widget/easy_ui.dart';
import 'package:onote/widget/onote_scaffold.dart';

class ShareController extends GetxController {
}

class SharePage extends GetView<ShareController> {

  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ONoteScaffold(
      appBar : appBar(),
      fixBody   : Container(
        height: ui.windowHeight,
        color : ui.bgColor,
        child : ListView(
          padding: EdgeInsets.fromLTRB(10, ui.headHeight + 10, 10, ui.footHeight + 10),
          physics: ui.physics,
          children: const [
          ]
        )
      )
    );
  }

  ONoteAppBar appBar() {
    return ONoteAppBar(
      backgroundColor: ui.appNavBgColor,
      logo: EasyUI.twoColorText(text1: "S", text2: "hare", color1: ui.fgColor)
    );
  }
}