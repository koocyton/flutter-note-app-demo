import 'dart:convert';

import 'package:onote/util/object_util.dart';
import 'package:onote/util/time_util.dart';

class SaveNoteResp {

  int? id;

  int? userId;

  String? content;

  String? customKeyHash;

  DateTime? updateTime;

  // DateTime? createTime;

  static SaveNoteResp? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return SaveNoteResp()
      ..id=ObjectUtil.toInt(dyn['id'])
      ..userId=ObjectUtil.toInt(dyn['userId'])
      ..content=ObjectUtil.toStrings(dyn['content'])
      ..customKeyHash=ObjectUtil.toStrings(dyn['secretKeyHash'])
      // ..createTime=ObjectUtil.toDateTime(dyn['createTime'])
      ..updateTime=ObjectUtil.toDateTime(dyn['updateTime']);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'id': id,
    'userId': userId,
    'content': content,
    'customKeyHash': customKeyHash,
    // 'createTime': TimeUtil.formatYmdHis(createTime),
    'updateTime': TimeUtil.formatYmdHis(updateTime)
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
