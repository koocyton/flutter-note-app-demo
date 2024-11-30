import 'dart:convert';

import 'package:onote/util/object_util.dart';
import 'package:onote/util/time_util.dart';

class Note {

  int? id;
  String? status;
  String? content = "";
  String? creator = "user";
  String? format = "delta";
  String? customKeyHash;
  DateTime? createTime = DateTime.now();
  DateTime? updateTime = DateTime.now();

  static Note? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return Note()
      ..id         = ObjectUtil.toInt(dyn["id"])
      ..status     = ObjectUtil.toStrings(dyn["status"])
      ..content    = ObjectUtil.toStrings(dyn["content"])
      ..creator    = ObjectUtil.toStrings(dyn["creator"])
      ..format     = ObjectUtil.toStrings(dyn["format"])
      ..createTime = ObjectUtil.toDateTime(dyn["createTime"])
      ..updateTime = ObjectUtil.toDateTime(dyn["updateTime"])
      ..customKeyHash  = ObjectUtil.toStrings(dyn["customKeyHash"]);
  }

  static List<Note> fromMapList(dynamic noteMapList) {
    List<Note> noteList = [];
    for (var noteMap in noteMapList) {
      Note? note = fromMap(noteMap);
      if (note!=null) {
        noteList.add(note);
      }
    }
    return noteList;
  }

  static Note blankDeltaNote() {
    return Note()..format="delta"..creator="user";
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'id': id,
    'status': status,
    'format': format,
    'creator': creator,
    'customKeyHash': customKeyHash,
    'content': content,
    'createTime': TimeUtil.formatYmdHis(createTime),
    'updateTime': TimeUtil.formatYmdHis(updateTime)
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();
}