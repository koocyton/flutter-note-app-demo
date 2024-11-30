import 'package:flutter/material.dart';
import 'package:onote/main.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/onote_scaffold.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/src/intl/date_format.dart';

class CalendarEditController extends GetxController {

  // final _formKey = GlobalKey<FormBuilderState>();
  // final _titleFieldKey = GlobalKey<FormBuilderFieldState>();
  // final _itemFieldKey = GlobalKey<FormBuilderFieldState>();
  // final _dateFieldKey = GlobalKey<FormBuilderFieldState>();
}

class CalendarEditPage extends GetView<CalendarEditController> {

  const CalendarEditPage({super.key});

  static Logger logger = Logger();

  @override
  CalendarEditController get controller => Get.put(CalendarEditController());

  @override
  Widget build(BuildContext context) {
    return ONoteScaffold(
      appBar : appBar(),
      resizeBody : Container(
        color : ui.bgColor,
        child : SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, ui.headHeight + 10, 10, 10),
          physics: ui.physics,
          child: body()
        )
      )
    );
  }

  Widget body() {
    return const SizedBox();
    // return FormBuilder(
    //   key: controller._formKey,
    //   child: Column(
    //     children: [
    //       FormBuilderTextField(
    //         key: controller._titleFieldKey,
    //         name: 'title',
    //         style: const TextStyle(fontSize: 20),
    //         cursorColor: Colors.black,
    //         decoration: const InputDecoration(labelText: '标题'),
    //         validator: (a){
    //           return "";
    //         },
    //       ),
    //       const SizedBox(height: 10),
    //       FormBuilderTextField(
    //         key: controller._itemFieldKey,
    //         name: 'item',
    //         cursorColor: Colors.black,
    //         decoration: const InputDecoration(labelText: '详细'),
    //         validator: (a){
    //           return "";
    //         },
    //       ),
    //       const SizedBox(height: 10),
    //       FormBuilderDateTimePicker(
    //         initialDate: DateTime.now(),
    //         format: DateFormat('yyyy-MM-dd HH:mm:ss'),
    //         key: controller._dateFieldKey,
    //         name: 'date',
    //         cursorColor: Colors.black,
    //         decoration: const InputDecoration(labelText: '时间'),
    //         validator: (a){
    //           return "";
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  ONoteAppBar appBar() {
    return ONoteAppBar(
      closeIconData: Icons.close,
      backgroundColor: ui.bgColor,
      title: Text("", style:TextStyle(color:Colors.green.shade900, fontWeight: FontWeight.bold, fontSize: 23)),
      actions: [
        EasyButton.custom(
          text:"保存", 
          textSize: 12,
          fillColor: ui.appNavBgColor, 
          height: 30, 
          borderRadius: 15, 
          padding: const EdgeInsets.fromLTRB(13, 0, 13, 0)
        )
      ],
    );
  }
}