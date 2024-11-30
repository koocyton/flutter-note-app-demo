import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_input.dart';
import 'package:onote/widget/easy_ui.dart';

class AiWritePluginController extends GetxController {
}

class AiWritePlugin extends GetView<AiWritePluginController> {

  const AiWritePlugin({super.key});

  @override
  AiWritePluginController get controller => Get.put(AiWritePluginController());

  static void launch(BuildContext context) {
    EasyUI.showBottomModal(
      context: context,
      title: "AIWrite",
      enableDrag: true,
      height: 290,
      shapeBottomborderRadius: 10,
      child: const AiWritePlugin(),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height:10),
        input(),
        SizedBox(height:10),
        confirm(),
        cancel()
      ]
    );
  }

  Widget input() {
    return Container(
      height:100,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: Colors.black12, width: 1)
      ),
      padding: const EdgeInsets.all(10),
      child: Stack(
        fit: StackFit.expand,
        children:[
          EasyInput.text(
            labelText: "ReadHtml:Please enter the url".xtr,
            controller: TextEditingController(text:"https://")
          ),
          Positioned(
            right: -15,
            bottom: -15,
            width: 50,
            height: 50,
            child: EasyButton.custom(
              iconData:Icons.qr_code_scanner,
              onPressed: (){
                Get.toNamed("/plugin/qrScan");
              }
            )
          )
        ]
      )
    );
  }

  Widget confirm() {
    return EasyButton.custom(
      borderRadius: 5,
      height: 40,
      fillColor: ui.appNavBgColor,
      borderColor: Colors.black38,
      text: "从 WEB 导入到我的文档",
      onPressed: (){
      }
    );
  }

  Widget cancel() {
    return EasyButton.custom(
      borderRadius: 5,
      height: 40,
      fillColor: Colors.white,
      borderColor: Colors.black38,
      text: "取消",
      onPressed: (){
        Get.back();
      }
    );
  }
}