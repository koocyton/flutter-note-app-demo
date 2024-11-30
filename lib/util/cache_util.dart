import 'dart:io';

import 'package:onote/main.dart';
import 'package:logger/logger.dart';

class CacheUtil {

  static final Logger logger = Logger();

  static Future<File> set(String key, String value) {
    File cacheFile = getCacheFile(key);
    return cacheFile.writeAsString(value, mode: FileMode.write, flush: true);
  }

  static Future<File> setBytes(String key, List<int> value) {
    File cacheFile = getCacheFile(key);
    return cacheFile.writeAsBytes(value, mode: FileMode.write, flush: true);
  }

  static Future<List<String?>?> getDirFiles(String path) {
    Directory dir = Directory("${ui.applicationDir}/.cache_util/$path");
    if (!dir.existsSync()) {
      return Future.value(null);
    }
    return dir.list().map((s){
      return s.path;
    }).toList();
  }

  static String? get(String key, {int? expireMinutes}) {
    File cacheFile = getCacheFile(key);
    if (!cacheFile.existsSync()) {
      return null;
    }
    if (expireMinutes!=null) {
      if (DateTime.now().difference(cacheFile.lastModifiedSync()).inMinutes>expireMinutes) {
        return null;
      }
    }
    return cacheFile.readAsStringSync();
  }

  static List<int>? getBytes(String key, {int? expireMinutes}) {
    File cacheFile = getCacheFile(key);
    if (!cacheFile.existsSync()) {
      return null;
    }
    if (expireMinutes!=null) {
      if (DateTime.now().difference(cacheFile.lastModifiedSync()).inMinutes>expireMinutes) {
        return null;
      }
    }
    return cacheFile.readAsBytesSync();
  }

  static int remove(String key) {
    File cacheFile = File("${ui.applicationDir}/.cache_util/$key");
    if (cacheFile.existsSync()) {
      cacheFile.deleteSync();
      return 1;
    }
    return 0;
  }

  static File getCacheFile(String key) {
    return getAppStorageFile("${ui.applicationDir}/.cache_util/$key");
  }

  static File getAppStorageFile(String filePath) {
    File file = File(filePath);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    return file;
  }
}