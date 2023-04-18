
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:brain/api/pdf_viewer_page.dart';
import 'dart:io';
import '../api/pdf_firebase.dart';
import '../constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';



class SubjectPage extends StatefulWidget {
  static const String id="subject screen";
  final String subject;
  final Color color;
  final String subjectFolder;

  SubjectPage({required this.subject,required this.color,required this.subjectFolder});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final _firestore=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;
  int currentList = 0;
  late String folder = 'Lectures';
  late String message='';
  final _scrollBar=ScrollController(initialScrollOffset: 50.0);
  bool _loading = false;


  @override
  Widget build(BuildContext context) {
    List subject = getList(widget.subjectFolder);
    String subjectName = widget.subjectFolder;
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text(widget.subject, style: TextStyle(
          color: Colors.black,
          fontFamily: 'mainFont',
        ),
        )
          , backgroundColor: Colors.white,
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_outlined,
              color: Colors.grey.shade400,
              size: 30.0,
            ),
          ),),
        body: SafeArea(child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 220,
                  child: Image.asset(
                    'images/${widget.subject}.png', fit: BoxFit.cover,)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(child: Text('Lectures', style: TextStyle(
                      fontFamily: 'mainFont',
                      fontSize: 18,
                      color: currentList == 0 ? Colors.blue : Colors.black),),
                    onPressed: () {
                      setState(() {
                        currentList = 0;
                        folder = 'Lectures';
                      });
                    },
                  ),
                  TextButton(child: Text('Exercise', style: TextStyle(
                      fontFamily: 'mainFont',
                      fontSize: 18,
                      color: currentList == 1 ? Colors.blue : Colors.black)),
                    onPressed: () {
                      setState(() {
                        currentList = 1;
                        folder = 'Exercise';
                      });
                    },),
                  TextButton(child: Text('Other', style: TextStyle(
                      fontFamily: 'mainFont',
                      fontSize: 18,
                      color: currentList == 2 ? Colors.blue : Colors.black)),
                    onPressed: () {
                      setState(() {
                        currentList = 2;
                        folder = 'Other';
                      });
                    },),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 5,
                      color: currentList == 0 ? Colors.blue : Colors.grey[300])),
                  Expanded(child: Divider(thickness: 5,
                    color: currentList == 1 ? Colors.blue : Colors.grey[300],)),
                  Expanded(child: Divider(thickness: 5,
                      color: currentList == 2 ? Colors.blue : Colors.grey[300]))
                ],
              ),
              SizedBox(
                height: 400,
                child: Scrollbar(
                  controller: _scrollBar,
                  thumbVisibility: true,
                  thickness: 8,
                  radius: Radius.circular(4),
                  child: ListView.builder(
                    controller: _scrollBar,
                    itemCount: subject[currentList].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: TextButton(child:
                        Text(subject[currentList][index].toString().substring(0,subject[currentList][index].toString().length-4)),
                          onPressed: () async {
                          try {
                            _firestore.collection('tasks').doc(
                                subject[currentList][index]).set(
                                {
                                  'email':_auth.currentUser?.email,
                                  'status':'In-Progress',
                                  'sub-subject':folder,
                                  'subject':subjectName,
                                  'text':subject[currentList][index]
                                }).then((value) async {
                              setState(() {
                                _loading=true;
                              });
                              print(_loading);
                              final url = '$subjectName/$folder/' +
                                  subject[currentList][index];
                              print(url);
                              final file = await PDFApi.loadFirebase(url);
                              if (file == null) {
                                return;
                              }
                              openPDF(context, file);
                            }).catchError((err) {
                              setState(() {
                                message= 'Error: Something went wrong';
                                final snackBar = buildSnackBar(message);
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              });
                            });

                          }
                          catch(e)
                          {
                            setState(() {
                              message= 'Error: Something went wrong';
                            });
                          }
                          if (message=='Error: Something went wrong')
                            {
                              final snackBar =buildSnackBar(message);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: widget.color,
                          ),
                        ),
                        trailing: SizedBox(
                            width: 100,
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                try {
                                  _firestore.collection('tasks').doc(
                                      subject[currentList][index]).update(
                                      {
                                        'status': 'Done'
                                      }).then((value) {
                                        setState(() {
                                          message= 'Update status to Done';
                                        });
                                  })
                                    .catchError((err) {
                                      setState(() {
                                        message= 'Error: You need to add the file first';
                                      });
                                  }).whenComplete(() {
                                  final snackBar = buildSnackBar(message);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  });
                                }
                                catch(e)
                                {
                                  print(e);
                                }
                              }, icon: Icon(Icons.done,color: Colors.black87,)),
                              IconButton(onPressed: (){
                                try {
                                  _firestore.collection('tasks').doc(subject[currentList][index]).set({
                                    'email':_auth.currentUser?.email,
                                    'status':'To-Do',
                                    'sub-subject':folder,
                                    'subject':subjectName,
                                    'text':subject[currentList][index]
                                  })
                                 .then((value) {
                                   setState(() {
                                     message= 'Update status to To-Do';
                                     print(message);
                                   });
                                  }).catchError((err) {
                                        setState(() {
                                          message= 'Error: Something went wrong';
                                        });
                                  }).whenComplete(() {
                                    final snackBar = buildSnackBar(message);
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  });
                                }
                                catch(e)
                                {
                                  print(e);
                                }
                              }, icon: Icon(Icons.add_alarm,color: Colors.black87,))
                            ],
                          ),
                        ),

                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
  SnackBar buildSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: widget.color,
      action: SnackBarAction(
        label: 'close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  void openPDF(BuildContext context, File file) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)));
    setState(() {
      _loading=false;
    });
  }

  List getList(String subject) {
    final Map<String, List> subjectToList = {
      'graph': graph,
      'computability': computability,
      'algo': algo,
    };

    return subjectToList[subject] ?? autumate;
  }
}




