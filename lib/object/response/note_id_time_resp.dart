import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:onote/util/object_util.dart';
import 'package:onote/util/time_util.dart';

class NoteIdTimeResp {

  static Logger logger = Logger();

  int? id;
  DateTime? updateTime;

  static List<NoteIdTimeResp> listFromMap(dynamic dyn) {
    List<NoteIdTimeResp> noteList = [];
    for (dynamic note in dyn) {
      NoteIdTimeResp? noteInfo = fromMap(note);
      if (noteInfo!=null) {
        noteList.add(noteInfo);
      }
    }
    return noteList;
  }

  static NoteIdTimeResp? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return NoteIdTimeResp()
      ..id = ObjectUtil.toInt(dyn["id"])
      ..updateTime = ObjectUtil.toDateTime(dyn["updateTime"]);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'id': id,
    'updateTime': TimeUtil.formatYmdHis(updateTime),
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}