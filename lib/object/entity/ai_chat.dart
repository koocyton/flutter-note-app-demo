import 'dart:convert';

import 'package:onote/util/object_util.dart';
import 'package:onote/util/time_util.dart';

class AiChat {

  int? id;
  String? ask;
  String? answerType;
  String? answerContent;
  String? answerImage;
  bool isFload = true;
  DateTime? createTime = DateTime.now();
  DateTime? updateTime = DateTime.now();

  static AiChat? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return AiChat()
      ..id            = ObjectUtil.toInt(dyn["id"])
      ..ask           = ObjectUtil.toStrings(dyn["ask"])
      ..answerType    = ObjectUtil.toStrings(dyn["answerType"])
      ..answerContent = ObjectUtil.toStrings(dyn["answerContent"])
      ..answerImage   = ObjectUtil.toStrings(dyn["answerImage"])
      ..createTime = ObjectUtil.toDateTime(dyn["createTime"])
      ..updateTime = ObjectUtil.toDateTime(dyn["updateTime"]);
  }

  static List<AiChat> fromMapList(dynamic noteMapList) {
    List<AiChat> noteList = [];
    for (var noteMap in noteMapList) {
      AiChat? note = fromMap(noteMap);
      if (note!=null) {
        noteList.add(note);
      }
    }
    return noteList;
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'id': id,
    'ask': ask,
    'answerType': answerType,
    'answerContent': answerContent,
    'answerImage': answerImage,
    'createTime': TimeUtil.formatYmdHis(createTime),
    'updateTime': TimeUtil.formatYmdHis(updateTime)
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();
}