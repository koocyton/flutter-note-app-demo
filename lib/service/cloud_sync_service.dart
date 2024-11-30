import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/dao/note_dao.dart';
import 'package:onote/main.dart';
import 'package:onote/object/entity/note.dart';
import 'package:onote/object/request/delete_note_req.dart';
import 'package:onote/object/request/save_note_req.dart';
import 'package:onote/object/response/note_id_time_resp.dart';
import 'package:onote/object/response/save_note_resp.dart';
import 'dart:async';
import 'package:onote/service/api_request_service.dart';
import 'package:onote/service/note_service.dart';
import 'package:onote/util/cache_util.dart';
import 'package:onote/util/object_util.dart';
import 'package:onote/util/time_util.dart';
import 'package:onote/page/note/note_page.dart';
import 'package:onote/widget/easy_toast.dart';

class CloudSyncService {

  static Logger logger = Logger();

  static final notePageController = Get.find<NotePageController>();
  static int localKey = 0;
  static int delayedLocalKey = 0;

  static Future<void> fullSync() async {
    if (ui.sessionInfo==null) {
      EasyToast.showBottomToast("登陆后,可在不同设备间同步数据");
      return;
    }
    // check lock
    String? lock = CacheUtil.get("SyncLockKey", expireMinutes: 1);
    if (ObjectUtil.isNotEmpty(lock)) {
      logger.t("Previous sync process not finish");
      return;
    }
    // set lock
    await CacheUtil.set("SyncLockKey", TimeUtil.formatYmdHis(DateTime.now())!);
    await _syncNote();
    // remove lock
    CacheUtil.remove("SyncLockKey");
    await notePageController.reloadNoteList();
    notePageController.noteListRefreshController.callRefresh();
  }

  static Future<void> _syncNote() async {
    // 云端主要对比数据  {id:{updateTime:"2023-12-12 12:12:12"}}
    Map<int, NoteIdTimeResp> idTimeRespMap = await serverAppNoteIdTimeMap();
    // logger.t("idTimeRespMap : $idTimeRespMap");
    // 本地数据
    List<Note> localNoteList = await NoteService.getNoteList();
    // 如果本地和云端数据都为空
    // logger.t("localNoteList $localNoteList");
    if (ObjectUtil.isEmpty(localNoteList) && ObjectUtil.isEmpty(idTimeRespMap)) {
      logger.t("local & remote note list is null");
      return;
    }
    // 假设需要从远端更新到本地的数据，是 idTimeRespMap 里的全部
    // 在本地数据和远程数据对比是，从 needUpdateIdTimeMap 排除掉会上传的部分
    Map<int, NoteIdTimeResp> needUpdateIdTimeMap = {};
    needUpdateIdTimeMap.addAll(idTimeRespMap);

    // 开始循环处理本地数据，从 needUpdateIdTimeMap 排除掉会上传的部分
    for(Note localNote in localNoteList) {
      // 检查数据有没有在云端
      NoteIdTimeResp? idTimeResp = idTimeRespMap[localNote.id];

      // if (idTimeResp!=null) {
      //   log.info("idTimeResp.updateTime (${idTimeResp.updateTime})==localNote.updateTime (${localNote.updateTime}  ${idTimeResp.updateTime!.compareTo(localNote.updateTime!)})");
      // }
      // 忽略 help 数据
      if (localNote.creator=="installer") {
        needUpdateIdTimeMap.remove(localNote.id);
        continue;
      }
      // 上传到云端没有的数据
      else if (idTimeResp==null){
        // log.info("remote note list is null");
        // log.info("idTimeResp is null ${localNote.id} $idTimeRespMap");
        needUpdateIdTimeMap.remove(localNote.id);
        // logger.t("create note id : ${createdNote.id}");
        CloudSyncService.createNote(localNote).then((createResp) async{
          if (createResp!=null) {
            await NoteDao.setNoteStatusIsCloud(localNote.id, createResp.id);
            await NoteService.uploadImageReviseContent(createResp, localNote);
          }
          notePageController.reloadNoteList();
        });
        continue;
      }
      // 两边数据一样
      else if (idTimeResp.updateTime!.compareTo(localNote.updateTime!)==0) {
        // log.info("idTimeResp.updateTime==localNote.updateTime");
        needUpdateIdTimeMap.remove(localNote.id);
        continue;
      }
      // 云端数据较 旧
      else if (idTimeResp.updateTime!.isBefore(localNote.updateTime!)) {
        // log.info("idTimeResp.updateTime!.isBefore(localNote.updateTime!)");
        needUpdateIdTimeMap.remove(localNote.id);
        CloudSyncService.updateNote(localNote).then((updateResp)async{
          if (updateResp!=null) {
            await notePageController.reloadNoteList();
            await NoteService.uploadImageReviseContent(updateResp, localNote);
          }
        });
        continue;
      }
      // log.info("remoteUpdateTime<${idTimeResp.id}>:${idTimeResp.updateTime!} localUpdateTime<${localNote.id}>:${localNote.updateTime!} isBefore:${idTimeResp!.updateTime!.isBefore(localNote.updateTime!)}");
    }

    // needUpdateIdTimeMap 剩下的部分，用来更新到本地
    if (ObjectUtil.isEmpty(needUpdateIdTimeMap)) {
      return;
    }
    // 获取详细数据
    // log.info("needUpdateIdTimeMap : $needUpdateIdTimeMap");
    List<int> idList = [];
    needUpdateIdTimeMap.forEach((id, idTimeResp) {
      idList.add(idTimeResp.id!);
    });
    List<Note> needUpdateList = await needUpdateNoteList(idList);
    for (Note needUpdateNote in needUpdateList) {
      await NoteDao.saveFromCloud(needUpdateNote);
    }
  }

  static Future<Map<int, NoteIdTimeResp>> serverAppNoteIdTimeMap() {
    return ApiRequestService.noteIdTimeInfoList()
      .then((noteIdTimeList){
        if (ObjectUtil.isEmpty(noteIdTimeList)) {
          return {};
        }
        Map<int, NoteIdTimeResp> noteIdTimeMap = {};
        for(NoteIdTimeResp noteIdTimeResp in noteIdTimeList) {
          if (noteIdTimeResp.id==null) {
            continue;
          }
          noteIdTimeMap.addAll({noteIdTimeResp.id! : noteIdTimeResp});
        }
        return noteIdTimeMap;
      });
  }

  static Future<List<Note>> needUpdateNoteList(List<int> idList) {
    return ApiRequestService.noteInfoList(idList);
  }

  static Future<SaveNoteResp?> createNote(Note localNote) {
    if (ui.sessionInfo==null) {
      logger.t("when session is empty, can not create note \n id ${localNote.id}");
      return Future.value(null);
    }
    if (localNote.id==null || localNote.content==null || localNote.updateTime==null) {
      logger.t("when id (${localNote.id}), content (${localNote.content}) or updateTime (${localNote.updateTime}) is empty, can not create note");
      return Future.value(null);
    }
    SaveNoteReq saveReq = SaveNoteReq(localNote.id, localNote.content, localNote.updateTime!);
    return ApiRequestService.createNote(saveReq)
      .then((saveResp){
        // logger.t("localNote:${localNote} \nsaveResp:${saveResp}");
        if (saveResp==null || saveResp.id==null) {
          logger.t("note create failed \n request : $saveReq \n response : $saveResp ");
          return null;
        }
        return saveResp;
      });
  }

  static Future<SaveNoteResp?> updateNote(Note localNote) {
    if (ui.sessionInfo==null) {
      logger.t("when session is empty, can not upload note \n id ${localNote.id}");
      return Future.value(null);
    }
    if (localNote.id==null || localNote.content==null || localNote.updateTime==null) {
      logger.t("when id (${localNote.id}), content (${localNote.content}) or updateTime (${localNote.updateTime}) is empty, can not upload note");
      return Future.value(null);
    }
    SaveNoteReq saveReq = SaveNoteReq(localNote.id, localNote.content, localNote.updateTime!);
    return ApiRequestService.updateNote(saveReq)
      .then((saveResp){
        // logger.t("localNote:${localNote} \nsaveResp:${saveResp}");
        if (saveResp==null || saveResp.id==null) {
          logger.t("note update failed \n request : $saveReq \n response : $saveResp ");
          return null;
        }
        return saveResp;
      });
  }

  static Future<int?> deleteNote(int? id) {
    if (ui.sessionInfo==null) {
      logger.t("when session is empty, can not delete note $id");
      return Future.value(null);
    }
    return ApiRequestService.deleteNote(DeleteNoteReq(id));
  }
}
