import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../Widgets/task.dart';

class TasksPage extends StatefulWidget {
  String status;
  static const String id = "tasks screen";
  Color color;
  String user_email;
  TasksPage({Key? key,required this.status, required this.color,required this.user_email}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _firestore=FirebaseFirestore.instance;
  bool _isLoading = true;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1,milliseconds: 850), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SleekCircularSlider(
              appearance: CircularSliderAppearance(
                size: 200,
                startAngle: 90,
                angleRange: 360,
                customColors: CustomSliderColors(
                  trackColor: Colors.grey[200],
                  progressBarColor: Colors.purple,
                  dotColor: Colors.purple,
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 5,
                  progressBarWidth: 10,
                  handlerSize: 15,
                ),
                infoProperties: InfoProperties(
                  mainLabelStyle: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.purple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              min: 0,
              max: 100,
              initialValue: 100,
            ),
          ),
        );
      }
    return StreamBuilder<QuerySnapshot>(
        stream :_firestore
            .collection('tasks')
            .where('status', isEqualTo: widget.status)
            .where('email', isEqualTo: widget.user_email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Colors.white,
              child: Text('Error: ${snapshot.error}'),
            );
          }
        List<Task> tasks = [];
         if (snapshot.hasData) {
             snapshot.data!.docs.forEach((d) {
               Map<String, dynamic> data =
               d.data()! as Map<String, dynamic>; // added '!' operator here
               tasks.add(Task(
                   title: data['text'].toString().substring(0,data['text'].toString().length-4),
                   subject: data['subject'],
                   sub_subject: data['sub-subject']));
             });
             if(tasks.isNotEmpty) {
               return Scaffold(
                 backgroundColor:Colors.white,
                 appBar: AppBar(
                   leading: TextButton(
                     onPressed: () {
                       Navigator.pop(context);
                     },
                     child: Icon(
                       Icons.arrow_back_outlined,
                       color: Colors.white,
                       size: 30.0,
                     ),
                   ),
                   backgroundColor: widget.color,
                   centerTitle: true,
                   title: Text(widget.status, style: TextStyle(
                       color: Colors.black
                   ),
                   ),
                 ),
                 body: Card(
                   color: Colors.white,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Scrollbar(
                       thumbVisibility: true,
                       thickness: 8,
                       radius: Radius.circular(4),
                       child: ListView.builder(
                           itemCount: tasks.length,
                           itemBuilder: (context, index) {
                             return SizedBox(
                               width: MediaQuery.of(context).size.width,
                               child: Card(
                                 color: Colors.white,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                 borderOnForeground: true,
                                 shadowColor: widget.color,
                                 elevation: 8,
                                 child: ListTile(
                                   leading: Card(child: Container(
                                       alignment: Alignment.center,
                                       child: Text(tasks[index].subject),
                                       width: MediaQuery.of(context).size.width/3,
                                       height: 50,
                                    ),
                                     elevation: 20,
                                     shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),)),
                                   title: Text(tasks[index].title),
                                   subtitle: Text(tasks[index].sub_subject),
                                   trailing: IconButton(
                                       icon: Icon(Icons.delete,color: Colors.black), onPressed: () async {
                                         print(tasks[index].title);
                                     await _firestore.collection('tasks').doc(
                                         '${tasks[index].title}.pdf').delete();
                                     List<Task> newTasks = List<Task>.from(tasks);
                                     newTasks.removeAt(index);
                                     setState(() {
                                       tasks = newTasks;
                                     });
                                   }),
                                 ),
                               ),
                             );
                           }
                       ),
                     ),
                   ),
                 ),
               );
             }
             else{
               return Scaffold(
                 backgroundColor:Colors.white,
                 appBar: AppBar(
                   leading: TextButton(
                     onPressed: () {
                       Navigator.pop(context);
                     },
                     child: Icon(
                       Icons.arrow_back_outlined,
                       color: Colors.grey.shade400,
                       size: 30.0,
                     ),
                   ),
                   backgroundColor: Colors.white,
                   centerTitle: true,
                   title: Text(widget.status, style: TextStyle(
                       color: Colors.black
                   ),
                   ),
                 ),
                 body: SizedBox(
                   height: MediaQuery.of(context).size.height,
                   child: Card(
                     color:Colors.white,
                     child: Center(
                       child: Column(
                         children: [
                         SizedBox(height: 30,),
                         Lottie.asset(
                           'animations/empty.json',
                           fit: BoxFit.fill,
                         ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Empty List!',style: TextStyle(
                             fontSize: 36
                             ),
                             ),
                           ),
                           Expanded(
                             child: Text('You have no tasks at this moment',style: TextStyle(
                                 fontSize: 20
                             ),),
                           ),
                         ],
                       ),
                     )
                   ),
                 ),
               );
             }
         }
         return Container(color: Colors.white,);
          }
    );
  }
}
