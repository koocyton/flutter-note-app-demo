import 'dart:convert';
import 'package:onote/util/object_util.dart';
import 'package:onote/util/time_util.dart';


class NoteInfoResp {

  NoteInfoResp(this.id, this.content, this.secretKeyHash, this.createTime, this.updateTime);

  int? id;
  String? content;
  String? secretKeyHash;
  DateTime? createTime;
  DateTime? updateTime;

  static List<NoteInfoResp>? listFromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    List<NoteInfoResp> noteList = [];
    for (dynamic note in dyn) {
      NoteInfoResp? noteInfo = fromMap(note);
      if (noteInfo!=null) {
        noteList.add(noteInfo);
      }
    }
    return noteList;
  }

  static NoteInfoResp? fromMap(dynamic map) {
    if (map==null) {
      return null;
    }
    return NoteInfoResp(
      ObjectUtil.isEmpty(map['id']) ? null : int.parse(map['id']),
      ObjectUtil.isEmpty(map['content']) ? null : map['content'],
      ObjectUtil.isEmpty(map['secretKeyHash']) ? null : map['secretKeyHash'],
      ObjectUtil.isEmpty(map['createTime']) ? null : DateTime.parse(map['createTime']),
      ObjectUtil.isEmpty(map['updateTime']) ? null : DateTime.parse(map['updateTime'])
    );
  }

  static NoteInfoResp? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return NoteInfoResp.fromMap(map);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'id': id,
    'content': content,
    'secretKeyHash': secretKeyHash,
    'createTime': TimeUtil.formatYmdHis(createTime),
    'updateTime': TimeUtil.formatYmdHis(updateTime),
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}