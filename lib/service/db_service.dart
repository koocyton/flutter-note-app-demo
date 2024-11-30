import 'package:onote/dao/base_dao.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class DBService {

  static Logger logger = Logger();

  static Future<Database> initDababase() {
    return BaseDao.initDababase();
  }
}
