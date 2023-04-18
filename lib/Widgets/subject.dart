import 'package:flutter/material.dart';

import '../Screens/subject_page.dart';

class Subject extends StatelessWidget {
  String subject;
  Color color;
  String subjectFolder;
  int flex;
  Subject({
    required this.color,
    required this.subject,
    required this.subjectFolder,
    required this.flex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex,child: Card(color: color,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: SizedBox(height: 120,child: TextButton(
      onPressed: (){Navigator.push(context,MaterialPageRoute(
          builder: (context) => SubjectPage(subject: subject,color: color,subjectFolder: subjectFolder)));},
      child: Text(
        subject,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'mainFont',
            fontSize: 18
        ),
        textAlign: TextAlign.center,
      ),
    ),),),);
  }
}
