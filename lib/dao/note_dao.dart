import 'package:onote/dao/base_dao.dart';
import 'package:onote/object/entity/note.dart';
import 'package:logger/logger.dart';
import 'package:onote/util/time_util.dart';

class NoteDao {

  static Logger logger = Logger();

  static Future<Note?> getById(int? id) {
    if (id==null) {
      return Future.value(null);
    }
    return BaseDao.db.query(
        "note",
        where: "id=?",
        whereArgs: [id],
        limit: 1
      )
    .then((mapList){
      if (mapList.isEmpty || mapList.length==0 || mapList[0].isEmpty) {
        return null;
      }
      Note? note = Note.fromMap(mapList[0]);
      if (note==null) {
        return null;
      }
      note.content = BaseDao.decContent(note.content);
      return note;
    });
  }

  static Future<List<Note>> getList() {
    return BaseDao.db.query(
        "note",
        // columns: columns,
        orderBy: ' updateTime DESC ',
        // where: "id=?",
        // whereArgs: [id],
        // limit:1
      )
    .then((mapList){
      List<Note> noteList = (mapList.isEmpty || mapList.length==0) ? [] : Note.fromMapList(mapList);
      for (int ii=0; ii<noteList.length; ii++) {
        noteList[ii].content = BaseDao.decContent(noteList[ii].content);
      }
      return noteList;
    });
  }

  static Future<Note?> createNote(String content) {
    return BaseDao.db.insert(
        "note", 
        {
          "format" : "delta",
          "creator" : "user",
          "content" : BaseDao.encContent(content)
        }
      )
      .then((id){
        return getById(id);
      });
  }

  static Future<Note?> updateNote(int id, String content) {
    return BaseDao.db.update(
        "note",
        {
          "content" : BaseDao.encContent(content)
        },
        where: "id=?",
        whereArgs: [id]
      )
      .then((count){
        return getById(id);
      });
  }

  static Future<Note?> saveFromCloud(Note cloudNote) {
    if (cloudNote.id==null) {
      return Future.value(null);
    }
    return getById(cloudNote.id)
      .then((note){
        if (note==null) {
          return _createFromCloud(cloudNote);
        }
        else {
          return _updateFromCloud(cloudNote);
        }
      });
  }

  static Future<Note?> _createFromCloud(Note cloudNote) {
    return BaseDao.db.insert(
        "note",
        {
          "id" : cloudNote.id,
          "content" : BaseDao.encContent(cloudNote.content),
          "updateTime" : TimeUtil.formatYmdHis(cloudNote.updateTime),
          "customKeyHash" : cloudNote.customKeyHash,
          "format" : "delta",
          "creator" : "user",
          "status" : "cloud"
        }
      )
      .then((id){
        return getById(id);
      });
  }

  static Future<Note?> _updateFromCloud(Note cloudNote) {
    return BaseDao.db.update(
        "note",
        {
          "id" : cloudNote.id,
          "content" : BaseDao.encContent(cloudNote.content),
          "updateTime" : TimeUtil.formatYmdHis(cloudNote.updateTime),
          "customKeyHash" : cloudNote.customKeyHash,
          "status" : "cloud"
        },
        where: "id=?",
        whereArgs: [cloudNote.id]
      )
      .then((count){
        return getById(cloudNote.id!);
      });
  }

  static Future<int> setNoteStatusIsCloud(int? localId, int? id) {
    if (localId==null || id==null) {
      return Future.value(0);
    }
    logger.t("localId:${localId}, id:${id}");
    return BaseDao.db.update(
        "note",
        {
          "id":id,
          "status":"cloud"
        },
        where: "id=?",
        whereArgs: [localId]
      );
  }

  static Future<int> delete(int? id) {
    return BaseDao.db.delete(
      "note",
      where:"id=?",
      whereArgs: [id]
    );
  }

  static Future<int> cleanCloudNotes() {
    return BaseDao.db.delete(
      "note", 
      where:"status=?", 
      whereArgs: ["cloud"]
    );
  }
}
