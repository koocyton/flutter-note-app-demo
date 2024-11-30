import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:onote/page/note_edit/note_edit_page.dart';
import 'package:onote/page/note_edit/block_embed_image.dart';
import 'package:onote/page/note_edit/note_picture_selector.dart';
import 'package:onote/plugin/ai/ai_copilot_plugin.dart';
import 'package:onote/widget/easy_toast.dart';
import 'package:onote/widget/easy_ui.dart';
import 'package:onote/widget/onote_scaffold.dart';
import 'package:logger/logger.dart';
import 'package:onote/page/note_edit/quill_button.dart';

class NoteMenu extends GetView<NoteEditController> {

  const NoteMenu({super.key});

  @override
  NoteEditController get controller => Get.find<NoteEditController>();

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return ONoteNavigationBar (
      radius: 16,
      backgroundColor: ui.appNavBgColor,
      type: ONoteNavigationBarType.click,
      items: [
        ONoteNavigationBarItem(
          iconColor: Colors.black54,
          icon: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
            child: Lottie.asset(
              "assets/lottie/ai_robot.json",
              height: 25,
              width: 30,
            )
          ),
          label:"NoteMenu:AI".xtr,
          onTap: (ctx) {
            if (ui.sessionInfo!=null) {
              AiCopilotPlugin.launch(context);
            }
            else {
              SystemChannels.textInput.invokeMethod<void>('TextInput.hide').then((V){
                EasyToast.showBottomToast("登陆后可使用 AI 功能");
              });
            }
          },
        ),
        Obx(()=>ONoteNavigationBarItem(
          iconData: Icons.text_fields_outlined,
          iconColor: controller.currentMenuIndexRx.value==1 ? Colors.white60 : Colors.black54,
          // iconColor:  Colors.black54,
          label:"NoteMenu:text".xtr,
          onTap: (ctx) {
            controller.switchMenuLabel(context, 1);
          },
        )),
        QuillToggleStyleButton(
          fillSelectedColor: Colors.transparent,
          attribute: Attribute.unchecked, 
          controller: controller.quillController,
          skipRequestKeyboard: false,
          childBuild: (isToggled) {
            Color iconColor = (isToggled!=null && isToggled==true) ? Colors.white : Colors.black54;
            return ONoteNavigationBarItem(
              iconData: Icons.checklist,
              iconColor: iconColor,
              label:"NoteMenu:checkAttribute".xtr,
              onTap: (ctx) {
                controller.quillController.formatSelection(isToggled!
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
            List<Operation> optList = controller.quillController.document.toDelta().toList();
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
                  int offset = controller.quillController.selection.extentOffset;
                  controller.quillController.document.insert(
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
}
