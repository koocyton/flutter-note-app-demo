import 'package:onote/dao/base_dao.dart';
import 'package:onote/object/entity/ai_chat.dart';
import 'package:logger/logger.dart';

class AiChatDao {

  static Logger logger = Logger();

  static Future<AiChat?> getById(int? id) {
    if (id==null) {
      return Future.value(null);
    }
    return BaseDao.db.query(
        "ai_chat",
        where: "id=?",
        whereArgs: [id],
        limit: 1
      )
    .then((mapList){
      if (mapList.isEmpty || mapList.length==0 || mapList[0].isEmpty) {
        return null;
      }
      return AiChat.fromMap(mapList[0]);
    });
  }

  static Future<List<AiChat>> getList() {
    return BaseDao.db.query(
        "ai_chat",
        // columns: columns,
        orderBy: ' createTime ASC ',
        // where: "id=?",
        // whereArgs: [id],
        // limit:1
      )
    .then((mapList){
      return (mapList.isEmpty || mapList.length==0) ? [] : AiChat.fromMapList(mapList);
    });
  }

  static Future<AiChat?> createAiChat(String ask) {
    return BaseDao.db.insert(
        "ai_chat", 
        {
          "ask" : ask,
        }
      )
      .then((id){
        return getById(id);
      });
  }

  static Future<AiChat?> putAnswer(int id, String answerContent, String answerImage) {
    return BaseDao.db.update(
        "ai_chat",
        {
          "answerContent" : answerContent,
          "answerImage" : answerImage
        },
        where: "id=?",
        whereArgs: [id]
      )
      .then((count){
        return getById(id);
      });
  }

  static Future<int> delete(int? id) {
    return BaseDao.db.delete(
      "ai_chat",
      where:"id=?",
      whereArgs: [id]
    );
  }
}
