import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/main.dart';
import 'package:onote/widget/easy_button.dart';

class EasyPopup {


  static Color get navigationBarColor1 => const Color.fromARGB(255, 72, 99, 73);
  static Color get navigationBarColor2 => Colors.green.shade200;

  static void dialog({
                      Color closeColor=Colors.black,
                      double borderRadius = 7,
                      String? title,
                      Widget? closeWidget,
                      Widget? child,
                      double? height,
                      double? width,
                      Widget? confirm,
                      Widget? cancel,
                      EdgeInsets padding = const EdgeInsets.all(15),
                      bool barrierDismissible = true,
                      Color backgroundColor=Colors.white,
                      Function(bool)? onPopInvoked}) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: ui.maskSystemNavBgColor
    // ));
    defaultDialog(
      onPopInvoked: onPopInvoked,
      confirm: confirm,
      cancel: cancel,
      barrierDismissible: barrierDismissible,
      title: "",
      titlePadding: const EdgeInsets.all(0),
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:[
          closeWidget ?? 
          Container(
            width: 30,
            height: 30,
            child: EasyButton.custom(
              iconColor: Colors.white,
              iconData:Icons.close,
              onPressed: () {
                Get.back();
              }
            )
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            child: Container(
              color: backgroundColor,
              padding: padding,
              height: height,
              width: width??ui.windowWidth*0.8,
              child: child
            )
          ),
          Container(
            width: 30,
            height: 30
          ),
        ]
      ),
      contentPadding: const EdgeInsets.all(0),
      radius: borderRadius,
      backgroundColor: Colors.transparent
    );
  }

  static void confirm(String message, {
                      Widget? messageWidget,
                      String confirmText="confirm",
                      String cancelText="close",
                      Function? onConfirm,
                      Function? onCancel,
                      Color backgroundColor=Colors.white,
                      TextStyle? confirmTextStyle,
                      TextStyle? cancelTextStyle,
                      Color? confirmBorderColor,
                      Color? cancelBorderColor,
                      String? bottomText
                      }) {
    return dialog(
      closeWidget: const SizedBox(height: 10),
      backgroundColor: backgroundColor,
      height: null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: messageWidget??SelectableText(
              message, 
              style: const TextStyle(color:Colors.black87)
            ),
          ),
          EasyButton.custom(
            borderRadius: 5,
            height: 40,
            text: confirmText,
            fillColor: ui.appNavBgColor,
            textStyle: confirmTextStyle,
            borderColor: confirmBorderColor,
            onPressed: (){
              if (onConfirm!=null) {
                onConfirm();
              }
            }
          ),
          EasyButton.custom(
            borderRadius: 5,
            height: 40,
            text: cancelText,
            textStyle: cancelTextStyle,
            borderColor: cancelBorderColor,
            onPressed: (){
              if (onCancel!=null) {
                onCancel();
              }
            }
          ),
          bottomText!=null
            ? Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: messageWidget??SelectableText(
                bottomText, 
                style: const TextStyle(color:Colors.black54)
              ),
            )
            : const SizedBox(height:0, width: 0,)
        ],
      )
    );
  }

  /// Custom UI Dialog.
  static Future<T?> defaultDialog<T>({
    String title = "Alert",
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleStyle,
    Widget? content,
    EdgeInsetsGeometry? contentPadding,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onCustom,
    Color? cancelTextColor,
    Color? confirmTextColor,
    String? textConfirm,
    String? textCancel,
    String? textCustom,
    Widget? confirm,
    Widget? cancel,
    Widget? custom,
    Color? backgroundColor,
    bool barrierDismissible = true,
    Color? buttonColor,
    String middleText = "Dialog made in 3 lines of code",
    TextStyle? middleTextStyle,
    double radius = 20.0,
    //   ThemeData themeData,
    List<Widget>? actions,

    // onWillPop Scope
    Function(bool)? onPopInvoked,

    // the navigator used to push the dialog
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    var leanCancel = onCancel != null || textCancel != null;
    var leanConfirm = onConfirm != null || textConfirm != null;
    actions ??= [];

    if (cancel != null) {
      actions.add(cancel);
    } else {
      if (leanCancel) {
        actions.add(TextButton(
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: buttonColor ?? Get.theme.colorScheme.secondary,
                    width: 2,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(100)),
          ),
          onPressed: () {
            onCancel?.call();
            Get.back();
          },
          child: Text(
            textCancel ?? "Cancel",
            style: TextStyle(
                color: cancelTextColor ?? Get.theme.colorScheme.secondary),
          ),
        ));
      }
    }
    if (confirm != null) {
      actions.add(confirm);
    } else {
      if (leanConfirm) {
        actions.add(TextButton(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: buttonColor ?? Get.theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
            child: Text(
              textConfirm ?? "Ok",
              style: TextStyle(
                  color: confirmTextColor ?? Get.theme.colorScheme.background),
            ),
            onPressed: () {
              onConfirm?.call();
            }));
      }
    }

    Widget baseAlertDialog = AlertDialog(
      titlePadding: titlePadding ?? const EdgeInsets.all(8),
      contentPadding: contentPadding ?? const EdgeInsets.all(8),
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor ?? Get.theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))
      ),
      title: Text(title, textAlign: TextAlign.center, style: titleStyle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          content ??
              Text(middleText,
                  textAlign: TextAlign.center, style: middleTextStyle),
          const SizedBox(height: 16),
          ButtonTheme(
            minWidth: 78.0,
            height: 34.0,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: actions,
            ),
          )
        ],
      ),
      // actions: actions, // ?? <Widget>[cancelButton, confirmButton],
      buttonPadding: EdgeInsets.zero,
    );

    return Get.dialog<T>(
      onPopInvoked != null
          ? PopScope(
              onPopInvokedWithResult: (didPop, result){
                onPopInvoked(didPop);
              },
              child: baseAlertDialog,
            )
          : baseAlertDialog,
      barrierDismissible: barrierDismissible,
      navigatorKey: navigatorKey
    );
  }
}