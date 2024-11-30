import 'package:flutter/material.dart';
import 'package:onote/main.dart';
import 'package:onote/page/sidebar/main_sidebar.dart';
import 'package:onote/page/note/note_page.dart';
import 'package:onote/widget/easy_sitebar.dart';
import 'package:get/get.dart';
import 'package:onote/widget/onote_scaffold.dart';

class MainPageController extends GetxController {

  final Rx<int> currentIndex = 0.obs;

  final EasySidebarController sidebarController = EasySidebarController(align: EasySidebarAlign.right, sidebarWidth: ui.windowWidth * 0.618);

}

class MainPage extends GetView<MainPageController> {

  const MainPage({super.key});

  @override
  MainPageController get controller => Get.put(MainPageController());

  @override
  Widget build(BuildContext context){
    return EasySidebar(
      controller: controller.sidebarController,
      sidebar: const MainSidebar(),
      child : const NotePage()
    );
  }

  ONoteNavigationBar navigationBar() {
    return ONoteNavigationBar(
      backgroundColor: ui.appNavBgColor,
      onTap: (ii) {
        controller.currentIndex.value = ii;
      },
      items: const [
        ONoteNavigationBarItem(
          iconData: Icons.note_outlined,
          label:"notes"
        ),
        ONoteNavigationBarItem(
          iconData: Icons.calendar_month_outlined,
          label:"calendar"
        ),
        ONoteNavigationBarItem(
          iconData: Icons.pageview_outlined,
          label:"share"
        ),
        ONoteNavigationBarItem(
          iconData: Icons.person_outline,
          label:"me"
        )
      ]
    );
  }
}