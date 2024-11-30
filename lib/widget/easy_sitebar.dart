
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum EasySidebarAlign {
  left,
  right
}

class EasySidebarController extends GetxController {

  final RxBool sidebarSwitchRx = false.obs;

  final double sidebarWidth;

  final ScrollController scrollController = ScrollController(initialScrollOffset:0); 

  final EasySidebarAlign align;

  EasySidebarController({required this.align, required this.sidebarWidth});

  Future<void> switchSidebar({bool? sidebarSwitch}) {
    sidebarSwitchRx.value = sidebarSwitch??!sidebarSwitchRx.value;
    return scrollController.animateTo(
      sidebarSwitchRx.value ? sidebarWidth : 0, 
      duration: const Duration(milliseconds: 120), 
      curve: Curves.easeOut
    );
  }
}

class EasySidebar extends GetView<EasySidebarController> {

  @override
  final EasySidebarController controller;

  final Widget sidebar;

  final Widget child;

  final EasySidebarAlign? align;

  const EasySidebar({required this.controller, required this.sidebar, this.align, required this.child,  super.key});

  static Logger logger = Logger();

  static NeverScrollableScrollPhysics physics = const NeverScrollableScrollPhysics();
  
  @override
  Widget build(BuildContext context) {
    final Size contextSize = MediaQuery.of(context).size;
    final double contextWidth = contextSize.width;
    final double contextHeight = contextSize.height;

    return Obx(()=>PopScope(
      canPop: controller.sidebarSwitchRx.isFalse,
      onPopInvokedWithResult: (b, o){
        if (controller.sidebarSwitchRx.isTrue) {
          controller.switchSidebar(sidebarSwitch: false);
        }
      },
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.scrollController,
        scrollDirection: Axis.horizontal,
        reverse: align==EasySidebarAlign.left,
        children: [
          Container(
            width: contextWidth,
            height: contextHeight,
            color:Colors.black54,
            child: Stack(
              alignment:Alignment.topCenter,
              fit: StackFit.expand,
              children: [
                child,
                controller.sidebarSwitchRx.value
                  ? GestureDetector(
                      onTap: (){
                        controller.switchSidebar(sidebarSwitch:false);
                      },
                      child:Container(
                        height: contextHeight,
                        width: contextWidth,
                        alignment: Alignment.center,
                        color:Colors.black12
                      )
                    )
                  : const SizedBox(width: 0, height: 0)
              ]
            )
          ),
          SizedBox(
            width: controller.sidebarWidth,
            height: contextHeight,
            child: sidebar
          )
        ]
      )
    ));
  }
}