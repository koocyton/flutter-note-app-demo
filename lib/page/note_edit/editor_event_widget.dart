import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class EditorEventWidget extends StatefulWidget {

  final Widget Function(double bottomMargin)? childBuild;

  final Widget? child;

  final Function(double bottomMargin)? onKbShowBegin;

  final Function(double bottomMargin)? onKbShowEnd;

  final Function(double bottomMargin)? onKbShowing;

  final Function(double bottomMargin)? onKbHideBegin;

  final Function(double bottomMargin)? onKbHideEnd;

  final Function(double bottomMargin)? onKbHiding;

  final Function(double bottomMargin)? onKbSliding;

  const EditorEventWidget({
    // build child
    this.childBuild,
    this.child,
    // show
    this.onKbShowBegin,
    this.onKbShowing,
    this.onKbShowEnd,
    // hide
    this.onKbHideBegin,
    this.onKbHiding,
    this.onKbHideEnd,
    // sliding
    this.onKbSliding,
    super.key
  });

  @override
  State<EditorEventWidget> createState() => EditorEventWidgetState();
}

class EditorEventWidgetState extends State<EditorEventWidget> with WidgetsBindingObserver {

  // now viewInsetsBottom
  double nowVIB = 0;

  // prev viewInsetsBottom
  double preVIB = 0;

  bool isKbHiding = false;

  bool isKbShowing = false;

  bool isKbShowEnd = false;

  Timer? timer;

  Duration timeStamp = const Duration(milliseconds: 0);

  final Duration checkEndDelay = const Duration(milliseconds: 200);

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    if (widget.child!=null) {
      return widget.child!;
    }
    else if (widget.childBuild!=null) {
      return widget.childBuild!(nowVIB);
    }
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  // 监听
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (timeStamp.toString()==t.toString()) {
        // debugPrint(" == t $t nowVIB $nowVIB preVIB $preVIB");
        return;
      }
      nowVIB = MediaQuery.of(context).viewInsets.bottom;
      // debugPrint(" != t $t : $timeStamp / $nowVIB : $preVIB");
      // show begin
      if (nowVIB > preVIB && preVIB <= 0) {
        setKbShowingStatus();
        if (widget.onKbShowBegin!=null) {
          widget.onKbShowBegin!(0);
        }
      }
      // Showing
      else if (isKbShowing) {
        if(nowVIB>preVIB) {
          setKbShowingStatus();
          if (widget.onKbShowing!=null) {
            widget.onKbShowing!(nowVIB);
          }
          kbShowEnd();
        }
      }
      // hide begin // bottomMargin>270
      else if (nowVIB < preVIB && !isKbHiding) {
        setKbHidingStatus();
        if (widget.onKbHideBegin!=null) {
          widget.onKbHideBegin!(nowVIB);
        }
      }
      else if (isKbHiding) {
        setKbHidingStatus();
        if(nowVIB<preVIB) {
          if (widget.onKbHiding!=null) {
            widget.onKbHiding!(nowVIB);
          }
          if (nowVIB<=0) {
            if (widget.onKbHideEnd!=null) {
              widget.onKbHideEnd!(0);
            }
          }
        }
      }
      // other
      if (widget.onKbSliding!=null) {
        widget.onKbSliding!(nowVIB);
      }
      preVIB = nowVIB;
      timeStamp = t;
    });
  }

  void kbShowEnd() {
    if (timer==null) {
      timer = Timer(const Duration(milliseconds: 14), () {
        kbShowEnd();
      });
      return;
    }
    if (nowVIB==preVIB) {
      resetStatus();
      if (widget.onKbShowEnd!=null) {
        widget.onKbShowEnd!(nowVIB);
      }
    }
  }

  void resetStatus() {
    if (timer!=null && timer!.isActive) {
      timer!.cancel();
    }
    timer = null;
    isKbShowing = false;
    isKbHiding = false;
  }

  void setKbShowingStatus() {
    if (timer!=null && timer!.isActive) {
      timer!.cancel();
    }
    timer = null;
    isKbShowing = true;
    isKbHiding = false;
  }

  void setKbHidingStatus() {
    if (timer!=null && timer!.isActive) {
      timer!.cancel();
    }
    timer = null;
    isKbShowing = false;
    isKbHiding = true;
  }
}