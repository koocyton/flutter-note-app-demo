import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:onote/main.dart';
import 'package:onote/widget/easy_button.dart';

class NoteToolbarAI extends StatefulWidget {

  final q.QuillController quillController;

  const NoteToolbarAI({
    required this.quillController,
    super.key
  });

  @override
  State<NoteToolbarAI> createState() => _NoteToolbarAIState();
}

class _NoteToolbarAIState extends State<NoteToolbarAI> {

  @override
  Widget build(BuildContext context) {
    double btnWidth = (ui.windowWidth - 33) / 2;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      physics: ui.physics,
      child: Container(
        alignment: Alignment.center,
        color:Colors.green.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"文生图", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"图生文", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"写文章", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"提问/查询", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"翻译", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"实时译", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"写报告", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"数据图", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"生成音乐", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"随手拍", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
                const SizedBox(width: 10),
                EasyButton.custom(text:"...", borderRadius: 4, height:50, fillColor: Colors.green.shade200, width: btnWidth),
              ],
            ),
          ]
        )
      )
    );
  }


}
