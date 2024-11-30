import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:onote/dao/note_dao.dart';
import 'package:onote/main.dart';
import 'package:onote/object/entity/note.dart';
import 'package:onote/object/response/save_note_resp.dart';
import 'package:onote/page/note/note_page.dart';
import 'package:onote/service/api_request_service.dart';
import 'package:onote/service/cloud_sync_service.dart';
import 'package:onote/util/encrypt_util.dart';
import 'package:logger/logger.dart';

class NoteService {

  static Logger logger = Logger();

  static final notePageController = Get.find<NotePageController>();

  static final RegExp localImageRegExp = RegExp("{\"image\":\"([^\\.]+\\.(jpg|png|gif))\"}");
  static final RegExp uploadedImageRegExp = RegExp("{\"image\":\"(\\d{19,22}/\\d{19,22}/[^\\.]{32}\\.(jpg|png|gif)\")}");
  static final RegExp uploadedImagePathRegExp = RegExp("\\d{19,22}/\\d{19,22}/[^\\.]{32}\\.(jpg|png|gif)");

  static Future<List<Note>> getNoteList() {
    return NoteDao.getList();
  }

  // 保存 content ，并尝试同步到云端
  static Future<Note?> createNote(String content) {
    // 保存 content
    return NoteDao.createNote(content)
      .then((createdNote){
        // debugPrint("create note : ${createdNote}");
        // 创建成功
        // if (createdNote!=null && createdNote.creator!="installer") {
        //   // debugPrint("create note id : ${createdNote.id}");
        //   CloudSyncService.createNote(createdNote).then((createResp) async{
        //     if (createResp!=null) {
        //       await NoteDao.setNoteStatusIsCloud(createdNote.id, createResp.id);
        //       await uploadImageReviseContent(createResp, createdNote);
        //     }
        //     notePageController.reloadNoteList();
        //   });
        //   return createdNote;
        // }
        notePageController.reloadNoteList();
        return createdNote;
      });
  }

  // 更新 content ，并尝试更新到云端
  static Future<Note?> updateNote(int id, String content) {
    // logger.t(content);
    return NoteDao.updateNote(id, content)
      .then((updatedNote) async {
        // logger.t(updatedNote);
        // 保存成功
        // if (updatedNote!=null && updatedNote.creator!="installer") {
        //   CloudSyncService.updateNote(updatedNote).then((updateResp)async{
        //     if (updateResp!=null) {
        //       await notePageController.reloadNoteList();
        //       await uploadImageReviseContent(updateResp, updatedNote);
        //     }
        //   });
        //   return updatedNote;
        // }
        notePageController.reloadNoteList();
        return updatedNote;
      });
  }

  // 上传图片，修正 content
  static Future<SaveNoteResp> uploadImageReviseContent(SaveNoteResp saveResp, Note localNote) async {
    // 2. 将本地图片上传
    String? newContentText = await _uploadContentImages(saveResp.userId!, saveResp.id!, localNote.content!);
    // 3. 如果 content 发生改变 (有图片上传的话)
    if (newContentText!=localNote.content!) {
      // 3.1 更新本地 content
      // 3.2 将变更的 content 更新到云端
      await updateContentLast(saveResp.id!, newContentText!);
    }
    return saveResp;
  }

  // 更新 content ，并尝试更新到云端
  static Future<Note?> updateContentLast(int id, String content) {
    return NoteDao.updateNote(id, content)
      .then((updatedNote) async {
        if (updatedNote!=null) {
          await CloudSyncService.updateNote(updatedNote);
        }
        return updatedNote;
      });
  }

  // 分析 content ，并将图片上传
  static Future<String?> _uploadContentImages(int userId, int id, String content) async {
    // 解析 content
    dynamic dynList = jsonDecode(content);
    for(Map<String, dynamic> dyn in dynList) {
      // 读取 insert.custom.image
      if (dyn["insert"].runtimeType.toString().contains("Map") && dyn["insert"]["custom"]!=null) {
        String insertCustomJson = dyn["insert"]["custom"].toString();
        // 如果是自定义图片路径
        if (insertCustomJson.startsWith("{\"image\":\"")) {
          // 如果图片路径是 /userId/id/md5.jpg
          // 说明已经上传过了
          if (uploadedImageRegExp.hasMatch(insertCustomJson)) {
            // 如果本地有图片
          }
          // 准备上传没有同步过的图片
          else {
            // 当前图片位置位置
            RegExpMatch? regMatch = localImageRegExp.firstMatch(insertCustomJson);
            if (regMatch!=null) {
              String localImageUri = regMatch.group(1).toString();
              // logger.t(localImageUri);
              // 新的图片路径
              String finalImageUri= "$userId/$id/${EncryptUtil.md5(insertCustomJson)}.jpg";
              // logger.t(finalImageUri);
              
              // 上传图片
              String oldLocalImagePath = "${ui.applicationDir}/onote-doc/image/$localImageUri";
              String? uploadImageUri = await ApiRequestService.uploadImage(oldLocalImagePath, finalImageUri);
              // logger.i("$uploadImage != $finalImageUri , upload failed");
              if (uploadImageUri==null || uploadImageUri.length<70 || uploadImageUri!=finalImageUri) {
                // logger.t("$uploadImage != $finalImageUri , upload failed");
                continue;
                // throw RunException("50000", "upload file failed");
              }

              // 图片拷贝到新路径上来
              String newLocalImagePath = "${ui.applicationDir}/onote-doc/image/$finalImageUri";
              // 创建新文件的目录
              File newLocalImageFile = File(newLocalImagePath);
              if (!newLocalImageFile.parent.existsSync()) {
                newLocalImageFile.parent.createSync(recursive: true);
              }

              // 旧文件
              File oldLocalImageFile = File(oldLocalImagePath);
              // 将文件拷贝过去
              oldLocalImageFile.copy(newLocalImagePath);
              // String newImagePath = "${ui.applicationDir}/onote-doc/image/$finalImageUri";
              // logger.t("$localImagePath \n $newImagePath");
              dyn["insert"]["custom"] = "{\"image\":\"$finalImageUri\"}";
            }
          }
        }
      }
    }
    return jsonEncode(dynList);
  }

  static Future<int> deleteNote(Note? note) {
    if (note==null) {
      return Future.value(0);
    }
    return NoteDao.delete(note.id)
      .then((count)async{
        // if (count==1) {
        //   CloudSyncService.deleteNote(note.id);
        //   return count;
        // }
        deleteNoteAttachment(note);
        return 0;
      });
  }

  static Future<int> cleanCloudNotes() {
    return NoteDao.cleanCloudNotes();
  }

  static Future<void> deleteNoteAttachment(Note? note) {
    return Future.value(null);
  }
}
