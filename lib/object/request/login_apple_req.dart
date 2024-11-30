import 'dart:convert';

import 'package:onote/util/object_util.dart';

class LoginAppleReq {

  LoginAppleReq(this.appleToken);

  String? appleToken;

  static LoginAppleReq? fromMap(dynamic map) {
    if (map==null) {
      return null;
    }
    return LoginAppleReq(
      ObjectUtil.isEmpty(map['appleToken']) ? null : map['appleToken'] as String
    );
  }

  static LoginAppleReq? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return LoginAppleReq.fromMap(map);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'appleToken': appleToken
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
