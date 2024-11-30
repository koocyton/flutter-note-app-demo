import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/main.dart';
import 'package:onote/object/response/login_pin_resp.dart';
import 'package:onote/object/session_info.dart';
import 'package:onote/page/auth/auth_provider_page.dart';
import 'package:onote/page/note/note_page.dart';
import 'dart:async';
import 'package:onote/service/api_request_service.dart';
import 'package:onote/service/cloud_sync_service.dart';
import 'package:onote/util/cache_util.dart';

class SessionService {

  static Logger logger = Logger();

  static AuthProviderPageController get authPageController => Get.find<AuthProviderPageController>();

  static NotePageController get notePageController => Get.find<NotePageController>();

  static Future<LoginPinResp?> sendPinToEmail(String email) {
    return ApiRequestService.sendPinToEmail(email);
  }

  static Future<SessionInfo?> emailPinLogin(String email, String pin) {
    return ApiRequestService.emailPinLogin(email, pin)
      .then((sessionInfo) async {
        if (sessionInfo==null) {
          return null;
        }
        await createSession(sessionInfo);
        await CloudSyncService.fullSync();
        return sessionInfo;
      });
  }

  static Future<LoginPinResp?> sendPinToMobile(String mobile) {
    return ApiRequestService.sendPinToMobile(mobile);
  }

  static Future<SessionInfo?> mobilePinLogin(String phone, String pin) {
    return ApiRequestService.mobilePinLogin(phone, pin)
      .then((sessionInfo) async {
        if (sessionInfo==null) {
          return null;
        }
        await createSession(sessionInfo);
        await CloudSyncService.fullSync();
        return sessionInfo;
      });
  }

  static void removeSession() {
    CacheUtil.remove("UI.SessionInfo");
    ui.sessionInfo = null;
    notePageController.sessionInfoRx.value = null;
  }

  static Future<SessionInfo> createSession(SessionInfo sessionInfo) {
    return CacheUtil.set("UI.SessionInfo", sessionInfo.toJson())
      .then((file){
        ui.sessionInfo = sessionInfo;
        notePageController.sessionInfoRx.value = sessionInfo;
        return sessionInfo;
      });
  }

  static SessionInfo? getSession() {
    String? json = CacheUtil.get("UI.SessionInfo");
    if (json==null) {
      return null;
    }
    return SessionInfo.fromJson(json);
  }
}