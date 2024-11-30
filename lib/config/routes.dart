import 'package:onote/page/main_page.dart';
import 'package:get/get.dart';
import 'package:onote/page/note_edit/note_edit_page.dart';
import 'package:onote/page/note/note_page.dart';
import 'package:onote/page/note_edit_plus/note_edit_test.dart';
import 'package:onote/page/note_edit_plus/note_plus_edit_page.dart';
import 'package:onote/plugin/ai/ai_creator_plugin.dart';
import 'package:onote/plugin/add_plugin/add_plugin_plugin.dart';
import 'package:onote/plugin/ai/ai_draw_plugin.dart';
import 'package:onote/plugin/ai/ai_write_plugin.dart';
import 'package:onote/plugin/onote_qr/onote_qr_plugin.dart';
import 'package:onote/plugin/qr_scan/qr_scan_plugin.dart';
import 'package:onote/plugin/read_html/read_html_plugin.dart';

class Routes {

  static final getPages = [
    // page
    GetPage(name: '/page/main',           page: () => const MainPage()),
    GetPage(name: '/page/note',           page: () => const NotePage()),
    // GetPage(name: '/page/createNote',     page: () => const NoteEditPage()),
    // GetPage(name: '/page/editNote',       page: () => const NoteEditPage()),
    GetPage(name: '/page/createNote',     page: () => const NotePlusEditPage()),
    GetPage(name: '/page/editNote',       page: () => const NotePlusEditPage()),
    // GetPage(name: '/page/createNote',     page: () => const NoteEditTest()),
    // GetPage(name: '/page/editNote',       page: () => const NoteEditTest()),
    // GetPage(name: '/page/createCalendar', page: () => const CalendarEditPage()),
    // GetPage(name: '/page/editCalendar',   page: () => const CalendarEditPage()),

    // plugin
    GetPage(name: '/plugin/aiDraw',    page: () => const AiDrawPlugin()),
    GetPage(name: '/plugin/aiWrite',   page: () => const AiWritePlugin()),
    GetPage(name: '/plugin/onoteQr',   page: () => const OnoteQrPlugin()),
    GetPage(name: '/plugin/readHtml',  page: () => const ReadHtmlPlugin()),
    GetPage(name: '/plugin/addPlugin', page: () => const AddPluginPlugin()),
    GetPage(name: '/plugin/qrScan',    page: () => const QrScanPlugin ()),
    GetPage(name: '/plugin/aiCreator', page: () => const AiCreatorPlugin()),
  ];
}
