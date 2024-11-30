import 'dart:convert';

import 'package:onote/util/object_util.dart';

class LoginMobilePinReq {

  LoginMobilePinReq(this.mobile, this.pin);

  String? mobile;
  String? pin;

  static LoginMobilePinReq? fromMap(dynamic map) {
    if (map==null) {
      return null;
    }
    return LoginMobilePinReq(
      ObjectUtil.isEmpty(map["mobile"]) ? null : map['mobile'] as String,
      ObjectUtil.isEmpty(map['pin']) ? null : map['pin'] as String
    );
  }

  static LoginMobilePinReq? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return LoginMobilePinReq.fromMap(map);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'mobile': mobile,
    'pin': pin,
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}
