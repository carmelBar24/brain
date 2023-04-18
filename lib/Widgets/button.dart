import 'package:flutter/material.dart';

import '../Screens/subject_page.dart';

class Button extends StatelessWidget {
  VoidCallback function;
  String text;
  Button({
    required this.function,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  TextButton(onPressed: function,style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.deepPurple.shade200),elevation: MaterialStatePropertyAll(15),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
      child: Text(text,style:TextStyle(
          color: Colors.white,fontSize: 22.0,
          fontFamily: 'mainFont'
      ),
      ),
    );
  }
}
