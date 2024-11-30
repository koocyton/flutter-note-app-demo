import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:onote/object/run_execption.dart';
import 'package:onote/service/session_service.dart';
// import 'package:onote/util/object_util.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_input.dart';
// import 'package:pinput/pinput.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MobilePinLoginController extends GetxController {

  RxString errorMessage = RxString("");
  RxBool showError = RxBool(false);

  TextEditingController mobileController = TextEditingController(text:"");
  TextEditingController pinController = TextEditingController(text:"");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isPinSendComplete = RxBool(false);
}

class MobilePinLogin extends GetView<MobilePinLoginController> {

  const MobilePinLogin({super.key});

  static Logger logger = Logger();

  @override
  MobilePinLoginController get controller => Get.put(MobilePinLoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: controller.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
              child: Text("用户登陆", style:TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 9, 15, 0),
              child: Text("登录 / 新账号自动注册", style:TextStyle(fontSize: 14, color: Colors.black45)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
              child: Obx(() => EasyInput.input(
                keyboardType: TextInputType.number,
                readOnly: controller.isPinSendComplete.value,
                controller: controller.mobileController,
                maxLength: 11,
                hintText: "请输入手机号(中国)".xtr,
                hintTextColor: Colors.blueGrey.shade200,
                prefixIcon: const Icon(FontAwesomeIcons .mobileAlt),
                prefixIconColor: Colors.blueGrey.shade800,
              ))
            ),
            const SizedBox(height:15),
            sendPin(),
            verifyPin(),
            const SizedBox(height:25),
            Obx(() => AnimatedContainer(
              color:controller.showError.value ? ui.maskSystemNavBgColor : Colors.white,
              width: ui.windowWidth,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 200),
              height: controller.showError.value ? 50 : 0,
              child: Text(controller.errorMessage.value, style: const TextStyle(color:Colors.white)),
            ))
          ]
        )
      )
    );
  }

  Widget sendPin() {
    return Column(
      children:[
        Row(
          children:[
            const Expanded(child:SizedBox()),
            Container(
              alignment: Alignment.centerRight,
              child: Obx(() => EasyButton.custom(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                text: controller.isPinSendComplete.value ? "再次获取验证码" : "获取验证码",
                textDecoration: TextDecoration.underline,
                textColor: Colors.black,
                height: 40,
                borderRadius: 5,
                onPressed: (){
                  String mobile = controller.mobileController.value.text;
                  if (!mobile.isPhoneNumber || !mobile.startsWith("1") || mobile.length!=11) {
                    showError("请输入正确的手机号");
                    return;
                  }
                  SessionService.sendPinToMobile(mobile)
                    .onError((error, stackTrace){
                      showExceptionError(error);
                      return null;
                    })
                    .then((loginPinResp){
                      if (loginPinResp!=null) {
                        controller.isPinSendComplete.value = true;
                      }
                    });
                }
              ))
            )
          ]
        )
      ]
    );
  }

  Widget verifyPin() {
    return const SizedBox();
    // return Obx(()=>!controller.isPinSendComplete.value 
    //   ? SizedBox()
    //   : Column(
    //     children:[
    //       Container(
    //         padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
    //         child:Pinput(
    //           length: 5,
    //           controller: controller.pinController,
    //           defaultPinTheme: PinTheme(
    //             width: 56,
    //             height: 56,
    //             margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    //             textStyle: TextStyle(fontSize: 20, color: Colors.blueGrey.shade800, fontWeight: FontWeight.w600),
    //             decoration: BoxDecoration(
    //               border: Border.all(color: Colors.black12),
    //               borderRadius: BorderRadius.circular(5),
    //             ),
    //           ),
    //         )
    //       ),
    //       Container(
    //         margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
    //         child: Text("请注意手机上收到的验证码", style:const TextStyle(color:Colors.black87)),
    //       ),
    //       EasyButton.custom(
    //         text: "登录",
    //         margin: const EdgeInsets.fromLTRB(25, 30, 25, 0),
    //         textColor: Colors.black,
    //         fillColor: ui.appNavBgColor,
    //         height: 40,
    //         borderRadius: 5,
    //         onPressed: (){
    //           try {
    //             SessionService.mobilePinLogin(
    //               controller.mobileController.value.text, 
    //               controller.pinController.value.text
    //             )
    //             .onError((error, stackTrace){
    //               showExceptionError(error);
    //               return null;
    //             })
    //             .then((sessionInfo){
    //               if (!ObjectUtil.isEmpty(sessionInfo) && !ObjectUtil.isEmpty(sessionInfo!.token)) {
    //                 Get.back();
    //               }
    //             });
    //           }
    //           catch(e) {
    //             logger.t(e);
    //           }
    //         }
    //       )
    //     ]
    //   )
    // );
  }

  void showExceptionError(Object? error) {
    // run exception 有 code 和 message
    RunException? runError = RunException.cast(error);
    if (runError!=null) {
      showError(runError.message);
      // 40000 表示给出一个提示，并按正常响应处理
      // 一般用于测试。
      if (runError.code=="40000") {
        controller.isPinSendComplete.value = true;
      }
    }
    else {
      // 其他类型错误
      showError(error.toString());
    }
  }

  void showError(String message) {
    if (message.startsWith("Exception: ")) {
      message = message.substring(11);
    }
    controller.errorMessage.value = message;
    controller.showError.value = true;
    Future.delayed(const Duration(milliseconds: 4000), () {
      controller.showError.value = false;
      controller.errorMessage.value = "";
    });
  }
}