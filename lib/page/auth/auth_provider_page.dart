import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:onote/object/session_info.dart';
import 'package:onote/page/auth/license_widget.dart';
import 'package:onote/page/auth/mail_pin_login.dart';
import 'package:onote/page/auth/mobile_pin_login.dart';
import 'package:onote/page/note/note_page.dart';
import 'package:onote/service/auth_provider_service.dart';
import 'package:onote/service/note_service.dart';
import 'package:onote/service/session_service.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:onote/widget/easy_image.dart';
import 'package:onote/widget/easy_popup.dart';
import 'package:onote/widget/easy_ui.dart';

class AuthProviderPageController extends GetxController {
}

class AuthProviderPage extends GetView<AuthProviderPageController> {

  const AuthProviderPage({super.key});

  static Logger logger = Logger();

  static NotePageController get notePageController => Get.find<NotePageController>();

  @override
  AuthProviderPageController get controller => Get.put(AuthProviderPageController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Container(
      padding: const EdgeInsets.fromLTRB(16,0,16,0),
      child: notePageController.sessionInfoRx.value==null 
        ? unsign(context) 
        : insign(context, notePageController.sessionInfoRx.value!)
      )
    );
  }

  Widget insign(BuildContext context, SessionInfo sessionInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        // const SizedBox(height:10),
        // Container(
        //   padding: const EdgeInsets.all(10),
        //   child: const Text(
        //     "不论是绚丽的图像还是深邃的文字，简记让您轻松记录每一个瞬间。\n借助先进的云端同步技术，您的想法在不同设备间自由流动，确保每一次灵感都不会错过。\n强大的加密保护，让您的私密记忆永远安全。",
        //     style:TextStyle(fontSize: 16)
        //   )
        // ),
        const SizedBox(height:10),
        LicenseWidget.onLogout(context),
        const SizedBox(height:10),
        Expanded(
          child: Container(
            color:Colors.white,
            child:EasyImage.image(
              "assets/images/onote-info2.jpg",
              color:Colors.transparent
            )
          )
        ),
        const SizedBox(height:10),
        authButton(
          label: "Auth:logout".xtrParams({
              'email': ui.sessionInfo!.email!
            }),
          iconData: Icons.logout_outlined,
          iconSize:21, 
          onTap: () async{
            Get.back();
            SessionService.removeSession();
            await NoteService.cleanCloudNotes();
            await notePageController.reloadNoteList();
            // await notePageController.noteListRefreshController.callRefresh();
            // signInOutShow();
          }
        ),
        const SizedBox(height:10)
      ]
    );
  }

  Widget unsign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Container(
          padding: const EdgeInsets.fromLTRB(0,5,0,20),
          child: const Row(
            children:[
              Expanded(child: SizedBox()),
              Text("随时随地，捕捉灵感的闪光", style:TextStyle(fontSize: 16)),
              SizedBox(width: 10),
              Icon(Icons.draw_outlined, size: 22, color: Colors.black54),
              Expanded(child: SizedBox()),
            ]
          )
        ),
        authButton(label: "  手机号  ",  iconData: FontAwesomeIcons.mobileAlt,    iconSize:20, fillColor: Colors.white, iconBottom: 0, color:Colors.black, onTap: (){
          Get.back();
          EasyPopup.dialog(
            padding: EdgeInsets.zero,
            barrierDismissible: false,
            // closeWidget: const SizedBox(height: 0, width: 0),
            child: const MobilePinLogin()
          );
        }),
        // authButton(label: "  Apple   ",  iconData: FontAwesomeIcons.apple,  iconSize:21, iconBottom: 3, onTap:(){
        //     Get.back();
        //     AuthProviderService.signInWithApple();
        //   }
        // ),
        // authButton(label: "  Google ",   iconData: FontAwesomeIcons.google, iconSize:15, fillColor: Colors.black87, iconBottom: 1, color:Colors.white, onTap:(){
        //     Get.back();
        //     AuthProviderService.signInWithGoogle();
        //   }
        // ),
        authButton(label: "  Email   ",  iconData: Icons.email_outlined,    iconSize:20, fillColor: ui.systemNavBgColor, iconBottom: 0, color:Colors.black87, onTap: (){
          Get.back();
          EasyPopup.dialog(
            padding: EdgeInsets.zero,
            barrierDismissible: false,
            // closeWidget: const SizedBox(height: 0, width: 0),
            child: const MailPinLogin()
          );
        }),
        Container(
          margin: const EdgeInsets.fromLTRB(8,10,8,10),
          child: LicenseWidget.onLogin(context)
        )
      ]
    );
  }

  Widget authButton({required String label, Widget? icon, double? iconBottom, double iconSize = 20, IconData? iconData, Color fillColor=Colors.white, Color color=Colors.black, Function? onTap}){
    return EasyButton.custom(
      icon: icon,
      iconPadding: EdgeInsets.fromLTRB(0, 0, 0, iconBottom??0),
      iconData: iconData, 
      iconSize: iconSize,
      borderWidth: 1,
      borderColor: fillColor==Colors.white ? const Color.fromARGB(88, 100, 100, 100) : Colors.black12,
      iconColor: color,
      text: label,
      textSize: 15,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 9),
      textColor: color,
      height: 43,
      fillColor: fillColor ,
      borderRadius: 5,
      onPressed: ()async{
        if (onTap!=null) {
          await onTap();
        }
      }
    );
  }

  static signInOutShow() {
    if (notePageController.sessionInfoRx.value!=null) {
      EasyUI.showBottomModal(
        height: 550,
        showCloseButton: false,
        child: const AuthProviderPage()
      );
    }
    else {
      // AuthProviderService.signInWithGoogle();
    }
  }
}