import 'dart:convert';

import 'package:onote/util/object_util.dart';

class SkyworkAskResp {

  SkyworkAskResp(this.type, this.content, this.image);

  String? type;
  String? content;
  String? image;

  static SkyworkAskResp? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return SkyworkAskResp(
      ObjectUtil.toStrings(dyn["type"]),
      ObjectUtil.toStrings(dyn["content"]),
      ObjectUtil.toStrings(dyn["image"]),
    );
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'type': type,
    'content': content,
    'image': image
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
