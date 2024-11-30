import 'dart:convert';

import 'package:onote/util/object_util.dart';
import 'package:onote/util/time_util.dart';

class SaveNoteReq {

  SaveNoteReq(this.id, this.content, this.updateTime);

  int? id;

  String? content;

  DateTime? updateTime;

  static SaveNoteReq? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return SaveNoteReq(
      ObjectUtil.toInt(dyn['id']),
      ObjectUtil.toStrings(dyn['content']),
      ObjectUtil.toDateTime(dyn['updateTime'])
    );
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'id': id,
    'content': content,
    'updateTime': TimeUtil.formatYmdHis(updateTime)
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
