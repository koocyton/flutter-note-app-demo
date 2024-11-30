import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onote/page/note_edit_plus/note_plus_edit_page.dart';
import 'package:onote/page/note_edit_plus/note_plus_toolbar_utils.dart';

class NotePlusToolbar extends StatefulWidget {

  final NotePlusEditController controller;

  const NotePlusToolbar({
    required this.controller,
    super.key
  });

  @override
  State<NotePlusToolbar> createState()=>NotePlusToolbarState();
}

class NotePlusToolbarState extends State<NotePlusToolbar> {

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      alignment: Alignment.center,
      index: widget.controller.currentMenuLabel,
      children: [
        const SizedBox(),
        NotePlusToolbarUtils(controller: widget.controller),
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.setToolbarState = (fn){
      if (mounted) {
        setState(fn);
      }
    };
  }

  @override
  void dispose() {
    widget.controller.setToolbarState = (fn)=>null;
    super.dispose();
  }
}
