import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:onote/object/entity/ai_chat.dart';
import 'package:onote/object/request/skywork_ask_req.dart';
import 'package:onote/page/note_edit/note_edit_page.dart';
import 'package:onote/service/ai_chat_service.dart';
import 'package:onote/service/api_request_service.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_input.dart';
import 'package:onote/widget/easy_toast.dart';
import 'package:onote/widget/easy_ui.dart';
import 'package:onote/page/note_edit/editor_event_widget.dart';
import 'package:onote/widget/spin_kit.dart';

class AiCreatorPluginController extends GetxController {

  static Logger logger = Logger();

  final Rx<int?> currentChatIndex = Rx<int?>(null);

  final RxDouble bottomPaddingRx = RxDouble(0);

  final RxString inputText = RxString("");

  final RxList<AiChat> aiChatList = RxList<AiChat>([]);

  double maxScrollExtent = 0;

  final ScrollController scrollController = ScrollController();

  Timer? scrollToBottomTimer;

  void scrollToBottom() {
    if (scrollToBottomTimer==null || !scrollToBottomTimer!.isActive) {
      scrollToBottomTimer = Timer.periodic(
        const Duration(milliseconds: 200),
        (timer) {
          if (scrollController.hasClients && maxScrollExtent!=scrollController.position.maxScrollExtent) {
            maxScrollExtent=scrollController.position.maxScrollExtent;
            scrollController.position.moveTo(
              maxScrollExtent,
              duration: const Duration(milliseconds: 100),
            );
          }
          // logger.t("currentChatIndex.value : ${currentChatIndex.value}");
          if (currentChatIndex.value==null) {
            timer.cancel();
          }
        },
      );
    }
  }

  void cancelScrollToBottom() {
    if (scrollToBottomTimer!=null && scrollToBottomTimer!.isActive) {
      scrollToBottomTimer!.cancel();
      scrollToBottomTimer = null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    AiChatService.getAiChatList().then((list){
      aiChatList.value = list;
    });
  }
}

class AiCreatorPlugin extends GetView<AiCreatorPluginController> {

  const AiCreatorPlugin({super.key});

  static final TextEditingController inputController = TextEditingController();

  static Logger logger = Logger();

  static List<String> tips = ["testResponse"];

  @override
  AiCreatorPluginController get controller => Get.put(AiCreatorPluginController());

  NoteEditController get editController => Get.find<NoteEditController>();

  static void launch(BuildContext context) {
    // Get.toNamed("/plugin/aiCopilot");
    EasyUI.showBottomModal(
      title: "AICopilot:AI Copilot".xtr,
      titleWeight: FontWeight.bold,
      enableDrag: true,
      context: context,
      height: ui.windowHeight - ui.headHeight,
      backgroundColor: Colors.green.shade100,
      child: const AiCreatorPlugin()
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditorEventWidget(
      onKbHiding:(bottomPadding) {
        controller.bottomPaddingRx.value = bottomPadding;
      },
      onKbHideEnd:(bottomPadding) {
        controller.bottomPaddingRx.value = 0;
      },
      onKbShowBegin: (bottomPadding){
        if (controller.scrollController.hasClients) {
          controller.scrollController.position.jumpTo(
            controller.scrollController.position.maxScrollExtent
          );
        }
      },
      onKbShowing:(bottomPadding) {
        controller.bottomPaddingRx.value = bottomPadding;
        if (controller.scrollController.hasClients) {
          controller.scrollController.position.jumpTo(
            controller.scrollController.position.maxScrollExtent
          );
        }
      },
      child: Container(
        color:Colors.green.shade50,
        child:Column(
          children: [
            const Divider(height: 0.2, color:Color(0x05000000)),
            chatHistory(),
            chatInput(context)
          ]
        )
      )
    );
  }

  Widget chatHistory() {
    return Obx(()=>Expanded(
      child: Align(
      alignment: Alignment.topCenter,
        child: ListView.builder(
          physics: ui.physics,
          itemCount: controller.aiChatList.length,
          controller: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          itemBuilder: (context, index){
            return chatItem(index);
          })
        )
      )
    );
  }

  Widget chatItem(int index) {
    return Column(
      children: [
        Material(
          color: Colors.green.shade50,
          child: InkWell(
            onLongPress: (){
              String? ask = controller.aiChatList[index].ask;
              if (ask!=null && ask!="") {
                Clipboard.setData(ClipboardData(text: ask)).then((v){
                  String _ask = ask.replaceAll("\n", "");
                  int l = ask.length;
                  EasyToast.showBottomToast("复制 \"${_ask.substring(0, l<5?l:5)}...\" 到粘贴板");
                });
              }
            },
            child:Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const SizedBox(width: 40),
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 40,
                      ),
                      alignment: Alignment.centerRight,
                      // width: ui.windowWidth - 100,
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text(controller.aiChatList[index].ask!, style: const TextStyle(fontSize: 15))
                    )
                  ),
                  EasyButton.custom(
                    height: 40,
                    width: 40,
                    text: "AICopilot:me".xtr,
                    borderRadius: 20,
                    fillColor: Colors.blue.shade100,
                    axis: Axis.vertical
                  )
                ])
            )
          )
        ),
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              controller.currentChatIndex.value = null;
              controller.aiChatList.refresh();
              controller.scrollToBottom();
            },
            onLongPress: (){
              Clipboard.setData(
                ClipboardData(text: controller.aiChatList[index].answerContent!)
              )
              .then((v){
                String answerContent = controller.aiChatList[index].answerContent!.replaceAll("\n", "");
                int l = answerContent.length;
                EasyToast.showBottomToast("复制 \"${answerContent.substring(0, l<5?l:5)}...\" 到粘贴板");
              });
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  EasyButton.custom(
                    // iconData: Icons.smart_toy_outlined,
                    height: 40,
                    width: 40,
                    icon: ColorFiltered(
                        colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
                        child: Lottie.asset(
                          "assets/lottie/ai_robot.json",
                          height: 30,
                          width: 30,
                          animate: ((controller.currentChatIndex.value!=null && controller.currentChatIndex.value==index) || (index>controller.aiChatList.length-1 || controller.aiChatList[index].answerContent==null))
                        )
                      ),
                    borderRadius: 20,
                    fillColor: Colors.green.shade100,
                    axis: Axis.vertical,
                    margin: const EdgeInsets.fromLTRB(0, 0, 5, 0)
                  ),
                  Expanded(
                    child:Container(
                      constraints: const BoxConstraints(
                        minHeight: 40,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: controller.aiChatList[index].answerContent==null ? 40 : null,
                        child: replyBlock(index)
                      )
                    )
                  ),
                  SizedBox(
                    width: 40,
                    height: 25,
                    child: PopupMenuButton(
                      color: Colors.white,
                      shadowColor: Colors.black38,
                      position: PopupMenuPosition.under,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (BuildContext context){
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            height: 40,
                            child: Text("AICopilot:Insert to doc".xtr, style: TextStyle(color:Colors.black54)),
                            onTap: (){
                              Get.back();
                              int offset = editController.quillController.selection.extentOffset;
                              editController.quillController.document.insert(
                                offset,
                                controller.aiChatList[index].answerContent!
                              );
                              // update offset
                              editController.quillController.updateSelection(
                                TextSelection.collapsed(offset: offset + controller.aiChatList[index].answerContent!.length),
                                ChangeSource.local,
                              );
                            },
                          ),
                          PopupMenuItem(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            height: 40,
                            child: Text("AICopilot:copy".xtr, style: TextStyle(color:Colors.black54)),
                            onTap:(){
                              Clipboard.setData(ClipboardData(text: controller.aiChatList[index].answerContent!)).then((v){
                                String answer = controller.aiChatList[index].answerContent!.replaceAll("\n", "");
                                int l = answer.length;
                                EasyToast.showBottomToast("复制 \"${answer.substring(0, l<5?l:5)}...\" 到粘贴板");
                              });
                            }
                          ),
                          PopupMenuItem(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            height: 40,
                            child: Text("AICopilot:delete".xtr, style: TextStyle(color:Colors.black54)),
                            onTap: (){
                              int? id = controller.aiChatList[index].id;
                              if(id!=null) {
                                AiChatService.delete(id);
                              }
                              controller.aiChatList.removeAt(index);
                            },
                          ),
                        ];
                      },
                      child:EasyButton.custom(
                        iconData: Icons.more_horiz,
                        borderRadius: 20,
                    )
                  )
                )
              ])
            )
        )
      )
    ]);
  }

  Widget replyBlock(int index) {
    if (index>controller.aiChatList.length-1 || controller.aiChatList[index].answerContent==null) {
      return SpinKit.foldingCube(color: ui.appNavBgColor, size: 17);
    }
    if (controller.currentChatIndex.value==null || controller.currentChatIndex.value!=index) {
      String con = controller.aiChatList[index].answerContent!;
      int len = con.length;
      if (len>120) {
        return RichText(
          text: TextSpan(
            text: controller.aiChatList[index].isFload ? con.substring(0, 90) : con,
            style: const TextStyle(color:Colors.black87, fontSize: 16),
            children: <InlineSpan>[
              controller.aiChatList[index].isFload 
                ? const TextSpan(text: ' ... ', style: TextStyle(color: Colors.black38))
                : const TextSpan(text: ' ', style: TextStyle(color: Colors.black38)),
              TextSpan(
                text: controller.aiChatList[index].isFload ? '展开' : "\n收起",
                style: const TextStyle(color: Colors.black38, fontSize: 19),
                recognizer: TapGestureRecognizer()..onTap =(){
                  controller.aiChatList[index].isFload = !controller.aiChatList[index].isFload;
                  controller.aiChatList.refresh();
                }
              )
            ]
          )
        );
      }
      return Text(con, style: const TextStyle(fontSize: 15));
    }
    return AnimatedTextKit(
      isRepeatingAnimation: false,
      animatedTexts: [
        TypewriterAnimatedText(
          controller.aiChatList[index].answerContent!, 
          speed: const Duration(milliseconds: 120),
          textStyle: const TextStyle(fontSize: 15),
          cursor: " ●" // ⚫ ▊●█●●
        ),
      ],
      onTap: () {
        controller.aiChatList[index].isFload = false;
        controller.currentChatIndex.value = null;
        controller.aiChatList.refresh();
        controller.scrollToBottom();
      },
      onFinished: (){
        controller.aiChatList[index].isFload = false;
        controller.currentChatIndex.value = null;
        controller.aiChatList.refresh();
        controller.cancelScrollToBottom();
      },
    );
  }

  Widget chatTips() {
    return Container(
      color:ui.bgColor,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      width:ui.windowWidth,
      height: 40,
      child: ListView.builder(
        itemCount: tips.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, ii){
          return EasyButton.custom(
            text: tips[ii],
            textColor: Colors.black87,
            borderRadius: 20,
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            fillColor: const Color(0x13000000),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            onPressed: (){
              sendAsk(tips[ii]);
            }
          );
        },
      )
    );
  }

  Widget chatInput(BuildContext context) {
    return Obx(()=>Container(
        color: ui.bgColor,
        alignment: Alignment.centerLeft,
        padding : EdgeInsets.fromLTRB(10, 5, 10, 10 + controller.bottomPaddingRx.value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding : const EdgeInsets.fromLTRB(10, 6, 10, 6),
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black12, width: 1),
                  color:Colors.white
                ),
                // child: Container(height:40)
                child: EasyInput.text(
                  controller: inputController,
                  onChanged: (value) {
                    controller.inputText.value = inputController.text;
                  },
                  isCollapsed: true,
                  maxLines: 5,
                  minLines: 1,
                  textSize: 18,
                  hintText: "AICopilot:ask question".xtr
                )
              )
            ),
            Obx(()=>AnimatedContainer(
                height: 40,
                duration: const Duration(milliseconds: 150),
                width: controller.inputText.value!="" ? 30 : 0,
                alignment: Alignment.centerRight,
                margin: EdgeInsets.fromLTRB(controller.inputText.value!="" ? 6 : 0,  0, 0, 0),
                child: EasyButton.custom(
                  iconData: FontAwesomeIcons.chevronCircleUp,
                  iconColor: Colors.black87,
                  iconSize: 30,
                  onPressed: (){
                    sendAsk(controller.inputText.value);
                  }
                )
              )
            )
          ]
        )
      )
    );
  }

  void sendAsk(String? ask) {
    if (ask!=null && ask!="") {
      AiChat aiChat = AiChat()..ask=ask;
      int idx = controller.aiChatList.length;
      controller.aiChatList.add(aiChat);
      controller.currentChatIndex.value = null;
      controller.scrollToBottom();
      AiChatService.createAiChat(ask).then((aiChat){
        if (aiChat!=null) {
          controller.aiChatList[idx].id = aiChat.id!;
          ApiRequestService.skyworkAsk(SkyworkAskReq(ask))
            .then((skyworkAskResp)async{
              if (skyworkAskResp!=null && skyworkAskResp.type!=null) {
                controller.currentChatIndex.value = controller.aiChatList.length - 1;
                controller.aiChatList[idx].answerContent = skyworkAskResp.content;
                controller.aiChatList.refresh();
                controller.scrollToBottom();
                AiChatService.putAnswer(aiChat.id!, skyworkAskResp.content!, "");
              }
            });
        }
      });
      inputController.text="";
      controller.inputText.value = "";
    }
  }
}