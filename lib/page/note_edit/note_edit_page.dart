import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onote/main.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:logger/logger.dart';
import 'package:onote/object/entity/note.dart';
import 'package:onote/object/enums/keyboard_status.dart';
import 'package:onote/page/note_edit/block_embed_table.dart';
import 'package:onote/page/note_edit/block_embed_image.dart';
import 'package:onote/page/note_edit/editor_event_widget.dart';
import 'package:onote/page/note_edit/quill_button.dart';
import 'package:onote/service/note_service.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_toast.dart';
import 'package:onote/widget/onote_scaffold.dart';
import 'package:onote/page/note_edit/note_toolbar.dart';
import 'package:onote/page/note_edit/note_menu.dart';


class NoteEditController extends GetxController {

  // 外部传参
  dynamic argumentData = Get.arguments;

  // forceNode
  final FocusNode focusNode = FocusNode();

  // quill controller
  final q.QuillController quillController = q.QuillController.basic();

  // late load note
  late Note note;

  // 提示信息
  final RxString editMessageRx = RxString("");

  // 当前选择的菜单
  final RxInt currentMenuIndexRx = RxInt(0);
  // 菜单面板高度
  final RxDouble menuPanelHeightRx = RxDouble(0);
  // 键盘面板高度
  final RxDouble keyboardHeightRx = RxDouble(0);
  // 锁定键盘在底部
  final RxBool isKeepKeyboardUnderBottomRx = RxBool(false);
  // 键盘最大高度
  double? maxKeyboardHeight;
  // 键盘状态
  KeyboardStatus keyboardStatus = KeyboardStatus.hide;

  final Logger logger = Logger();

  @override
  void onInit() {
    if (argumentData!=null && argumentData['note']!=null) {
      note = argumentData['note'];
      try {
        quillController.document = q.Document.fromJson(jsonDecode(note.content!));
      }
      // ignore: empty_catches
      catch(ignore){
        // editorController.document = q.Document.fromJson(jsonDecode('[{"insert":"${note.content!}\\n"}]'));
      }
    }
    else {
      note = Note();
    }
    quillController.changes.listen((e) {
      editMessageRx.value = checkDocument(quillController.document);
    });
    super.onInit();
  }

  String checkDocument(q.Document document) {
      String plainText = document.toPlainText();
      if (plainText.length>6000) {
        return "内容超限 ${plainText.length}/6000";
      }
      
      Delta docDelta = quillController.document.toDelta();
      int customImageCount = 0;
      docDelta.toList().forEach((operation) { 
        if (operation.value.runtimeType.toString().contains("Map") && operation.value["custom"]!=null) {
          String custom = operation.value["custom"];
          if (custom.contains("image")) {
            customImageCount++;
          }
        }
      });
      if (customImageCount>5) {
        return "图片数量超限 $customImageCount/5";
      }
      return "";
  }

  void saveAndGoback() {
    if (note.id==null) {
      String plainText = quillController.document.toPlainText();
      if (plainText.trim()!="") {
        if (editMessageRx.value!="") {
          EasyToast.dismiss();
          EasyToast.showBottomToast(editMessageRx.value);
          return;
        }
        NoteService.createNote(
          jsonEncode(quillController.document.toDelta().toJson())
        ).then((note)=>Get.back(result: {"action": "create", "data":note}));
      }
      else {
        Future.delayed(Duration.zero, (){
          Get.back();
        });
      }
    }
    else {
      if (editMessageRx.value!="") {
        EasyToast.dismiss();
        EasyToast.showBottomToast(editMessageRx.value);
        return;
      }
      NoteService.updateNote(
        note.id!,
        jsonEncode(quillController.document.toDelta().toJson()),
      )
      .then((note)=>Get.back(result: {"action": "update", "data":note}));
    }
  }

  // 切换 menuLabel
  void switchMenuLabel(BuildContext context, int choiceMenuLabel) {
    currentMenuIndexRx.value = choiceMenuLabel;
    // 键盘菜单在底部
    if (menuPanelHeightRx.value<=0) {
      keyboardStatus = KeyboardStatus.showing;
      isKeepKeyboardUnderBottomRx.value = true;
      menuPanelHeightRx.value = maxKeyboardHeight ?? ui.windowHeight * 0.382;
    }
    // 键盘在底部, 菜单弹起
    else if(keyboardHeightRx.value<=0) {
      keyboardStatus = KeyboardStatus.showing;
      isKeepKeyboardUnderBottomRx.value = true;
      SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    }
    // 键盘弹起, 菜单弹起
    else {
      keyboardStatus = KeyboardStatus.hiding;
      isKeepKeyboardUnderBottomRx.value = true;
      SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    }
  }

  // 切换 返回
  void onPopInvoked() {
    // 键盘菜单在底部
    if (menuPanelHeightRx.value<=0) {
        saveAndGoback();
    }
    // 键盘在底部, 菜单弹起
    else if(keyboardHeightRx.value<=0) {
      isKeepKeyboardUnderBottomRx.value = true;
      menuPanelHeightRx.value = 0;
    }
    // 键盘弹起, 菜单弹起
    else {
      isKeepKeyboardUnderBottomRx.value = false;
      SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    }
  }
}

class NoteEditPage extends GetView<NoteEditController> {

  const NoteEditPage({super.key});

  @override
  NoteEditController get controller => Get.put(NoteEditController());

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (b, o){
        controller.onPopInvoked();
      },
      child: Obx(()=>EditorEventWidget(
        onKbSliding: (bm) {
          controller.keyboardHeightRx.value = bm;
          if (controller.menuPanelHeightRx.value<bm || !controller.isKeepKeyboardUnderBottomRx.value) {
            controller.menuPanelHeightRx.value = bm;
          }
        },
        onKbShowBegin: (bm) {
          controller.keyboardStatus = KeyboardStatus.showing;
        },
        onKbShowEnd: (bm){
          controller.keyboardStatus = KeyboardStatus.show;
          controller.quillController.formatSelection(q.Attribute.font);
          controller.currentMenuIndexRx.value = 0;
          // 设置 maxKeyboardHeight
          controller.maxKeyboardHeight ??= bm;
          // 关闭键盘锁定
          Future.delayed(const Duration(milliseconds: 20), (){
            controller.isKeepKeyboardUnderBottomRx.value = false;
            controller.menuPanelHeightRx.value = bm;
          });
        },
        onKbHideEnd: (bm) {
          controller.keyboardStatus = KeyboardStatus.hide;
        },
        child: Container(
          color: Colors.green.shade50,
          child: Column(
            children: [
              appBar(),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment:Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    editPanel(),
                    Positioned(
                      right: ui.windowWidth * 0.19,
                      left: ui.windowWidth * 0.19,
                      bottom: 10,
                      child: messagePanel()
                    )
                  ]
                )
                // child: widget.editPanel
              ),
              const NoteMenu(),
              AnimatedContainer(
                height: controller.menuPanelHeightRx.value,
                duration: Duration(milliseconds: (controller.isKeepKeyboardUnderBottomRx.value ? 150 : 0)),
                decoration: const BoxDecoration(
                  color:Color.fromARGB(0, 94, 67, 67)
                ),
                onEnd: (){
                  // debugPrint(">>>>>" + getSubmenuPanelHeight().toString());
                },
                child: const NoteToolbar(),
              ),
            ],
          )
        )
      )
    ));
  }

  Widget editPanel() {
    return Container(
      decoration: const BoxDecoration(color:Colors.white),
      child: q.QuillEditorProvider(
        // configurations: q.QuillConfigurations(
        //   controller: controller.quillController,
        //   sharedConfigurations: q.QuillSharedConfigurations(
        //     locale: Locale("zh", "CN"),
        //   ),
        // ),
        child: q.QuillEditor.basic(
          controller: controller.quillController,
          focusNode: controller.focusNode,
          configurations: q.QuillEditorConfigurations(
            onImagePaste: (u){
              return Future.value("");
            },
            scrollable: true,
            autoFocus: false,
            // readOnly: false,
            expands: true,
            padding: const EdgeInsets.all(20),
            placeholder: "",
            scrollPhysics: ui.physics,
            editorKey: GlobalKey<q.EditorState>(),
            showCursor: true,
            floatingCursorDisabled: false,
            paintCursorAboveText: true,
            magnifierConfiguration: const TextMagnifierConfiguration(
              shouldDisplayHandlesInMagnifier:false
            ),
            // customStyles: q.DefaultStyles(
            //   paragraph: q.DefaultTextBlockStyle(
            //     TextStyle(
            //       color: Colors.black,
            //       fontWeight:
            //       FontWeight.w900,
            //       fontSize: 35
            //     ),
            //     q.VerticalSpacing(16, 0),
            //     q.VerticalSpacing(0, 0),
            //     null
            //   ),
            // ),
            embedBuilders: [
              EmbedTableBuilder(addEditNote: (context, document) { 
                return Future.value(null);
              }),
              EmbedImageBuilder(addEditNote: (context, document) { 
                return Future.value(null);
              })
            ])
          ),
      )
    );
  }

  Widget messagePanel() {
    return controller.editMessageRx.value==""
      ? const SizedBox(width: 0, height:0)
      : Positioned(
        // right: 10,
        // left: ui.windowWidth * 0.19,
        bottom: 10,
        child: Container(
          height: 35,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),
          child: Text(
            controller.editMessageRx.value,
            style: const TextStyle(color: Colors.black54)
          )
        )
      );
  }

  Widget appBar() {
    return ONoteAppBar(
      backgroundColor: ui.appNavBgColor,
      onBack: () => controller.saveAndGoback(),
      actions: [
        QuillToggleStyleButton(
          fillSelectedColor: Colors.transparent,
          attribute: q.Attribute.unchecked, 
          controller: controller.quillController,
          skipRequestKeyboard: false,
          childBuild: (isToggled) {
            return EasyButton.custom(
              height: 30,
              width: 50,
              borderRadius: 5,
              // fillColor: Colors.green.shade300,
              // iconColor: controller.quillController.hasUndo ? Colors.black45 : Colors.black26,
              // iconData: Icons.undo,
              icon: SvgPicture.asset(
                "assets/svg/undo-24px.svg",
                width:30,
                height:30,
                colorFilter: ColorFilter.mode(controller.quillController.hasUndo ? Colors.black54 : Colors.black12, BlendMode.srcIn)
              ),
              onPressed: (){
                controller.quillController.undo();
              }
            );
          } 
        ),
        QuillToggleStyleButton(
          fillSelectedColor: Colors.transparent,
          attribute: q.Attribute.unchecked, 
          controller: controller.quillController,
          skipRequestKeyboard: false,
          childBuild: (isToggled) {
            return EasyButton.custom(
              height:30,
              width:50,
              borderRadius: 5,
              // fillColor: Colors.green.shade300,
              // iconColor: controller.quillController.hasRedo ? Colors.black45 : Colors.black26,
              // iconData: Icons.redo,
              icon: SvgPicture.asset(
                "assets/svg/redo-24px.svg",
                width:30,
                height:30,
                colorFilter: ColorFilter.mode(controller.quillController.hasRedo ? Colors.black54 : Colors.black12, BlendMode.srcIn)
              ),
              onPressed: (){
                controller.quillController.redo();
              }
            );
          }
        ),
        // EasyButton.custom(
        //   height:30,
        //   width:50,
        //   borderRadius: 5,
        //   icon: SvgPicture.asset(
        //     "assets/svg/glasses-16px.svg",
        //     width:30,
        //     height:30,
        //     colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcIn)
        //   ),
        //   onPressed: (){
        //     String noteContent = jsonEncode(controller.quillController.document.toDelta().toJson());
        //     Get.toNamed("/page/viewNote", arguments: {"note": Note()..content=noteContent});
        //   }
        // )
      ],
    );
  }
}