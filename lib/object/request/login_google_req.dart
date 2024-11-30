import 'dart:convert';

import 'package:onote/util/object_util.dart';

class LoginGoogleReq {

  LoginGoogleReq(this.googleToken);

  String? googleToken;

  static LoginGoogleReq? fromMap(dynamic map) {
    if (map==null) {
      return null;
    }
    return LoginGoogleReq(
      ObjectUtil.isEmpty(map['idToken']) ? null : map['idToken'] as String
    );
  }

  static LoginGoogleReq? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return LoginGoogleReq.fromMap(map);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'googleToken': googleToken
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
