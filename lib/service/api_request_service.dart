import 'package:get/get.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:onote/object/entity/note.dart';
import 'package:onote/object/request/delete_note_req.dart';
import 'package:onote/object/request/login_email_pin_req.dart';
import 'package:onote/object/request/login_google_req.dart';
import 'package:onote/object/request/login_apple_req.dart';
import 'package:onote/object/request/login_mobilel_pin_req.dart';
import 'package:onote/object/request/skywork_ask_req.dart';
import 'package:onote/object/request/save_note_req.dart';
import 'package:onote/object/response/login_pin_resp.dart';
import 'package:onote/object/response/note_id_time_resp.dart';
import 'package:onote/object/response/skywork_ask_resp.dart';
import 'package:onote/object/response/save_note_resp.dart';
import 'package:onote/object/result.dart';
import 'package:logger/logger.dart';
import 'package:onote/object/run_execption.dart';
import 'package:onote/object/session_info.dart';
import 'package:onote/service/session_service.dart';
import 'dart:async';
import 'package:onote/util/http_util.dart';
import 'package:onote/util/object_util.dart';
import 'package:onote/widget/easy_toast.dart';

class ApiRequestService {

  static String get onoteApi => "https://api.onote.xyz/api";

  static Logger logger = Logger();

  static Future<NoteIdTimeResp> appNoteCreateInfo() {
    return request("/note/appNoteCreateInfo", {})
      .then((data){
        NoteIdTimeResp? resp = NoteIdTimeResp.fromMap(data);
        if (resp==null) {
          logger.t("50000 : get NoteIdTimeResp failed");
          throw RunException("50000", "get NoteIdTimeResp failed");
        }
        return resp;
      });
  }

  static Future<List<NoteIdTimeResp>> noteIdTimeInfoList() {
    return request("/note/idTimeInfoList", {})
      .then((dyn)=>NoteIdTimeResp.listFromMap(dyn));
  }

  static Future<List<Note>> noteInfoList(List<int> idList) {
    return request("/note/infoList", idList)
      .then((dyn)=>Note.fromMapList(dyn));
  }

  static Future<SaveNoteResp?> createNote(SaveNoteReq saveNoteReq) {
    return request("/note/create", saveNoteReq.toJsonMap())
      .then((dyn)=>SaveNoteResp.fromMap(dyn));
  }

  static Future<SaveNoteResp?> updateNote(SaveNoteReq saveNoteReq) {
    return request("/note/update", saveNoteReq.toJsonMap())
      .then((dyn)=>SaveNoteResp.fromMap(dyn));
  }

  static Future<int?> deleteNote(DeleteNoteReq deleteNoteReq) {
    return request("/note/delete", deleteNoteReq.toJsonMap())
      .then((dyn){
        // log.info("deleteResult $data");
        return (dyn==null || !dyn.toString().isNum) 
          ? 0
          : int.parse(dyn.toString());
      });
  }

  static Future<SkyworkAskResp?> skyworkAsk(SkyworkAskReq skyworkAskReq) {
    SessionInfo? sessionInfo = SessionService.getSession();
    if (sessionInfo==null) {
      SkyworkAskResp resp = SkyworkAskResp("text", "访问 AI Copilot 需要先登录，仅对订阅用户提供此功能", "");
      return Future.value(resp);
    }
    return request("/copilot/ask", skyworkAskReq.toJsonMap())
      .then((dyn)=>SkyworkAskResp.fromMap(dyn));
  }

  static Future<SessionInfo?> appleLogin(String appleToken) async {
    return request("/login", LoginAppleReq(appleToken).toJsonMap())
      .then((dyn)=>(dyn==null) ? null : SessionInfo.fromMap(dyn)!);
  }

  static Future<SessionInfo?> googleLogin(String accessToken) async {
    return request("/login", LoginGoogleReq(accessToken).toJsonMap())
      .then((dyn)=>(dyn==null) ? null : SessionInfo.fromMap(dyn)!);
  }

  static Future<LoginPinResp?> sendPinToMobile(String mobile) {
    return request("/login/getPin", LoginMobilePinReq(mobile, "").toJsonMap(), showError: false)
      .then((dyn)=>(dyn==null) ? null : LoginPinResp.fromMap(dyn)!);
  }

  static Future<SessionInfo?> mobilePinLogin(String mobile, String pin) {
    return request("/login", LoginMobilePinReq(mobile, pin).toJsonMap(), showError: false)
      .then((dyn)=>(dyn==null) ? null : SessionInfo.fromMap(dyn)!);
  }

  static Future<LoginPinResp?> sendPinToEmail(String email) {
    return request("/login/getPin", LoginEmailPinReq(email, "").toJsonMap(), showError: false)
      .then((dyn)=>(dyn==null) ? null : LoginPinResp.fromMap(dyn)!);
  }

  static Future<SessionInfo?> emailPinLogin(String email, String pin) {
    return request("/login", LoginEmailPinReq(email, pin).toJsonMap(), showError: false)
      .then((dyn)=>(dyn==null) ? null : SessionInfo.fromMap(dyn)!);
  }

  static Future<String?> uploadImage(String localFilePath, String finalImageUri) {
    SessionInfo? sessionInfo = SessionService.getSession();
    return HttpUtil.filePut(
      "$onoteApi/storage/image/upload",
      localFilePath,
      headers: {
        "Content-Type": "image/jpeg",
        "Resource-Uri": finalImageUri,
        "User-Token":sessionInfo?.token??""
      }
    )
    .then((d){
      if (d!=null && d["data"]!=null  && d["data"]["uri"]!=null ) {
        return d["data"]["uri"].toString();
      }
      return null;
    });
  }

  static Future<String?> downloadImage(String imageUri) {
    return request("/note/resourceAddress", {"resourceUri":imageUri})
      .then((dyn){
        // logger.t(dyn);
        if (dyn!=null && dyn["resourceUrl"]!=null) {
          String imageUrl = dyn["resourceUrl"].toString();
          String savePath = "${ui.applicationDir}/onote-doc/image/$imageUri";
          return HttpUtil.dataGetDownload(imageUrl, savePath).then((dyn)async {
            return (dyn!=null && dyn.statusCode==200) ? imageUrl : null;
          });
        }
        return null;
      });
  }

  static Future<dynamic> request(String uri, dynamic data, {bool showError = true}) {
    // logger.t(">>> request url : $onoteApi$uri \n>>>request body : $data");
    SessionInfo? sessionInfo = SessionService.getSession();
    return HttpUtil.dataPost(
      "$onoteApi$uri",
      headers: {"Content-Type": "application/json", "User-Token":sessionInfo?.token??""},
      data: data
    )
    .then((d){
      // logger.t(d);
      return requestResult(d, showError: showError);
    });
  }

  static dynamic requestResult(dynamic d, {bool showError = true}) {
    Result? result = Result.fromMap(d);
    if (result==null) {
      logger.t("result is empty , so show (server is busy...) : $result");
      if (showError) {
        EasyToast.showBottomToast("API:server is busy".xtr);
      }
      else {
        throw new RunException("50000", "API:server is busy".xtr);
      }
      return null;
    }
    if (!ObjectUtil.isEmpty(result.code)) {
      logger.t("error code [${result.code}] : $result");
      if (showError) {
        EasyToast.showBottomToast(result.msg);
      }
      else {
        throw new RunException(result.code??"50000", result.msg??"API:server is busy".xtr);
      }
      return null;
    }
    return result.data;
  }
}