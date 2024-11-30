import 'package:flutter/material.dart';
import 'package:onote/main.dart';
import 'package:get/get.dart';
import 'package:onote/page/note_edit/editor_event_widget.dart';

class EasyUI {

  static Widget twoColorText({String? text1, String? text2, Color color1=Colors.blueGrey, Color color2=Colors.white, double fontSize=30}) {
    return RichText(
      text: TextSpan(
        text: text1,
        style: TextStyle(color: color1, fontSize: fontSize, fontWeight: FontWeight.w900),
        children:[
          TextSpan(text: text2, 
            style: TextStyle(
              color: color2,
              fontSize: fontSize, 
              fontWeight: FontWeight.w900
            )
          )
        ]
      )
    );
  }

  static void showBottomModal({BuildContext? context,
                               EdgeInsets padding = const EdgeInsets.all(0),
                               EdgeInsets margin = const EdgeInsets.all(0),
                               double? height,
                               double? width,
                               bool showDragHandle = false,
                               String? title,
                               Color? titleColor,
                               FontWeight? titleWeight,
                               double? titleSize,
                               TextStyle? titleStyle,
                               bool resizeToAvoidBottomInset = false,
                               bool enableDrag = false,
                               Color backgroundColor = Colors.white,
                               bool showCloseButton = true,
                               double shapeTopborderRadius = 10,
                               double shapeBottomborderRadius = 0,
                               Widget child = const SizedBox()}) {
    // column child
    child = Column(
      children:[
        Row(
          children:[
            const SizedBox(height: 10, width: 40),
            Expanded(child: title!=null
              ? Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(title, style: titleStyle??TextStyle(color: titleColor, fontWeight: titleWeight, fontSize: titleSize))
                )
              : Container(height: 10)
            ),
            showCloseButton 
              ? GestureDetector(
                  onTap: ()=>Get.back(),
                  child: Container(
                    height: 20,
                    width: 20,
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color:Color(0x13000000),
                    ),
                    alignment: Alignment.center,
                    child:const Icon(Icons.keyboard_arrow_down_outlined, color:Colors.black54, size: 18)
                  )
                )
              : const SizedBox(height: 10, width: 50)
          ]
        ),
        Expanded(
          child: child
        )
      ]
    );

    BoxDecoration decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(shapeTopborderRadius, shapeTopborderRadius),
        topRight: Radius.elliptical(shapeTopborderRadius, shapeTopborderRadius),
        bottomLeft: Radius.elliptical(shapeBottomborderRadius, shapeBottomborderRadius),
        bottomRight: Radius.elliptical(shapeBottomborderRadius, shapeBottomborderRadius),
      )
    );

    // show
    showModalBottomSheet(
      isScrollControlled: true, 
      showDragHandle: false,
      enableDrag: enableDrag,
      context: context ?? Get.overlayContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return resizeToAvoidBottomInset
          ? EditorEventWidget(childBuild: (bottomInset) {
              return Container(
                height: height ?? ui.windowHeight*0.618,
                width: width ?? ui.windowWidth,
                padding: padding,
                margin: EdgeInsets.fromLTRB(
                  margin.left,
                  margin.top,
                  margin.right,
                  margin.bottom + bottomInset
                ),
                decoration: decoration,
                child: child
              );
            })
          : Container(
              height: height ?? ui.windowHeight*0.618,
              width: width ?? ui.windowWidth,
              padding: padding,
              margin: margin,
              decoration: decoration,
              child: child
            );
      }
    );
  }
}