import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:onote/main.dart';
import 'package:logger/logger.dart';

class BlockEmbedTable extends q.CustomBlockEmbed {

  const BlockEmbedTable(String value) : super(noteType, value);

  static const String noteType = 'table';

  static BlockEmbedTable fromDocument(q.Document document) {
    return BlockEmbedTable(const JsonEncoder().convert(document.toDelta().toJson()));
  }

  q.Document get document => q.Document.fromJson(const JsonDecoder().convert(data));
}


class EmbedTableBuilder extends q.EmbedBuilder {

  EmbedTableBuilder({required this.addEditNote});

  Future<void> Function(BuildContext context, q.Document document) addEditNote;

  @override
  String get key => 'table';

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context, q.QuillController controller, q.Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    return Container(
      margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
      width: ui.windowWidth - 11,
      child: Table(
        border:TableBorder.all(color: Colors.black26),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: const FixedColumnWidth(80),
        children: [
          TableRow(children: [
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32)
          ]),
          TableRow(children: [
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32)
          ]),
          TableRow(children: [
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32)
          ]),
          TableRow(children: [
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32)
          ]),
          TableRow(children: [
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32),
            Container(color:Colors.transparent, height:32)
          ])
        ]
      )
    );
  }

  // void insertObject(Object object, int length) {
  //   int offset = noteEditController.quillController.selection.extentOffset;
  //   // insert table
  //   noteEditController.quillController.document.insert(offset, object);
  //   // update offset
  //   noteEditController.quillController.updateSelection(
  //     TextSelection.collapsed(offset: offset + length,),
  //     ChangeSource.local,
  //   );
  // }

  // void insertTable(int stackIndex) {
  //   insertObject(
  //     BlockEmbed.custom(
  //       BlockEmbedTable.fromDocument(noteEditController.quillController.document),
  //     ), 
  //     1
  //   );
  // }
}