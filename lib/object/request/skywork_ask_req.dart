import 'dart:convert';

import 'package:onote/util/object_util.dart';

class SkyworkAskReq {

  SkyworkAskReq(this.text);

  String? text;

  static SkyworkAskReq? fromMap(dynamic dyn) {
    if (dyn==null) {
      return null;
    }
    return SkyworkAskReq(
      ObjectUtil.toStrings(dyn["text"])
    );
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'text': text
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
