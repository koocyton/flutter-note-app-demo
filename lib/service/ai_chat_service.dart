import 'package:onote/dao/ai_chat_dao.dart';
import 'package:onote/object/entity/ai_chat.dart';
import 'package:logger/logger.dart';

class AiChatService {

  static Logger logger = Logger();

  static Future<List<AiChat>> getAiChatList() {
    return AiChatDao.getList();
  }

  static Future<AiChat?> createAiChat(String ask) {
    return AiChatDao.createAiChat(ask);
  }

  static Future<AiChat?> putAnswer(int id, String answerContent, String answerImage) {
    return AiChatDao.putAnswer(id, answerContent, answerImage);
  }

  static Future<int?> delete(int id) {
    return AiChatDao.delete(id);
  }
}
