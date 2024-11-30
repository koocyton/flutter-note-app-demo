
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:onote/widget/easy_ui.dart';

class LicenseWidget {

  static Widget onLogout(BuildContext context) {
  return RichText(
      text: const TextSpan(
        text: '在智能手机、iPad 和 PC 上，将你奇思妙想和精彩瞬间，方便快捷的记录下来，强大图文排版功能，使你操作得心应手。',
        style: TextStyle(color:Colors.black54),
        children: <TextSpan>[
          // TextSpan(
          //   text: '关于数据加密',
          //   style: TextStyle(color: Colors.blueAccent.shade700),
          //   recognizer: TapGestureRecognizer()..onTap =(){
          //     EasyUI.showBottomModal(
          //       title: "关于数据加密",
          //       enableDrag: true,
          //       context: context,
          //       // height: ui.windowHeight * 0.9,
          //       child: Container()
          //     );
          //   }
          // ),
          // const TextSpan(text: '，除了您的秘钥，其他人无法获取笔记内容。'),
          // TextSpan(
          //   text: '隐私权政策',
          //   style: TextStyle(color: Colors.blueAccent.shade700),
          //   recognizer: TapGestureRecognizer()..onTap =(){
          //     EasyUI.showBottomModal(
          //       title: "隐私权政策",
          //       enableDrag: true,
          //       context: context,
          //       // height: ui.windowHeight * 0.9,
          //       child: Container()
          //     );
          //   }
          // ),
          // const TextSpan(text: '和'),
          // TextSpan(
          //   text: '服务条款',
          //   style: TextStyle(color: Colors.blueAccent.shade700),
          //   recognizer: TapGestureRecognizer()..onTap =(){
          //     EasyUI.showBottomModal(
          //       title: "服务条款",
          //       enableDrag: true,
          //       context: context,
          //       // height: ui.windowHeight * 0.9,
          //       child: Container()
          //     );
          //   }
          // ),
          // TextSpan(text: '。'),
        ],
      ),
    );
  }

  static Widget onLogin(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: '登陆后, 可在不同设备间共享笔记, 简记会将您的笔记加密, 安全的保存在云端',
        style: TextStyle(color:Colors.black54),
        // children: <TextSpan>[
        //   TextSpan(
        //     text: '详细请查看，关于数据加密',
        //     style: TextStyle(color: Colors.blueAccent.shade700),
        //     recognizer: TapGestureRecognizer()..onTap =(){
        //       EasyUI.showBottomModal(
        //         title: "关于数据加密",
        //         enableDrag: true,
        //         context: context,
        //         // height: ui.windowHeight * 0.9,
        //         child: Container()
        //       );
        //     }
        //   )
        // ],
      ),
    );
  }
}