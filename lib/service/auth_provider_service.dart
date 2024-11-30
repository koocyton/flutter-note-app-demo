import 'package:logger/logger.dart';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:get/get.dart';
// import 'package:onote/main.dart';
// import 'package:onote/object/session_info.dart';
// import 'package:onote/service/api_request_service.dart';
// import 'package:onote/service/cloud_sync_service.dart';
// import 'package:onote/service/session_service.dart';
// import 'package:onote/widget/easy_popup.dart';
// import 'package:onote/widget/easy_toast.dart';
// import 'package:onote/widget/easy_ui.dart';
// import 'package:onote/widget/spin_kit.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class AuthProviderService {

  // static final WebViewController appleWebViewController = WebViewController()
  //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //       ..setBackgroundColor(const Color(0x00000000))
  //       ..loadRequest(Uri.parse('https://appleid.apple.com/sign-in'));

  // static final GoogleSignIn googleSignIn = GoogleSignIn(
  //     // Optional clientId
  //     scopes: <String>[
  //       "https://www.googleapis.com/auth/userinfo.email",
  //       "https://www.googleapis.com/auth/userinfo.profile",
  //       "openid"
  //       // 'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );

  static Logger logger = Logger();

  // static Future<SessionInfo?> signInWithGoogle() async {
  //   await googleSignIn.signOut();
  //   // google user
  //   GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   if (googleUser==null) {
  //     EasyToast.dismiss();
  //     return Future.value(null);
  //   }
  //   EasyPopup.dialog(
  //     backgroundColor: Colors.transparent,
  //     closeWidget: const SizedBox(height: 0, width: 0),
  //     child: Container(
  //       alignment: Alignment.center,
  //       child: SpinKit.threeBounce(color: Colors.white)
  //     )
  //   );
  //   // EasyToast.show("正在登录");
  //   // google auth
  //   final googleAuth = await googleUser.authentication;
  //   if (googleAuth.accessToken==null) {
  //     Get.back();
  //     EasyToast.showBottomToast("登录失败");
  //     return Future.value(null);
  //   }
  //   // logger.t("googleAuth.accessToken ${googleAuth.accessToken}");
  //   // session
  //   SessionInfo? sessionInfo = await ApiRequestService.googleLogin(googleAuth.accessToken!);
  //   if (sessionInfo==null) {
  //     Get.back();
  //     EasyToast.showBottomToast("登录失败");
  //     return Future.value(null);
  //   }
  //   sessionInfo.authProvider = "Google";
  //   await SessionService.createSession(sessionInfo);
  //   await CloudSyncService.fullSync();
  //   Get.back();
  //   return sessionInfo;
  // }

  // static Future<void> signInWithApple() async {
  //   EasyUI.showBottomModal(
  //     height: ui.windowHeight * 0.8,
  //     child: WebViewWidget(controller: appleWebViewController)
  //   );
  // }
}