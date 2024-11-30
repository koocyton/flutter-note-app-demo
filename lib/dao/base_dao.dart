import 'dart:convert';
import 'dart:io';
import 'package:onote/sample/quill_text_sample.dart';
import 'package:onote/util/cache_util.dart';
import 'package:onote/util/time_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:onote/util/encrypt_util.dart';

class BaseDao {

  static late Database db;

  static Future<Database> initDababase() {
    File dbFile =  CacheUtil.getCacheFile("db/onote2.db");
    return  (openDatabase(
      dbFile.path, 
      version: 1,
      onCreate: (db, version)async {
        await createDatabase(db, version);
      }
    ).then((database){
      db = database;
      return db;
    }));
  }

  static Future<void> createDatabase(Database db, int version) async {
    db.execute(
      'CREATE TABLE note ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, '
        'status CHAR(10) DEFAULT NULL COLLATE NOCASE,'
        'content TEXT NOT NULL DEFAULT \'\' COLLATE NOCASE,'
        'creator CHAR(10) NOT NULL DEFAULT \'user\' COLLATE NOCASE,'
        'format CHAR(10) NOT NULL DEFAULT \'delta\' COLLATE NOCASE,'
        'customKeyHash VARCHAR(254) DEFAULT NULL COLLATE NOCASE,'
        'createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,'
        'updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP'
      ')'
    );
    db.insert(
      "note",
      {
        "content" : encContent(const JsonEncoder().convert(quillTextSample)),
        "creator": "installer",
        "format" : "delta",
        "createTime" : TimeUtil.formatYmdHis(DateTime.now()),
        "updateTime" : TimeUtil.formatYmdHis(DateTime.now())
      }
    );
    db.execute(
      'CREATE TABLE ai_chat ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, '
        'ask TEXT NOT NULL DEFAULT \'\' COLLATE NOCASE,'
        'answerType CHAR(20) NOT NULL DEFAULT \'\' COLLATE NOCASE,'
        'answerContent TEXT NOT NULL DEFAULT \'\' COLLATE NOCASE,'
        'answerImage TEXT DEFAULT NULL COLLATE NOCASE,'
        'createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,'
        'updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP'
      ')'
    );
  }

  static String encContent(String? content) {
    if (content==null || content=="") {
      return "";
    }
    return EncryptUtil .aesEnc(content, "ad5e16ce884520d8", "888b88a187424571");
  }

  static String decContent(String? encContent) {
    if (encContent==null || encContent=="") {
      return "";
    }
    return EncryptUtil.aesDec(encContent, "ad5e16ce884520d8", "888b88a187424571");
  }
}