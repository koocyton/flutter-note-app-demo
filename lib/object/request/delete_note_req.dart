import 'dart:convert';

import 'package:onote/util/object_util.dart';

class DeleteNoteReq {

  DeleteNoteReq(this.id);

  int? id;

  static DeleteNoteReq? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return DeleteNoteReq(
      ObjectUtil.toInt(dyn["id"])
    );
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'id': id
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
