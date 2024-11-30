class Constant {

  // api 主机
  static String get apiHost => "https://api.openai.com";

  // 对话
  static String get chatApi => "$apiHost/chat";

  // 文生图
  static String get text2imgApi => "$apiHost/text2img";

  // 文生单词
  static String get text2wordApi => "$apiHost/text2word";
}
