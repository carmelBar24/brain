import 'package:brain/Screens/tasks_page.dart';
import 'package:flutter/material.dart';

class icon_learning extends StatelessWidget {
  String path_image;
  Color color;
  String status;
  String user_email;
  String tag;
  icon_learning(
      {super.key,
      required this.path_image,
      required this.color,
      required this.status,
      required this.user_email,required this.tag});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 90,
      child: FloatingActionButton(
        heroTag: tag,
        child: CircleAvatar(
          child: Image.asset(path_image),
          backgroundColor: color,
          minRadius: 50,
          maxRadius: 50,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TasksPage(
                    status: status, color: color, user_email: user_email),
              ));
        },
      ),
    );
  }

}
