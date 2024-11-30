import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/main.dart';
import 'package:onote/page/auth/auth_provider_page.dart';
import 'package:onote/plugin/add_plugin/add_plugin_plugin.dart';
import 'package:onote/plugin/ai/ai_creator_plugin.dart';
import 'package:onote/plugin/ai/ai_draw_plugin.dart';
import 'package:onote/plugin/ai/ai_write_plugin.dart';
import 'package:onote/plugin/read_html/read_html_plugin.dart';
import 'package:onote/widget/easy_button.dart';

class MainSidebar extends StatefulWidget {

  const MainSidebar({
    super.key
  });

  @override
  State<MainSidebar> createState() => MainSidebarState();
}

class MainSidebarState extends State<MainSidebar> {

  static Logger logger = Logger();

  late double toolIconSize;

  @override
  Widget build(BuildContext context) {
    toolIconSize = (ui.windowWidth * 0.618 - 52)/2;
    return Container(
      color:Colors.green.shade50,
      padding: const EdgeInsets.fromLTRB(20, 65, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children:[
              // Expanded(child:Divider(color: Colors.black38)),
              Padding(padding:EdgeInsets.fromLTRB(6, 0, 6, 0) , child:Text("工具 / 助手", style: TextStyle(color:Colors.black87, fontSize: 16))),
              // Expanded(child:Divider(color: Colors.black38)),
            ]
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Scrollbar(
              radius: const Radius.circular(9), 
              thickness: 4,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: ui.physics,
                children: [
                  pluginButtonList()
                ],
              )
            )
          ),
          const SizedBox(height: 20),
          const AuthProviderPage(),
        ]
      )
    );
  }

  Widget pluginButtonList() {
    return Column(
      children:[
        Row(
          children: [
            pluginButton("readHtml", Icons.web, "Import Web"),
            const SizedBox(width: 10),
            pluginButton("aiCreator", Icons.smart_toy_outlined, "AI Creator"),
          ]
        ),
        Row(
          children: [
            pluginButton("onoteQr", Icons.qr_code_scanner, "ONote QR")
          ]
        )
      ]
    );
  }

  Widget pluginButton(String plugin, IconData iconData, String label) {
    return EasyButton.custom(
      iconData: iconData, 
      axis: Axis.vertical,
      borderWidth: 1,
      iconColor: Colors.black54,
      iconSize: 25,
      text: label,
      textSize: 14,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      textColor: Colors.black54,
      height: toolIconSize * 0.7,
      width: toolIconSize,
      borderColor: Colors.black26,
      fillColor: Colors.white60,
      borderRadius: 5,
      onPressed: (){
        _launchPlugin(plugin);
      }
    );
  }

  Future<void> _launchPlugin(String plugin) async {
    if ("readHtml"==plugin) {
      ReadHtmlPlugin.launch(context);
    }
    else if ("aiCreator"==plugin) {
      AiCreatorPlugin.launch(context);
    }
    else if ("addPlugin"==plugin) {
      AddPluginPlugin.launch(context);
    }
    else if ("aiWrite"==plugin) {
      AiWritePlugin.launch(context);
    }
    else if ("aiDraw"==plugin) {
      AiDrawPlugin.launch(context);
    }
    else if ("onoteQr"==plugin) {
      final result = await Get.toNamed(
        "/plugin/qrScan", 
        arguments: {
          "tips":"Open https://koocyton.github.io/onote-qr.html\nBuild your QR code",
          "startsWith":"onote-qr://"
        }
      );
      if (result!=null && result["qr_code"]!=null) {
        if (result["qr_code"].startsWith("onote-qr://")) {
        }
      }
    }
  }
}