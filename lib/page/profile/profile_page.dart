import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onote/i18n/translation_service.dart';
import 'package:onote/main.dart';
import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/easy_image.dart';
import 'package:onote/widget/onote_scaffold.dart';

class ProfileController extends GetxController {
}

class ProfilePage extends GetView<ProfileController> {

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ONoteScaffold(
      fixBody   : Container(
        // height: ui.windowHeight,
        color : ui.bgColor,
        child : ListView(
          padding: EdgeInsets.fromLTRB(15, ui.headHeight, 15, ui.footHeight + 15),
          physics: ui.physics,
          children: [
            // unlogin(),
            logined(),
            const SizedBox(height: 30),
            level(),
            const SizedBox(height: 30),
            reward(),
            const SizedBox(height: 20),
            config(),
            const SizedBox(height: 20),
            config()
          ]
        )
      )
    );
  }

  Widget unlogin() {
    return Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text("Hello !", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("立即登录，解锁惊喜会员体验", style: TextStyle(fontSize: 10))
            ]
          ),
          const Expanded(
            child:SizedBox()
          ),
          EasyButton.custom(
            text:"Profile:regist / login".xtr,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            height: 30,
            borderRadius: 15,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            fillColor: Colors.blueGrey.shade700
          )
        ]
      )
    );  
  }

  Widget logined() {
    return Container(
      alignment: Alignment.center,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EasyImage.image(
            "assets/images/girl.png",
            radius: 30,
            width: 60,
            height: 60,
            fit: BoxFit.cover
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("高斯糖", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800)),
              const SizedBox(height: 6),
              const Text("银星级 有效期至 2024/01/11", style: TextStyle(fontSize: 10)),
              const SizedBox(height: 6),
            ]
          ),
          const Expanded(
            child:SizedBox()
          ),
          EasyButton.custom(
            alignment: Alignment.centerRight,
            iconData: Icons.chevron_right_outlined,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            height: 24,
            width: 24,
            padding: const EdgeInsets.all(0)
          )
        ]
      )
    );  
  }

  Widget level() {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Column(
        children:[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(" 云存储 1M / 10M", style:TextStyle(color:Colors.blueGrey.shade700)),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.white,
              height: 10,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      width: ui.windowWidth * 0.3,
                      color:Colors.blueGrey.shade700
                    )
                  )
                ],
              ),
            )
          )
        ]
      )
    );
  }

  Widget reward() {
    return Container(
      alignment: Alignment.center,
      height: 100,
      decoration: const BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: const Text("REWARD")
    );
  }

  Widget config() {
    return Container(
      alignment: Alignment.center,
      height: 200,
      decoration: const BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: const Text("CONFIG")
    );
  }
}