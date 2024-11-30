import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:logger/logger.dart';
import 'package:onote/main.dart';
import 'package:onote/page/note_edit/note_edit_page.dart';
import 'package:onote/page/note_edit/quill_button.dart';
import 'package:flutter_quill/src/common/utils/color.dart';

class NoteToolbarUtils extends GetView<NoteEditController> {

  final leftRadius   = const BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(0));
  final rightRadius  = const BorderRadius.horizontal(left: Radius.circular(0), right: Radius.circular(10));
  final colorRadius  = BorderRadius.circular(15);
  final centerRadius  = BorderRadius.circular(0);
  final fillUnselectedColor = Colors.white60;
  
  List<String> get textColorList => ["", "red", "amber", "yellow", "teal", "orange", "indigo", "green", "blue", "brown"];

  List<String> get bgColorList => ["", "white", "red", "redAccent", "amber", "amberAccent", "yellow", "yellowAccent", "teal", "tealAccent", "purple", "purpleAccent", "pink", "pinkAccent", "orange", "orangeAccent", "deepOrange", "deepOrangeAccent", "indigo", "indigoAccent", "lime", "limeAccent", "grey", "blueGrey", "green", "greenAccent", "lightGreen", "lightGreenAccent", "blue", "blueAccent", "lightBlue", "lightBlueAccent", "cyan", "cyanAccent"];

  @override
  NoteEditController get controller => Get.find<NoteEditController>();

  NoteToolbarUtils({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color:Colors.green.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        physics: ui.physics,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            const SizedBox(height:10),
            textSize(),
            const SizedBox(height:20),
            textStyle(),
            const SizedBox(height:20),
            textList(),
            const SizedBox(height:20),
            fontSize(),
            const SizedBox(height:20),
            textColor(),
            const SizedBox(height:20),
            fillColor(),
            const SizedBox(height:10),
          ]
        )
      )
    );
  }

  Widget textSize() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        quillButton(label:"标题", labelSize: 26, attribute:q.Attribute.h1),
        const SizedBox(width:20),
        quillButton(label:"小标题", labelSize: 21, attribute:q.Attribute.h2),
        const SizedBox(width:15),
        quillButton(label:"副标题", labelSize: 16, attribute:q.Attribute.h3),
        const SizedBox(width:0),
        quillButton(label:"正文", attribute:q.Attribute.header),
        const SizedBox(width:0),
        quillButton(label:"等宽", labelSize: 16, attribute:const q.FontAttribute("monospace")),
      ]
    );
  }

  Widget textStyle() {
    double width = (ui.windowWidth - 23) / 7;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        quillButton(iconData:Icons.format_bold, width:width, attribute:q.Attribute.bold, borderRadius: leftRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width: 0.5),
        quillButton(iconData:Icons.format_italic, width:width, attribute:q.Attribute.italic, borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width: 0.5),
        quillButton(iconData:Icons.format_underline, width:width, attribute:q.Attribute.underline, borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width: 0.5),
        quillButton(iconData:Icons.strikethrough_s, width:width, attribute:q.Attribute.strikeThrough, borderRadius: rightRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:4.5),
        quillButton(iconData:Icons.format_quote, width:width, attribute:q.Attribute.blockQuote, borderRadius: leftRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(iconData:Icons.code, width:width, attribute:q.Attribute.codeBlock, borderRadius: rightRadius, fillUnselectedColor: fillUnselectedColor)
      ]
    );
  }

  Widget textList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        quillButton(iconData:Icons.format_list_bulleted, attribute:q.Attribute.ul, borderRadius: leftRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(iconData:Icons.format_list_numbered, attribute:q.Attribute.ol, borderRadius: rightRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:4.5),
        quillButton(iconData:Icons.format_align_left, attribute:q.Attribute.leftAlignment, borderRadius: leftRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(iconData:Icons.format_align_center, attribute:q.Attribute.centerAlignment, borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(iconData:Icons.format_align_right, attribute:q.Attribute.rightAlignment, borderRadius: rightRadius, fillUnselectedColor: fillUnselectedColor)
      ]
    );
  }

  Widget fontSize() {
    double width = (ui.windowWidth - 40) / 7;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        quillButton(label:"35", labelSize: 35, width: width, attribute:const q.SizeAttribute("35"), borderRadius: leftRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(label:"26", labelSize: 26, width: width, attribute:const q.SizeAttribute("26"), borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(label:"22", labelSize: 22, width: width, attribute:const q.SizeAttribute("22"), borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(label:"18", labelSize: 18, width: width, attribute:const q.SizeAttribute("18"), borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(label:"16", labelSize: 16, width: width, attribute:const q.SizeAttribute("16"), borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(label:"14", labelSize: 14, width: width, attribute:const q.SizeAttribute("14"), borderRadius: centerRadius, fillUnselectedColor: fillUnselectedColor),
        const SizedBox(width:0.5),
        quillButton(label:"12", labelSize: 12, width: width, attribute:const q.SizeAttribute("12"), borderRadius: rightRadius, fillUnselectedColor: fillUnselectedColor)
      ]
    );
  }

  Widget textColor() {
    double width = (ui.windowWidth - 30) / textColorList.length;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: fillUnselectedColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: textColorList.map((colorString){
          if (colorString=="") {
            colorString = "black";
          }
          return quillButton(
            label:"A", 
            labelSize: 24,
            width: width,
            height: 40,
            attribute: q.ColorAttribute(colorString),
            color: stringToColor(colorString),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            fillSelectedColor: Colors.white,
            selectedBorder: Border.all(color: const Color(0x13000000), width: 1),
            unselectedBorder: Border.all(color: Colors.transparent, width: 1),
          );
        }).toList()
      )
    );
  }

  Widget fillColor() {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: fillUnselectedColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Wrap(
        children: bgColorList.map((colorString){
          if (colorString=="") {
            colorString = "transparent";
          }
          return colorButton(
            icon:Icons.square,
            attribute:q.BackgroundAttribute(colorString),
            color: stringToColor(colorString)
          );
        }).toList(),
      )
    );
  }

  Widget colorButton({required IconData? icon,
                      required Color color,
                      double size = 30,
                      required q.Attribute attribute}) {
    double radius = q.Attribute.color.key== attribute.key ? 20 : 1;
    BorderRadius borderRadius = BorderRadius.all(Radius.circular(radius));
    Color borderColor = (color.isLight || color==Colors.transparent) ? Colors.black : Colors.white;
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      // padding: const EdgeInsets.all(2),
      child: QuillToggleStyleButton(
        width: size,
        height: size,
        fillSelectedColor: color,
        fillUnselectedColor: Colors.transparent,
        attribute: attribute, 
        controller: controller.quillController,
        childBuild: (isToggled) {
          return Container(
            alignment: Alignment.center,
            width: size - 5,
            height: size - 5,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color : color==Colors.transparent ? Colors.white : color,
              border: (isToggled!=null && isToggled==true) 
                ? Border.all(color: borderColor, width: 1)
                : Border.all(color: Colors.transparent, width: 1),
            ),
            child: color==Colors.transparent
              ? SvgPicture.asset(
                "assets/svg/transparent-icon.svg",
                width: size - 9,
                height: size - 9,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.srcIn)
              )
              : null
          );
        } 
      )
    );
  }

  Widget quillButton({String? label,
                      double labelSize=14,
                      FontWeight labelWeight=FontWeight.normal,
                      IconData? iconData,
                      Color? color,
                      double? iconSize,
                      double? width,
                      double? height,
                      Color fillUnselectedColor=Colors.transparent,
                      Color? fillSelectedColor,
                      BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
                      BoxBorder? selectedBorder,
                      BoxBorder? unselectedBorder,
                      required q.Attribute attribute}) {
    return QuillToggleStyleButton(
      width: width ?? (ui.windowWidth - 60) / 5,
      height: height ?? 50,
      fillUnselectedColor: fillUnselectedColor,
      fillSelectedColor: fillSelectedColor??const Color.fromARGB(255, 154, 203, 133),
      borderRadius: borderRadius,
      selectedBorder:selectedBorder,
      unselectedBorder:unselectedBorder,
      attribute: attribute, 
      controller: controller.quillController,
      childBuild: (isToggled) {
        Color kolor = color ?? ((isToggled!=null && isToggled==true) ? Colors.white : Colors.black87);
        return label!=null 
          ? Text(label, style:TextStyle(fontSize: labelSize, color:kolor))
          : Icon(iconData, size: iconSize ?? 20, color:kolor);
      } 
    );
  }
}
