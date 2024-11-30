import 'package:flutter/material.dart';
import 'package:onote/main.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/object/entity/note.dart';
import 'package:onote/page/note/note_page.dart';

class ListStyleTimeline extends GetView<NotePageController> {

  final ScrollPhysics scrollPhysics;

  const ListStyleTimeline({required this.scrollPhysics,  super.key});

  static Logger logger = Logger();

  @override
  NotePageController get controller => Get.find<NotePageController>();

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [
      Container(
        height: 40,
        width: ui.windowWidth,
        alignment: Alignment.centerRight,
        child: NotePage.listStyleSelector(controller)
      )
    ];
    int year = 0;

    List<Widget> rowList = [];
    List<Widget> columnList = [];

    int maxCount = controller.notesRx.length;
    for(int ii=0; ii<maxCount; ii++) {
      Note note = controller.notesRx[ii];
      if (note.createTime==null) {
        continue;
      }
      // year block
      if (year!=note.createTime!.year) {
        year = note.createTime!.year;
        if (columnList.isNotEmpty) {
          widgetList.add(Column(children: columnList));
          columnList = [];
        }
        widgetList.add(const SizedBox(height: 20));
        widgetList.add(
          Text("$year", style:const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 27))
        );
        widgetList.add(const SizedBox(height: 20));
      }
      // note in year
      rowList.add(_gridStyleNote(context, ii, note));
      int mm = rowList.length;
      if ((mm+1)%3!=0) {
        rowList.add(const SizedBox(width: 10));
      }
      if ((mm+1)%3==0 || ii+1>=maxCount || year != controller.notesRx[ii+1].createTime!.year) {
        columnList.add(
          SizedBox(
            height:197,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: rowList,
            )
          ),
        );
        columnList.add(const SizedBox(height:10));
        rowList = [];
      }
    }
    // last note in year
    widgetList.add(Column(children: columnList));
    widgetList.add(const SizedBox(height: 20));
    return SizedBox(
      height:ui.windowHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, ui.headHeight + 10, 10, ui.footHeight + 10),
        physics: scrollPhysics,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList
        )
      )
    );
  }

  Widget _gridStyleNote(BuildContext context, int index, Note note) {
    return LongPressDraggable(
      delay: const Duration(milliseconds: 500),
      feedback: _draggableFeedback(note),
      childWhenDragging: _draggingChild(note),
      onDragStarted: () {
        controller.deleteDragging.value = true;
      },
      onDragUpdate: (b) {
        controller.deleteDraggingInPlace.value = (ui.windowHeight-b.localPosition.dy < 230);
      },
      onDraggableCanceled:(velocity, offset){
        if (ui.windowHeight-offset.dy < 230) {
          controller.deleteNote(index);
        }
        else {
          controller.deleteDraggingInPlace.value = false;
          controller.deleteDragging.value = false;
        }
      },
      child: SizedBox(
        width: (ui.windowWidth-40)/3,
        height: (ui.windowWidth-40)/1.8,
        child: _draggableChild(index, note)
      )
    );
  }

  Widget _draggableFeedback(Note note) {
    String contentText = controller.contentText(note.content);
    return Column(
      children:[
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
          width: (ui.windowWidth-40)/3,
          height: (ui.windowWidth-40)/2.5,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color : Colors.white,
            border: Border.all(color: ui.bgColor, width: 1)
          ),
          child:Text(controller.noteContent(contentText), style:TextStyle(fontSize: 14)),
        ),
        Text(controller.noteTitle(contentText), style:TextStyle(color:Colors.green.shade900, fontSize: 14)),
        Text(note.createTime!.toIso8601String().substring(0, 10), style: const TextStyle(color:Colors.grey))
      ]
    );
  }

  Widget _draggingChild(Note note) {
    return Column(
      children:[
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
          width: (ui.windowWidth-40)/3,
          height: (ui.windowWidth-40)/2.6,
        ),
        const Text("", style: TextStyle(color:Colors.black54, fontSize: 13)),
        const Text("", style: TextStyle(color:Colors.grey, fontSize: 12))
      ]
    );
  }

  Widget _draggableChild(int index, Note note) {
    String contentText = controller.contentText(note.content);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(1)),
      child: GestureDetector(
        onTap:(){
          controller.openEditNote(index, note);
        },
        child: Column(
          children:[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
              width: (ui.windowWidth-40)/3,
              height: (ui.windowWidth-40)/2.6,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color : Colors.white,
                border: Border.all(color: Colors.black12, width: 1)
              ),
              child:Text(controller.noteContent(contentText), style:const TextStyle(fontSize: 12)),
            ),
            Text(controller.noteTitle(contentText), style: const TextStyle(color:Colors.black54, fontSize: 13)),
            Text(note.createTime!.toIso8601String().substring(0, 10), style: const TextStyle(color:Colors.grey, fontSize: 12))
          ]
        )
      )
    );
  }
}