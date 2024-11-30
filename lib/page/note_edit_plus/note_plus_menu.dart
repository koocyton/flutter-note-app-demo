import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:onote/page/note_edit/block_embed_image.dart';
import 'package:onote/page/note_edit/note_picture_selector.dart';
import 'package:onote/page/note_edit_plus/note_plus_edit_page.dart';
import 'package:onote/widget/easy_ui.dart';
import 'package:onote/widget/onote_scaffold.dart';
import 'package:logger/logger.dart';
import 'package:onote/page/note_edit/quill_button.dart';

class NotePlusMenu extends StatefulWidget {

  final NotePlusEditController controller;

  const NotePlusMenu({
    required this.controller,
    super.key
  });

  @override
  State<NotePlusMenu> createState()=>NotePlusMenuState();
}

class NotePlusMenuState extends State<NotePlusMenu> {

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return ONoteNavigationBar (
      radius: 16,
      backgroundColor: ui.appNavBgColor,
      type: ONoteNavigationBarType.click,
      items: [
        // ONoteNavigationBarItem(
        //   iconData: Icons.download_for_offline_outlined,
        //   iconColor: Colors.black54,
        //   label:"NoteMenu:Import".xtr,
        //   onTap: (ctx) {
        //     ReadHtmlPlugin.launch(context);
        //   },
        // ),
        // ONoteNavigationBarItem(
        //   iconColor: Colors.black54,
        //   icon: ColorFiltered(
        //     colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
        //     child: Lottie.asset(
        //       "assets/lottie/ai_robot.json",
        //       height: 25,
        //       width: 30,
        //     )
        //   ),
        //   label:"NoteMenu:AI".xtr,
        //   onTap: (ctx) {
        //     if (ui.sessionInfo!=null) {
        //       AiCopilotPlugin.launch(context);
        //     }
        //     else {
        //       SystemChannels.textInput.invokeMethod<void>('TextInput.hide').then((V){
        //         EasyToast.showBottomToast("NoteMenu:AI Need Login".xtr);
        //       });
        //     }
        //   },
        // ),
        ONoteNavigationBarItem(
          iconData: Icons.text_fields_outlined,
          iconColor: widget.controller.selectedMenuLabel && widget.controller.currentMenuLabel==1 
            ? Colors.white60 
            : Colors.black54,
          // iconColor:  Colors.black54,
          label:"NoteMenu:text".xtr,
          onTap: (ctx) {
            widget.controller.changeMenuLabel(context, 1);
          },
        ),
        QuillToggleStyleButton(
          fillSelectedColor: Colors.transparent,
          attribute: Attribute.unchecked, 
          controller: widget.controller.quillController,
          skipRequestKeyboard: false,
          childBuild: (isToggled) {
            Color iconColor = (isToggled!=null && isToggled==true) ? Colors.white : Colors.black54;
            return ONoteNavigationBarItem(
              iconData: Icons.checklist,
              iconColor: iconColor,
              label:"NoteMenu:checkAttribute".xtr,
              onTap: (ctx) {
                widget.controller.quillController.formatSelection(isToggled!
                  ? Attribute.clone(Attribute.unchecked, null)
                  : Attribute.unchecked);
              },
            );
          } 
        ),
        ONoteNavigationBarItem(
          iconData: Icons.photo_camera_outlined,
          label:"NoteMenu:picture".xtr,
          onTap: (ctx) {
            List<Operation> optList = widget.controller.quillController.document.toDelta().toList();
            for(Operation opt in optList) {
              logger.t("${opt.key} ${opt.attributes}");
            }
            EasyUI.showBottomModal(
              title: "NoteMenu:Select Picture".xtr,
              titleWeight: FontWeight.bold,
              height: ui.windowHeight - ui.headHeight,
              context: context,
              enableDrag: true,
              backgroundColor: Colors.green.shade100,
              child: NotePictureSelector(
                compressFileParentDir: "unUploadImage",
                onCompress: (absolutePath, relativePath) {
                  // logger.t("4 $relativePath");
                  int offset = widget.controller.quillController.selection.extentOffset;
                  widget.controller.quillController.document.insert(
                    offset,
                    BlockEmbed.custom(
                      BlockEmbedImage(relativePath),
                    )
                  );
                  Get.back();
                },
              )
            );
          },
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.setMenuState = (fn){
      if (mounted) {
        setState(fn);
      }
    };
  }

  @override
  void dispose() {
    widget.controller.setMenuState = (fn)=>null;
    super.dispose();
  }
}
