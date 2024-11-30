import 'dart:convert';

import 'package:onote/util/object_util.dart';

class SessionInfo {

  SessionInfo(this.token, this.email, this.authProvider);

  String? token;
  String? email;
  String? authProvider;

  static SessionInfo? fromMap(dynamic map) {
    if (ObjectUtil.isEmpty(map) || ObjectUtil.isEmpty(map["token"]) || ObjectUtil.isEmpty(map["email"])) {
      return null;
    }
    return SessionInfo(
      map['token'],
      map['email'],
      map['authProvider']
    );
  }

  static SessionInfo? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return SessionInfo.fromMap(map);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'token': token,
    'email': email,
    'authProvider': authProvider,
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}