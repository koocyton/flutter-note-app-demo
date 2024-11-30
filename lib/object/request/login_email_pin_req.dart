import 'dart:convert';

import 'package:onote/util/object_util.dart';

class LoginEmailPinReq {

  LoginEmailPinReq(this.email, this.pin);

  String? email;
  String? pin;

  static LoginEmailPinReq? fromMap(dynamic map) {
    if (map==null) {
      return null;
    }
    return LoginEmailPinReq(
      ObjectUtil.isEmpty(map["email"]) ? null : map['email'] as String,
      ObjectUtil.isEmpty(map['pin']) ? null : map['pin'] as String
    );
  }

  static LoginEmailPinReq? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return LoginEmailPinReq.fromMap(map);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'email': email,
    'pin': pin,
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
