import 'package:flutter/material.dart';

class EasyButton {

  static Widget custom({
                  Axis axis = Axis.horizontal,
                  Function? onPressed,
                  Function? onLongPress,
                  AlignmentGeometry alignment=Alignment.center,
                  double? width, 
                  double? height, 
                  EdgeInsets padding=const EdgeInsets.all(0), 
                  EdgeInsets margin=const EdgeInsets.all(0), 
                  double? borderRadius, 
                  double borderWidth = 0,
                  String? text, 
                  TextDecoration? textDecoration,
                  Widget? icon,
                  IconData? iconData,
                  EdgeInsets iconPadding=const EdgeInsets.all(0), 
                  double textSize=16,
                  double iconSize=24,
                  double? iconScaleX,
                  double? iconScaleY,
                  Color? borderColor,
                  Color fillColor=Colors.transparent,
                  Color textColor=Colors.black54,
                  TextStyle? textStyle,
                  Color iconColor=Colors.black54,
                  List<Shadow>? shadows}) {
    // button height
    double buttonHeight = (axis==Axis.vertical) 
      ? iconSize + textSize 
      : (icon!=null ? iconSize : textSize) ;
    buttonHeight = buttonHeight + padding.top + padding.bottom + 4;

    // button chileren
    List<Widget> chileren = [];

    // add icon
    if (icon!=null || iconData!=null) {
      chileren.add(
        Container(
          padding: iconPadding,
          child: (iconScaleX==null && iconScaleY==null) 
            ? icon ?? Icon(iconData, color:iconColor, size: iconSize)
            : Transform.scale(
                scaleX: iconScaleX,
                scaleY: iconScaleY,
                child: icon ?? Icon(iconData, color:iconColor, size: iconSize),
            )
          )
        );
    }

    // add divid
    if (icon!=null && text!=null && axis==Axis.horizontal) {
      chileren.add(const SizedBox(width: 4));
    }

    // add text
    if (text!=null) {
      chileren.add(Text(
          text, 
          style:textStyle ?? TextStyle(
            color: textColor,
            fontSize: textSize,
            decoration: textDecoration,
            decorationThickness: textDecoration==null?0:1
          ),
          // strutStyle: StrutStyle(
          //   forceStrutHeight: true,
          //   leading: (axis==Axis.vertical) ? 0 : 0.5,
          // )
        )
      );
    }

    Widget current = Container(
      alignment: alignment,
      height: height,
      width: width,
      decoration: BoxDecoration(
        // color: fillColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius??1)),
        border: Border.all(color: borderColor??fillColor, width: borderWidth)
      ),
      child: (axis==Axis.vertical) 
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: chileren,
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: chileren,
        )
    );

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius??1)),
      child: Container(
        padding: EdgeInsets.zero,
        margin: margin,
        child: ElevatedButton(
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: WidgetStateProperty.all(Size.zero),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(fillColor),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            padding: WidgetStateProperty.all(padding),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius??1),
              )
            ),
          ),
          onPressed: onPressed==null ? null : ()=>onPressed(),
          onLongPress: onLongPress==null ? null : ()=>onLongPress(),
          child: current
        )
      )
    );
  }
}