
import 'package:brain/Widgets/icon_learning.dart';
import 'package:brain/Widgets/subject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkbenchPage extends StatefulWidget {
  static const String id="work screen";
  const WorkbenchPage({Key? key}) : super(key: key);

  @override
  State<WorkbenchPage> createState() => _WorkbenchPageState();
}

class _WorkbenchPageState extends State<WorkbenchPage> {
  //var quote='';
  final _auth = FirebaseAuth.instance;
  late var user_email;
  @override
  Widget build(BuildContext context) {
    user_email=_auth.currentUser?.email;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children:[
                SizedBox(
                  height: MediaQuery.of(context).size.height/4,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children:
                        [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,top: 30),
                            child: Text('Select Your',style: TextStyle(fontFamily: 'mainFont',fontSize: 30,letterSpacing:2,fontWeight: FontWeight.w600),),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,),
                            child: Text('Subject',style: TextStyle(fontFamily: 'mainFont',fontSize: 30,color: Color(0XFF446bec),letterSpacing:2,fontWeight: FontWeight.w600),),
                          ),
                        ],crossAxisAlignment: CrossAxisAlignment.start,),
                        Flexible(child: Image.asset('images/workbench.png',fit: BoxFit.cover,)),
                      ]),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Subject(subject:'Automata Theory',flex: 2,color:Colors.deepOrange.shade200,subjectFolder: 'autumate',),
                      Subject(subject:'Computability And Complexity',flex: 3,color:Colors.red.shade200,subjectFolder: 'computability',),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
                  child: Row(
                    children: [
                      Subject(subject:'Algorithms',flex: 4,color:  Colors.indigo[200]!,subjectFolder: 'algo',),
                      Subject(subject:'Graph Theory',flex: 3,color:  Colors.green[200]!,subjectFolder: 'graph',),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0,bottom: 10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('My Tasks',style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'mainFont',
                    ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  shadowColor: Colors.grey,
                  margin: EdgeInsets.only(left:20 ,right: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 15,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom:8.0,top:8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            icon_learning(path_image:'images/to-do.png',color:Colors.deepOrange.shade100,status: 'To-Do',user_email:user_email??'not-valid',tag: 'todo',),
                            icon_learning(path_image:'images/in-progress.png',color:Colors.red.shade100,status: 'In-Progress',user_email:user_email??'not-valid',tag:'inprogress'),
                            icon_learning(path_image:'images/done.png',color:Colors.indigo.shade100,status:'Done',user_email:user_email??'not-valid',tag:'done'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0,right: 20,top: 8,bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('To Do'),
                            Text('In Progress'),
                            Text('Done'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}





