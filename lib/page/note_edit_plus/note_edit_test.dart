import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteEditTest extends StatefulWidget {

  const NoteEditTest({
    super.key
  });

  @override
  State<NoteEditTest> createState() {
    return NoteEditTestState();
  }
}

class NoteEditTestState extends State<NoteEditTest> {

  bool isResize = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: isResize,
      body: Container(
        color:Colors.black12,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            GestureDetector(
              onTap: (){
                setState(() {
                  isResize = !isResize;
                });
              },
              child: Container(
                color: isResize ? Colors.red : Colors.green, 
                width: 100, 
                height: 100
              )
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: (){
                SystemChannels.textInput.invokeMethod('TextInput.show');
              },
              child: Container(
                color:Colors.red, 
                width: 100, 
                height: 100
              )
            )
          ]
        )
      )
    );
  }
}