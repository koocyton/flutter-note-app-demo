import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:logger/logger.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_input.dart';
import 'package:onote/widget/easy_ui.dart';

class ReadHtmlPluginController extends GetxController {

  RxBool inRunRx = RxBool(false);
}

class ReadHtmlPlugin extends GetView<ReadHtmlPluginController> {

  const ReadHtmlPlugin({super.key});

  @override
  ReadHtmlPluginController get controller => Get.put(ReadHtmlPluginController());

  static final TextEditingController inputController = TextEditingController(text:"https://");

  static Logger logger = Logger();

  static void launch(BuildContext context) {
    EasyUI.showBottomModal(
      showCloseButton: false,
      context: context,
      title: "ReadHtml:Import from address".xtr,
      titleWeight: FontWeight.bold,
      titleColor: Colors.black54,
      enableDrag: true,
      height: 290,   
      shapeBottomborderRadius: 10,
      resizeToAvoidBottomInset: true,
      child: const ReadHtmlPlugin(),
      margin: const EdgeInsets.fromLTRB(15,15,15,15),
      padding: const EdgeInsets.all(15)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height:10),
        input(),
        const SizedBox(height:10),
        confirm(),
        const SizedBox(height:10),
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
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.black12, width: 1)
      ),
      padding: const EdgeInsets.all(5),
      child: Stack(
        fit: StackFit.expand,
        children:[
          EasyInput.text(
            labelText: "ReadHtml:Please enter the url".xtr,
            controller: inputController,
          ),
          Positioned(
            right: -3,
            bottom: -3,
            child: EasyButton.custom(
              iconData:Icons.qr_code_scanner,
              width: 30,
              height:30,
              onPressed: ()async{
                Get.toNamed(
                  "/plugin/qrScan",
                  arguments: {
                    "tips":"ReadHtml:Only supports QR codes starting with https://".xtr,
                    "startsWith":"https://"
                  }
                );
                // if (result!=null && result["qr_code"]!=null) {
                //   if (result["qr_code"].startsWith("https://")) {
                //     inputController.text = result["qr_code"];
                //   }
                // }
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
      text: "ReadHtml:Import from web".xtr,
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
      text: "ReadHtml:cancel".xtr,
      onPressed: (){
        Get.back();
      }
    );
  }
}