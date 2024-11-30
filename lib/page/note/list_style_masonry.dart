import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:onote/main.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/object/entity/note.dart';
import 'package:onote/page/note/note_page.dart';

class ListStyleMasonry extends GetView<NotePageController> {

  final ScrollPhysics scrollPhysics;

  const ListStyleMasonry({required ScrollPhysics this.scrollPhysics,  super.key});

  static Logger logger = Logger();

  @override
  NotePageController get controller => Get.find<NotePageController>();

  @override
  Widget build(BuildContext context) {
    double width = (ui.windowWidth-40)/2;
    return MasonryGridView.count(
      physics: scrollPhysics,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 16,
      padding: EdgeInsets.fromLTRB(10, ui.headHeight + 10, 10, ui.footHeight + 10),
      // padding: EdgeInsets.fromLTRB(19, ui.headHeight + 19, 19, ui.footHeight + 19),
      itemCount: controller.notesRx.length + 2,
      itemBuilder: (_context, _index) {
        if (_index==0) {
          return Container(height:40);
        }
        else if (_index==1) {
          return Container(
            height: 40,
            alignment: Alignment.centerRight,
            child: NotePage.listStyleSelector(controller)
          );
        }
        int index = _index - 2;
        Note note = controller.notesRx[index];
        String contentText = controller.contentText(note.content);
        int l = 1;
        for (int ii=0; ii<contentText.length; ii++) {
          if (contentText[ii]=="\n") {
            l++;
          }
        }
        double height = l * 18;
        height = height<45 ? 45 : (height>width*1.2 ? width*1.2 : height);
        return LongPressDraggable(
          delay: const Duration(milliseconds: 500),
          feedback: SizedBox(
            width: width,
            height: height,
            child: _draggableChild2(index, note, dragging: false)
          ),
          childWhenDragging: SizedBox(
            width: width,
            height: height,
            child: _draggableChild2(index, note, dragging: true)
          ),
          onDragStarted: () {
            controller.deleteDragging.value = true;
            controller.notesRx.refresh();
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
              controller.notesRx.refresh();
            }
          },
          child: SizedBox(
            width: width,
            height: height,
            child: _draggableChild2(index, note)
          )
        );
      }
    );
  }

  Widget _draggableChild2(int index, Note note, {bool dragging=false}) {
    String contentText = controller.contentText(note.content);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(1)),
      child: GestureDetector(
        onTap:(){
          controller.openEditNote(index, note);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color : dragging ? Colors.transparent: Colors.white,
            // border: Border.all(width: dragging ? 1: 2)
          ),
          child:Text(dragging?"":controller.noteContent(contentText), style: TextStyle(fontSize: dragging ? 12 : 13)),
        )
      )
    );
  }
}