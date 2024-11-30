// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:onote/i18n/translation_service.dart';
// import 'package:onote/main.dart';
// import 'package:onote/widget/easy_button.dart';
// import 'package:onote/widget/easy_ui.dart';
// import 'package:onote/widget/onote_scaffold.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// class CalendarController extends GetxController {

//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

//   final Rx<int> currentYear = 0.obs;
//   final Rx<int> currentMonth = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     itemPositionsListener.itemPositions.addListener(() {
//       ItemPosition first = itemPositionsListener.itemPositions.value.first;
//       int firstIndex = first.index;
//       if (first.itemTrailingEdge < ui.bodyTrailingEdge) {
//         firstIndex = firstIndex + 1;
//       }
//       currentYear.value = (firstIndex/12).floor() + 1900;
//       currentMonth.value = (firstIndex % 12) + 1;
//     });
//   }
// }

// class CalendarPage extends GetView<CalendarController> {

//   const CalendarPage({super.key});

//   @override
//   CalendarController get controller => Get.put(CalendarController());

//   @override
//   Widget build(BuildContext context) {
//     int monthCount = 2400;
//     int currentMonthIndex = (DateTime.now().year - 1900) * 12 + DateTime.now().month - 1;
//     return ONoteScaffold(
//       appBar : appBar(),
//       floatingActionButton: floatingActionButton(),
//       fixBody : Container(
//         height: ui.windowHeight,
//         color : ui.bgColor,
//         child: ScrollablePositionedList.builder(
//           itemScrollController: controller.itemScrollController,
//           itemPositionsListener: controller.itemPositionsListener,
//           padding: EdgeInsets.fromLTRB(10, ui.headHeight + 10, 10, ui.footHeight + 10),
//           physics: ui.physics,
//           itemCount: monthCount,
//           initialScrollIndex: currentMonthIndex + 1,
//           itemBuilder: (context, index){
//             return yearMonth((index/12).floor() + 1900, (index % 12) + 1);
//           },
//         )
//       )
//     );
//   }

//   Widget floatingActionButton() {
//     return EasyButton.custom(
//       iconData: Icons.event_available_outlined,
//       iconSize: 30,
//       fillColor: Colors.green.shade300,
//       width: ui.floatingButtonWidth,
//       height: ui.floatingButtonWidth,
//       borderRadius: ui.floatingButtonWidth,
//       onTap: (){
//           Get.toNamed("/page/createCalendar");
//       }
//     );
//   }

//   Widget yearMonth(int year, int month) {
//     String mmonth = (month<10) ? "0$month" : "$month";
//     return Column(
//       key: Key("$year-$month"),
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text("$year 年 $mmonth 月", 
//           style: const TextStyle(
//             color: Colors.black54,
//             fontWeight: FontWeight.bold,
//             fontSize: 22
//           ),
//           strutStyle: const StrutStyle(
//             forceStrutHeight: true,
//             leading: 0.5,
//           )
//         ),
//         const SizedBox(height: 20),
//         oneTodo(iconData: Icons.alarm, dateTime:DateTime.parse("$year-$mmonth-01 00:23:12"), text:"起"),
//         const SizedBox(height: 10),
//         oneTodo(iconData: Icons.alarm, dateTime:DateTime.parse("$year-$mmonth-05 01:34:54"), text:"吃药"),
//         const SizedBox(height: 10),
//         oneTodo(iconData: Icons.alarm, dateTime:DateTime.parse("$year-$mmonth-09 03:23:34"), text:"开会了"),
//         const SizedBox(height: 10),
//         oneTodo(iconData: Icons.alarm, dateTime:DateTime.parse("$year-$mmonth-11 04:43:23"), text:"老婆面膜"),
//         const SizedBox(height: 10),
//         oneTodo(iconData: Icons.alarm, dateTime:DateTime.parse("$year-$mmonth-14 05:12:26"), text:"nice day"),
//      ],
//     );
//   }

//   Widget oneTodo({IconData? iconData, required DateTime dateTime, required String text}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(width: 20),
//         SizedBox(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 1),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
//                 decoration: BoxDecoration(
//                   color:Colors.green.shade500,
//                   borderRadius: const BorderRadius.all(Radius.circular(3)),
//                 ),
//                 child:Text(
//                   "week ${dateTime.weekday}".xtr,
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
//                   strutStyle: const StrutStyle(
//                     forceStrutHeight: true,
//                     leading: 0.5,
//                   )
//                 )
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                 child:Text(
//                   dateTime.day.toString(),
//                   style: const TextStyle(fontSize: 12, color: Colors.black)
//                 )
//               )
//             ],
//           )
//         ),
//         const SizedBox(width: 13),
//         Container(
//           alignment: Alignment.topLeft,
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(3)),
//             color : Colors.green.shade50,
//           ),
//           padding: const EdgeInsets.all(5),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children:[
//               Container(
//                 constraints: BoxConstraints(maxWidth: ui.windowWidth - 96),
//                 child:Text(
//                   "$text, $text, $text, $text, $text", 
//                   style: const TextStyle(color:Colors.black54, fontSize: 16),
//                   strutStyle: const StrutStyle(
//                     forceStrutHeight: true,
//                     leading: 0.5,
//                   )
//                 )
//               ),
//               Text(
//                 text, 
//                 style: const TextStyle(color:Colors.black26, fontSize: 12)
//               )
//             ]
//           ),
//         ),
//         Expanded(child:Container())
//       ]
//     );
//   }

//   ONoteAppBar appBar() {
//     return ONoteAppBar(
//       backgroundColor: ui.appNavBgColor,
//       logo: EasyUI.twoColorText(text1: "C", text2: "alender", color1: ui.fgColor),
//       actions: [
//         Obx(()=>(){
//           String currentMonth = (controller.currentMonth.value<10) ? "0${controller.currentMonth.value}" : "${controller.currentMonth.value}";
//           String currentYearMonth = "${controller.currentYear} 年 $currentMonth 月";
//           return GestureDetector(
//             onTap: (){
//             },
//             child:SizedBox(
//               height:24,
//               child:Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children:[
//                   Text(currentYearMonth, style: const TextStyle(color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold)),
//                   EasyButton.custom(iconData:Icons.expand_more_outlined, iconSize: 20, iconColor: Colors.black45)
//                 ]
//               )
//             )
//           );
//         }())
//       ]
//     );
//   }
// }