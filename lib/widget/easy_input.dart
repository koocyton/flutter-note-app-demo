import 'package:flutter/material.dart';
import 'package:onote/main.dart';

class EasyInput {

  static InputBorder get transparentUnderline => const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
  );

  static Widget input({
                       FocusNode? focusNode,
                       TextEditingController? controller,
                       TextInputType keyboardType = TextInputType.text,
                       String? labelText,
                       int? maxLength,
                       String? hintText,
                       bool readOnly = false,
                       Color? hintTextColor,
                       Icon? prefixIcon,
                       Color? prefixIconColor,
                       double? textSize,
                       bool isPassword=false,
                       TextInputAction? textInputAction,
                       Function(String)? onSubmitted,
                       InputDecoration? decoration,
                       InputBorder? decorationInputBorder,
                       InputBorder? decorationfocusedBorder
                        }) {
    return TextField(
      obscureText:isPassword,
      scrollPadding: EdgeInsets.zero,
      focusNode:focusNode,
      controller:controller,
      keyboardType: keyboardType,
      cursorColor:Colors.black,
      style: TextStyle(
        fontSize: textSize,
      ),
      readOnly: readOnly,
      textInputAction: textInputAction??TextInputAction.newline,
      onSubmitted: onSubmitted,
      maxLines: 1,
      maxLength: maxLength,
      decoration: decoration??InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: hintTextColor),
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black12
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black12
          ),
        )
      )
    );
  }

  static Widget text({
                       FocusNode? focusNode,
                       TextEditingController? controller,
                       String? labelText,
                       String? hintText,
                       Icon? prefixIcon,
                       double? textSize,
                       TextInputAction? textInputAction,
                       Function(String)? onSubmitted,
                       Function(String)? onChanged,
                       Function()? onEditingComplete,
                       int? maxLines,
                       int? minLines,
                       EdgeInsets? contentPadding,
                       EdgeInsets? scrollPadding,
                       bool isCollapsed=false,
                       Function? onTap
                      }) {
    return TextField(
      onTap: (){
        if (onTap!=null) {
          onTap();
        }
      },
      scrollPhysics: ui.physics,
      focusNode:focusNode,
      controller:controller,
      keyboardType:TextInputType.multiline,
      cursorColor:Colors.black,
      style: TextStyle(
        fontSize: textSize,
      ),
      textInputAction: textInputAction??TextInputAction.newline,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      minLines: minLines??1,
      maxLines: maxLines??40,
      scrollPadding: scrollPadding ?? EdgeInsets.zero,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        isCollapsed: isCollapsed,
        hintMaxLines: 40,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        enabledBorder: transparentUnderline,
        focusedBorder: transparentUnderline,
      )
    );
  }
}