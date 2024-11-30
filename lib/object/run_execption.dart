class RunException implements Exception {

  final String code;

  final String message;

  RunException(this.code, this.message);

  String toJson() {
    return "{\"code\": \"$code\", \"message\": \"$message\"}";
  }

  @override
  String toString() => toJson();

  static RunException? cast(dynamic dyn) {
    if (dyn.runtimeType==RunException) {
      return dyn;
    }
    return null;
  }
}