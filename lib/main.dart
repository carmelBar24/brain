import 'package:brain/Screens/login_page.dart';
import 'package:brain/Screens/register_page.dart';
import 'package:brain/Screens/subject_page.dart';
import 'package:brain/Screens/tasks_page.dart';
import 'package:brain/Screens/workbench_page.dart';
import 'package:flutter/material.dart';

import 'Screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomePage.id:(context) => HomePage(),
        LoginPage.id:(context) => LoginPage(),
        RegisterPage.id:(context) => RegisterPage(),
        WorkbenchPage.id:(context) => WorkbenchPage(),
        SubjectPage.id:(context) => SubjectPage(subject: '',color: Colors.grey,subjectFolder: '', ),
        TasksPage.id:(context) => TasksPage(status: '',color:Colors.grey,user_email: ''),
      },
      initialRoute: HomePage.id,
    );
  }
}

