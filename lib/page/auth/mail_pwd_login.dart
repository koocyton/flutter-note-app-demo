import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/main.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_input.dart';
import 'package:onote/widget/easy_toast.dart';
import 'package:onote/widget/spin_kit.dart';

class MailPwdLoginController extends GetxController {

  RxBool inSignin = RxBool(false);

  RxString errorMessage = RxString("");

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

class MailPwdLogin extends GetView<MailPwdLoginController> {

  const MailPwdLogin({super.key});

  static Logger logger = Logger();

  @override
  MailPwdLoginController get controller => Get.put(MailPwdLoginController());

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
              child: Text("登陆/注册 (新账号自动注册)", style:TextStyle(fontSize: 14, color: Colors.black45)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: EasyInput.input(
                controller: controller.emailController,
                hintText: "email",
                hintTextColor: Colors.black38,
                prefixIcon: const Icon(Icons.email),
                prefixIconColor: Colors.black54
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: EasyInput.input(
                controller: controller.passwordController,
                hintText: "password",
                hintTextColor: Colors.black38,
                prefixIcon: const Icon(Icons.password),
                // isPassword: true,
                prefixIconColor: Colors.black54
              )
            ),
            const SizedBox(height:30),
            sginIn(),
            const SizedBox(height:5),
            cancel()
          ]
        )
      )
    );
  }

  
  Widget sginIn() {
    return Obx(()=>EasyButton.custom(
      borderRadius: 5,
      height: 40,
      fillColor: ui.appNavBgColor,
      borderColor: Colors.black38,
      text: controller.inSignin.value ? null : "Sign In",
      icon: controller.inSignin.value ? SpinKit.threeBounce(size: 30, color:Colors.black54) : null,
      onPressed: () async {
        if (controller.inSignin.value==true) {
          return;
        }
        controller.inSignin.value = true;
        SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
        if (controller.formKey.currentState?.validate() ?? false) {
          // 登录
          try {
            // await auth.signInWithEmailAndPassword(
            //   email: controller.emailController.text,
            //   password: controller.passwordController.text,
            // );
            controller.inSignin.value = false;
            Get.back();
          }
          catch(ignore1) {
            // 注册
            try {
              // await auth.createUserWithEmailAndPassword(
              //   email: controller.emailController.text,
              //   password: controller.passwordController.text,
              // );
              controller.inSignin.value = false;
              Get.back();
            }
            catch(ignore2) {
              controller.inSignin.value = false;
              EasyToast.showBottomToast("请检查您的账号或密码");
              // EasyToast.snackbar("请检查您的账号或密码");
            }
          }
        }
      }
    ));
  }

  Widget cancel() {
    return EasyButton.custom(
      borderRadius: 5,
      height: 40,
      fillColor: Colors.white,
      borderColor: Colors.black38,
      text: "cancel",
      onPressed: () async {
        Get.back();
      }
    );
  }
}