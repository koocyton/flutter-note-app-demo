import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:onote/object/session_info.dart';
import 'package:onote/page/auth/auth_provider_page.dart';
import 'package:onote/page/main_page.dart';
import 'package:onote/page/note/list_style_masonry.dart';
import 'package:onote/page/note/list_style_timeline.dart';
import 'package:onote/plugin/read_html/read_html_plugin.dart';
import 'package:onote/service/note_service.dart';
import 'package:onote/util/cache_util.dart';
import 'package:onote/util/object_util.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_refresh.dart';
import 'package:onote/widget/easy_ui.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/widget/onote_scaffold.dart';
import 'package:onote/object/entity/note.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
class NotePageController extends GetxController {

  final RxList<Note> notesRx = RxList.empty();

  // 瀑布流 / 表格
  final RxInt viewStyleRx = RxInt(0)..listen((vs) {
  });

  // 拖拽中
  final RxBool deleteDragging = RxBool(false);

  // 显示工具条
  final RxBool showUtilsBar = RxBool(false);

  // 拖拽到了删除
  final RxBool deleteDraggingInPlace = RxBool(false);

  // 会话状态
  final Rx<SessionInfo?> sessionInfoRx = Rx<SessionInfo?>(ui.sessionInfo);

  // BannerAdRx
  // final Rx<BannerAd?> bannerAdRx = Rx<BannerAd?>(null);

  // EasyRefreshController
  final EasyRefreshController noteListRefreshController = EasyRefreshController();

  // openCreateNote
  void openCreateNote() {
    Future<dynamic>? futureResult = Get.toNamed("/page/createNote");
    if (futureResult!=null) {
      futureResult.then((result){
        if (result!=null && result["action"]=="create" && result["data"]!=null) {
          notesRx.insert(0, result["data"]);
        }
        refreshView();
      });
    }
  }

  void openEditNote(int index, Note note) {
    Future<dynamic>? futureResult = Get.toNamed("/page/editNote", arguments: {"note": notesRx[index]});
    if (futureResult!=null) {
      futureResult.then((result){
        if (result!=null && result["action"]=="update" && result["data"]!=null) {
          notesRx[index] = result["data"];
        }
        refreshView();
      });
    }
  }

  Future<void> deleteNote(int index) {
    Note note = notesRx[index];
    return NoteService.deleteNote(note)
      .then((count){
        notesRx.removeAt(index);
        deleteDraggingInPlace.value = false;
        deleteDragging.value = false;
        refreshView();
      });
  }

  Future<void> reloadNoteList() {
    return NoteService.getNoteList().then((notes){
      notesRx.clear();
      if (ObjectUtil.isNotEmpty(notes)) {
        notesRx.addAll(notes);
      }
      refreshView();
    });
  }

  void refreshView() {
    viewStyleRx.refresh();
    notesRx.refresh();
  }

  String contentText(String? content) {
    if (content==null || content.isEmpty) {
      return "";
    }
    try {
      return Document.fromJson(jsonDecode(content)).toPlainText();
    }
    catch(ignore) {
      return "";
    }
  }

  String noteContent(String contentText) {
    try {
      int contentLength = contentText.length;
      return contentText.substring(0, contentLength>200 ? 200 : contentLength);
    }
    catch(ignore) {
      return "";
    }
  }

  String noteTitle(String contentText) {
    try {
      contentText = contentText.replaceAll("￼", "");
      int titleLength = contentText.indexOf("\n");
      String title = contentText.substring(0, titleLength);
      // contentText = contentText.replaceAll(RegExp(r"[\r\n|\n|￼]"), "");
      return title.characters.getRange(0, titleLength>7?7:titleLength).toString().trim();
    }
    catch(ignore) {;}
    return "";
  }

  void setViewStyle(int value) {
    viewStyleRx.value = value;
    CacheUtil.set("view_style", value.toString());
  }

  void loadViewStyle() {
    String? cacheViewStyle = CacheUtil.get("view_style");
    if (cacheViewStyle!=null && cacheViewStyle.isNum) {
      viewStyleRx.value = int.parse(cacheViewStyle);
      viewStyleRx.refresh();
    }
  }

  void loadBannerAd() {
    // BannerAd(
    //   adUnitId: "ca-app-pub-9010116197474069/3014089536",
    //   request: const AdRequest(),
    //   size: AdSize(
    //     height: ui.floatingButtonWidth.toInt(), 
    //     width: (ui.windowWidth - ui.floatingButtonWidth - 40).toInt()
    //   ),
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       bannerAdRx.value = ad as BannerAd;
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       ad.dispose();
    //     },
    //   ),
    // ).load();
  }

  @override
  void onInit() {
    super.onInit();
    loadViewStyle();
    reloadNoteList();
    loadBannerAd();
  }
}

class NotePage extends GetView<NotePageController> {

  const NotePage({super.key});

  @override
  NotePageController get controller => Get.put(NotePageController());

  MainPageController  get mainController => Get.find<MainPageController>();

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return ONoteScaffold(
      appBar : ONoteAppBar(
        backgroundColor: ui.appNavBgColor,
        logo: EasyUI.twoColorText(
          text1: "ONoteAppName:O".xtr,
          text2: "ONoteAppName:Note".xtr,
          color1: ui.fgColor,
          fontSize: 27
        ),
      ),
      // appBar : ONoteAppBar(
      //   backgroundColor: ui.appNavBgColor,
      //   logo: EasyUI.twoColorText(
      //     text1: "ONoteAppName:O".xtr,
      //     text2: "ONoteAppName:Note".xtr,
      //     color1: ui.fgColor,
      //     fontSize: 27
      //   )
      // ),
      fixFloatingBottomButton: _floatingActionButton2(context),
      fixBody : Container(
       height : ui.windowHeight,
        color : Colors.green.shade50,
        child : easyRefresh(
          headTopInsets: ui.headHeight,
          refreshController: controller.noteListRefreshController,
          onRefresh: ()async{
            await controller.reloadNoteList();
          },
          // refreshOnStart: true,
          childBuilder:((refreshContext, refreshPhysics){
            return Obx(()=>controller.viewStyleRx.value == 0
              ? ListStyleTimeline(scrollPhysics: refreshPhysics)
              : ListStyleMasonry(scrollPhysics: refreshPhysics)
            );
          })
        )
      ),
      fixBottomBar: _deleteBar()
    );
  }

  Widget _appBar() {
    return Obx(()=>ONoteAppBar(
      backgroundColor: ui.appNavBgColor,
      logo: EasyUI.twoColorText(text1: "ONoteAppName:O".xtr, text2: "ONoteAppName:Note".xtr, color1: ui.fgColor, fontSize: 27),
      actions: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Row(
            children:[
              EasyButton.custom(
                text: controller.sessionInfoRx.value!=null ? " ${ui.sessionInfo?.email?.substring(0,5)}" : " --",
                textColor: Colors.black38,
                height: 33,
                width: 80,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                fillColor: Colors.transparent,
                iconColor: Colors.black38,
                iconData: controller.sessionInfoRx.value!=null 
                  ? (){
                      if (ui.sessionInfo?.authProvider=="Google") {
                        return FontAwesomeIcons.google;
                      }
                      else if (ui.sessionInfo?.authProvider=="Apple") {
                        return FontAwesomeIcons.apple;
                      }
                      return Icons.person;
                    }()
                  : Icons.cloud_off_outlined,
                iconSize: (){
                  if (ui.sessionInfo?.authProvider=="Google") {
                    return 14.0;
                  }
                  else if (ui.sessionInfo?.authProvider=="Apple") {
                    return 14.0;
                  }
                  return 21.0;
                }(),
                onPressed: (){
                  // mainController.sidebarController.switchSidebar();
                  // const AuthProviderPage();
                  AuthProviderPage.signInOutShow();
                }
              )
            ],
          )
        )
      ])
    );
  }

  Widget _floatingActionButton2(BuildContext context) {
    return Obx(()=>AnimatedContainer(
      padding: const EdgeInsets.all(10),
      duration: const Duration(milliseconds: 300),
      height: controller.deleteDragging.value ? 0 : 90,
      width: ui.windowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          const Expanded(
            child: SizedBox()
          ),
          // Expanded(
          //   child: controller.bannerAdRx.value==null
          //     ? const SizedBox()
          //     : AdWidget(ad: controller.bannerAdRx.value!)
          // ),
          // const SizedBox(height: 10, width: 10),
          // EasyButton.custom(
          //   iconScaleX: -1,
          //   iconScaleY: 1,
          //   iconData: Icons.download_for_offline_outlined,
          //   iconColor: Colors.black54,
          //   iconSize: 30,
          //   fillColor: ui.appNavBgColor,
          //   width: ui.floatingButtonWidth,
          //   height: ui.floatingButtonWidth,
          //   borderRadius: 10,
          //   onPressed: (){
          //     ReadHtmlPlugin.launch(context);
          //   }
          // ),
          const SizedBox(height: 10, width: 10),
          Transform.rotate(
            angle: 90 * 3.14 / 180,
            child: GestureDetector(
              child: EasyButton.custom(
                iconScaleX: -1,
                iconScaleY: 1,
                iconData: Icons.note_add_outlined,
                iconColor: Colors.black54,
                iconSize: 30,
                fillColor: ui.appNavBgColor,
                width: ui.floatingButtonWidth,
                height: ui.floatingButtonWidth,
                borderRadius: 10,
                onPressed: (){
                  controller.openCreateNote();
                }
              )
            ),
          )
        ]
      ),
    ));
  }

  Widget _floatingActionButton(BuildContext context) {
    return Obx(()=>AnimatedContainer(
      decoration: BoxDecoration(
        color: ui.appNavBgColor,
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      duration: const Duration(milliseconds: 300),
      height: controller.deleteDragging.value ? 0 : 90,
      width: ui.floatingButtonWidth * 3 + 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          _menuItem(labelText:"AI 创建", icon: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
            child: Lottie.asset(
              "assets/lottie/ai_robot.json",
              height: 30
            )
          ), onPressed: ()=>Get.toNamed("/plugin/aiCreator")),
          const SizedBox(width: 10),
          _menuItem(labelText:"导入", iconData: FontAwesomeIcons.fileImport, onPressed: ()=>ReadHtmlPlugin.launch(context)),
          const SizedBox(width: 10),
          _menuItem(labelText:"新笔记", iconData: Icons.add, onPressed: ()=>controller.openCreateNote()),
        ]
      ),
    ));
  }

  Widget _menuItem({required String labelText, IconData? iconData, required Function onPressed, Widget? icon}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        EasyButton.custom(
          iconData: iconData,
          iconColor: Colors.black45,
          iconSize: 20,
          icon: icon,
          fillColor: Colors.white70,
          width: ui.floatingButtonWidth,
          height: ui.floatingButtonWidth*0.8,
          borderRadius: 5,
          onPressed: onPressed
        ),
        const SizedBox(height: 5),
        Text(labelText, style: const TextStyle(color: Colors.black54, fontSize: 12))
      ]
    );
  }

  Widget _deleteBar() {
    return Obx(()=>AnimatedContainer(
      alignment: Alignment.center,
      color: controller.deleteDraggingInPlace.value ? Colors.red.shade600 : Colors.red.shade400,
      duration: const Duration(milliseconds: 150),
      height: controller.deleteDragging.value ? 100 : 0,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child:Column(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Lottie.asset(
                "assets/lottie/delete.json",
                animate: controller.deleteDraggingInPlace.value,
                repeat: controller.deleteDraggingInPlace.value,
                height: 30,
                width: 30,
              )
            ),
            Text(controller.deleteDraggingInPlace.value ? "松手即立即删除" : "将要删除的笔记拖到此处", style: const TextStyle(color: Colors.white)),
          ],
        )
      )
    ));
  }

  static Widget listStyleSelector(NotePageController controller) {
    return SizedBox(
      width: 101,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
            EasyButton.custom(
              height: 33,
              width: 50,
              borderRadius: 0,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              fillColor: controller.viewStyleRx.value == 0 ? Colors.green.shade200 : const Color(0x10000000),
              iconColor: Colors.black38,
              // iconData: Icons.more_vert,
              iconData: Icons.view_module_outlined,
              iconSize: 23,
              onPressed: (){
                controller.setViewStyle(0);
              }
            ),
            Container(color:Colors.black12, width: 1, height:34,),
            EasyButton.custom(
              height: 33,
              width: 50,
              borderRadius: 0,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              fillColor: controller.viewStyleRx.value == 1 ? Colors.green.shade200 : const Color(0x10000000),
              iconColor: Colors.black38,
              // iconData: Icons.more_vert,
              iconData: Icons.dashboard_outlined,
              iconSize: 21,
              onPressed: (){
                controller.setViewStyle(1);
              }
            )
          ]
        )
      )
    );
  }
}