import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:onote/main.dart';
import 'package:onote/object/entity/note.dart';
import 'package:onote/object/enums/keyboard_status.dart';
import 'package:onote/page/note_edit/block_embed_image.dart';
import 'package:onote/page/note_edit/block_embed_table.dart';
import 'package:onote/page/note_edit/quill_button.dart';
import 'package:onote/page/note_edit_plus/note_plus_menu.dart';
import 'package:onote/page/note_edit_plus/note_plus_toolbar.dart';
import 'package:onote/service/note_service.dart';
import 'package:onote/util/cache_util.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_toast.dart';
import 'package:onote/widget/onote_scaffold.dart';

class NotePlusEditController {
  
  String tipMessage = "";

  bool isLockKeyboardBottom = false;

  KeyboardStatus keyboardStatus = KeyboardStatus.hide;

  double keyboardHeight = 0;

  double toolbarHeight = 0;

  double? maxToolbarHeight;

  int currentMenuLabel = 0;

  bool selectedMenuLabel = false;

  late final Note note;

  final FocusNode focusNode = FocusNode();

  NotePlusEditController(){
    String? maxToolbarHeightCache = CacheUtil.get("maxToolbarHeightCache");
    if (maxToolbarHeightCache!=null) {
      maxToolbarHeight = double.parse(maxToolbarHeightCache);
    }
  }

  void initNote() {
    // 外部传参
    dynamic argumentData = Get.arguments;
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
      tipMessage = checkDocument(quillController.document);
      setStatus();
    });
  }

  void initEditContext(BuildContext context) {
    editContext = context;
  }

  List<double> maxToolbarHeightList = [];
  void cacheMaxToolbarHeight(double? mth) {
    if (mth!=null && mth>0) {
      maxToolbarHeightList.add(mth);
      if (maxToolbarHeight==null) {
        maxToolbarHeight = mth;
      }
      else if (maxToolbarHeightList.length>=3) {
        if (maxToolbarHeightList[0]==maxToolbarHeightList[1]) {
          maxToolbarHeight = maxToolbarHeightList[0];
          CacheUtil.set("maxToolbarHeightCache", maxToolbarHeight.toString());
        }
        else if (maxToolbarHeightList[0]==maxToolbarHeightList[2]) {
          maxToolbarHeight = maxToolbarHeightList[0];
          CacheUtil.set("maxToolbarHeightCache", maxToolbarHeight.toString());
        }
        else if (maxToolbarHeightList[1]==maxToolbarHeightList[2]) {
          maxToolbarHeight = maxToolbarHeightList[1];
          CacheUtil.set("maxToolbarHeightCache", maxToolbarHeight.toString());
        }
        maxToolbarHeightList.clear();
      }
    }
  }

  Function(VoidCallback fn) setMenuState = (fn)=>Void;

  Function(VoidCallback fn) setEditState = (fn)=>Void;

  Function(VoidCallback fn) setToolbarState = (fn)=>Void;

  final q.QuillController quillController = q.QuillController.basic();

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

  void saveThenExit(){
    if (note.id==null) {
      String plainText = quillController.document.toPlainText();
      // debugPrint("plainText $plainText");
      if (plainText.trim()!="") {
        if (tipMessage!="") {
          EasyToast.dismiss();
          EasyToast.showBottomToast(tipMessage);
          return;
        }
        // Get.back(result: {"action": "create", "data":note});
        // debugPrint("debugPrint ${quillController.document.toDelta().toJson()}");
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
      if (tipMessage!="") {
        EasyToast.dismiss();
        EasyToast.showBottomToast(tipMessage);
        return;
      }
      NoteService.updateNote(
        note.id!,
        jsonEncode(quillController.document.toDelta().toJson()),
      )
      .then((note)=>Get.back(result: {"action": "update", "data":note}));
    }
  }

  void setStatus() {
    setEditState((){});
    setMenuState((){});
    setToolbarState((){});
  }

  void slideinMenubar(int x) {
    double m = maxToolbarHeight ?? ui.windowHeight * 0.382; 
    toolbarHeight = toolbarHeight + x;
    if (toolbarHeight>=m-10) {
      toolbarHeight = m;
      setStatus();
    }
    else {
      setStatus();
      Future.delayed(const Duration(milliseconds: 1), (){
        slideinMenubar(x);
      });
    }
  }

  void slideoutMenubar(int x) {
    toolbarHeight = toolbarHeight - x;
    if (toolbarHeight<=10) {
      toolbarHeight = 0;
      setStatus();
    }
    else {
      setStatus();
      Future.delayed(const Duration(milliseconds: 1), (){
        slideoutMenubar(x);
      });
    }
  }

  double slideMenubarStep(Duration t, Duration? pt) {
      if (pt==null || t.inMicroseconds == pt.inMicroseconds) {
        return 0;
      }
      int b = t.inMilliseconds - pt.inMilliseconds;
      double m = maxToolbarHeight ?? ui.windowHeight * 0.382; 
      return m / 140 * b;
  }

  // 切换 menuLabel
  void changeMenuLabel(BuildContext context, int choiceMenuLabel) {
    currentMenuLabel = choiceMenuLabel;
    // 菜单在底部
    if (toolbarHeight<=0) {
      isLockKeyboardBottom = selectedMenuLabel= true;
      slideinMenubar(10);
      // toolbarHeight = maxToolbarHeight ?? ui.windowHeight * 0.382;
    }
    // 菜单已弹起
    else {
      isLockKeyboardBottom = true;
      selectedMenuLabel = false;
      SystemChannels.textInput.invokeMethod<void>(
        keyboardHeight<=0 ? 'TextInput.show' : 'TextInput.hide'
      );
    }
    setStatus();
  }

  // 切换 返回
  void onPopInvoked<T>(bool didPop, T? result) {
    // 键盘&菜单在底部
    if (toolbarHeight<=0) {
      if (!didPop) {
        saveThenExit();
      }
    }
    // 键盘在底部, 菜单弹起
    else if(keyboardHeight<=0) {
      isLockKeyboardBottom = selectedMenuLabel = false;
      setStatus();
      slideoutMenubar(10);
    }
    // 键盘弹起, 菜单弹起
    else {
      isLockKeyboardBottom = false;
      SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    }
  }

  Duration? frameCallTime;

  double lastKeyboardHeight = 0;

  BuildContext? editContext;

  void frameCallback(Duration callTime) {
    if (editContext==null || (frameCallTime!=null && frameCallTime!.compareTo(callTime)==0)) {
      return;
    }
    keyboardHeight = MediaQuery.of(editContext!).viewInsets.bottom;
    // show begin
    if (keyboardHeight > lastKeyboardHeight && lastKeyboardHeight <= 0) {
      keyboardStatus = KeyboardStatus.showing;
      selectedMenuLabel = false;
      Future.delayed(const Duration(milliseconds: 270), (){
        keyboardStatus = KeyboardStatus.show;
        isLockKeyboardBottom = selectedMenuLabel = false;
        toolbarHeight = keyboardHeight;
        cacheMaxToolbarHeight(keyboardHeight);
        setStatus();
      });
    }
    // hide end
    else if (keyboardHeight <= 0 && keyboardHeight < lastKeyboardHeight) {
      keyboardStatus = KeyboardStatus.hide;
      // 键盘在底部，说明是为了展示子菜单
      selectedMenuLabel = isLockKeyboardBottom;
    }
    // 剩下的就是 hiding 和 sliding ( 软键盘切换形态使得高度变化 ) 了
    else {
      keyboardStatus = KeyboardStatus.sliding;
    }
    if (isLockKeyboardBottom==false || toolbarHeight<keyboardHeight) {
      toolbarHeight = keyboardHeight;
    }
    lastKeyboardHeight = keyboardHeight;
    frameCallTime = callTime;
    setStatus();
  }
}

class NotePlusEditPage extends StatefulWidget {

  const NotePlusEditPage({
    super.key
  });

  @override
  State<NotePlusEditPage> createState() {
    return NotePlusEditPageState();
  }
}

class NotePlusEditPageState extends State<NotePlusEditPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin {

  final NotePlusEditController controller = NotePlusEditController();

  final Logger logger = Logger();

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback(controller.frameCallback);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        controller.onPopInvoked(didPop, result);
      },
      child: Container(
        color: Colors.green.shade50,
        child: Column(
          children: [
            editAppBar(),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment:Alignment.center,
                fit: StackFit.expand,
                children: [
                  richTextArea(),
                  Positioned(
                    right: ui.windowWidth * 0.19,
                    left: ui.windowWidth * 0.19,
                    bottom: 10,
                    child: tipToast()
                  )
                ]
              )
              // child: widget.editPanel
            ),
            NotePlusMenu(controller:controller),
            // AnimatedContainer(
            Container(
              height: controller.toolbarHeight,
              decoration: const BoxDecoration(color:Color.fromARGB(0, 94, 67, 67)),
              child: NotePlusToolbar(controller:controller)
            )
            // Container(
            //   height: controller.toolbarHeight,
            //   // duration: controller.isLockKeyboardBottom ? const Duration(milliseconds:150) : Duration.zero,
            //   decoration: const BoxDecoration(
            //     color:Color.fromARGB(0, 94, 67, 67)
            //   ),
            //   //onEnd: (){
            //     // debugPrint(" >>> ${controller.toolbarHeight} ${controller.keyboardHeight} ${controller.isLockKeyboardBottom}");
            //   // },
            //   child: NotePlusToolbar(controller:controller),
            // )
          ]
        )
      )
    );
  }

  Widget richTextArea() {
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

  Widget tipToast() {
    return controller.tipMessage==""
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
            controller.tipMessage,
            style: const TextStyle(color: Colors.black54)
          )
        )
      );
  }

  Widget editAppBar() {
    return ONoteAppBar(
      backgroundColor: ui.appNavBgColor,
      onBack: () => controller.saveThenExit(),
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

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance.addObserver(this);
    controller.initEditContext(context);
    controller.initNote();
    controller.setEditState = (fn){
      if (mounted) {
        setState(fn);
      }
    };
  }

  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance.removeObserver(this);
    controller.editContext = null;
    controller.focusNode.dispose();
    controller.setEditState = (fn)=>null;
    super.dispose();
  }
}