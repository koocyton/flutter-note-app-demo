import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';

class CalendarEditFormController extends GetxController {

  // final calendarFormKey = GlobalKey<FormBuilderState>();
  // final titleFieldKey   = GlobalKey<FormBuilderFieldState>();
  // final detailFieldKey  = GlobalKey<FormBuilderFieldState>();
}

class CalendarEditForm extends GetView<CalendarEditFormController> {

  const CalendarEditForm({super.key});

  static Logger logger = Logger();

  @override
  CalendarEditFormController get controller => Get.put(CalendarEditFormController());

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return FormBuilder(
    //   key: controller.calendarFormKey,
    //   child: Column(
    //     children: [
    //       FormBuilderTextField(
    //         key: controller.titleFieldKey,
    //         name: '标题',
    //         decoration: const InputDecoration(labelText: '标题')
    //       ),
    //       FormBuilderTextField(
    //         minLines: 1,
    //         maxLength: 10,
    //         key: controller.detailFieldKey,
    //         name: '详细',
    //         decoration: const InputDecoration(labelText: '详细')
    //       ),
    //       FormBuilderCheckbox(
    //         title: Container(),
    //         key: controller.detailFieldKey,
    //         name: '全天',
    //         decoration: const InputDecoration(labelText: '全天')
    //       ),
    //       FormBuilderDateTimePicker (
    //         firstDate: DateTime.now(),
    //         key: controller.detailFieldKey,
    //         name: '时间',
    //         decoration: const InputDecoration(labelText: '时间')
    //       ),
    //       // ElevatedButton(
    //       //   child: const Text('Submit'),
    //       //   onPressed: () async {
    //       //   },
    //       // ),
    //     ],
    //   ),
    // );
  }
}