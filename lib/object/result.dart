import 'dart:convert';

import 'package:onote/util/object_util.dart';

class Result<T> {

  Result(this.code, this.msg, this.data);

  String? code;

  String? msg;

  T? data;

  static Result? fromMap(Map<String, dynamic>? map) {
    if (map==null) {
      return null;
    }
    return Result(
      ObjectUtil.isEmpty(map['code']) ? "" : map['code'].toString(),
      ObjectUtil.isEmpty(map['msg']) ? "" : map['msg'].toString(),
      map['data']
    );
  }

  static Result? fromJson(String json) {
    Map<String, dynamic> map = const JsonDecoder().convert(json);
    return Result.fromMap(map);
  }

  Map<String, dynamic> toJsonMap() => <String, dynamic>{
    'code': code,
    'msg': msg,
    'data': data
  };

  String toJson() => const JsonEncoder().convert(toJsonMap());

  @override
  String toString() => toJson();

}