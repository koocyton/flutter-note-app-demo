import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/util/object_util.dart';


class LoginPinResp {

  LoginPinResp(this.pinCountdown);

  int pinCountdown;

  static LoginPinResp? fromMap(dynamic map) {
    if (map==null) {
      return null;
    }
    String? pinCountdown = map['pinCountdown'].toString();
    // debugPrint("$pinCountdown");
    return LoginPinResp(
      (ObjectUtil.isEmpty(pinCountdown) || !pinCountdown.isNum)
        ? 0
        : int.parse(pinCountdown),
    );
  }

  static LoginPinResp? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return LoginPinResp.fromMap(map);
  }

  Map<String, int?> toJsonMap() => <String, int?>{
    'pinCountdown': pinCountdown
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}