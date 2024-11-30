import 'package:get/get.dart';

class ObjectUtil {

  static int? toInt(dynamic dyn) {
    return (dyn==null || !dyn.toString().isNum) 
      ? null 
      : int.parse(dyn.toString());
  }

  static String? toStrings(dynamic dyn) {
    return dyn?.toString();
  }

  static DateTime? toDateTime(dynamic dyn) {
    return dyn==null ? null : DateTime.parse(dyn.toString());
  }

  static bool isNotEmpty(dynamic dyn) {
    return !isEmpty(dyn);
  }

  static bool isEmpty(dynamic dyn) {
    if (dyn==null) {
      return true;
    }
    if (dyn is String) {
      return dyn=="";
    }
    else if (dyn is List) {
      return dyn.isEmpty;
    }
    else if (dyn is Map) {
      return dyn.isEmpty;
    }
    return false;
  }
}