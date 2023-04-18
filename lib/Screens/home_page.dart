
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brain/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Widgets/button.dart';
class HomePage extends StatelessWidget {
  static const String id="home screen";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(25.0),
              child: AnimatedTextKit(
                animatedTexts: [TyperAnimatedText('Welcome to Brain Boost!',textStyle:TextStyle(
                  fontFamily:'mainFont',
                  color: Colors.black,
                  fontSize: 23.0,
                  decoration: TextDecoration.none,
                ), )],

              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text('please login and sign up to continue our app',style: TextStyle(
                color: Colors.grey.shade600,
                decoration: TextDecoration.none,
                fontSize: 16.0,
                fontFamily: 'secFont'
              ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(child: Lottie.asset(
                  'animations/brain.json',
                  fit: BoxFit.fill,
                ),
                ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:16,right: 16,bottom: 16),
              child:Button(text: 'Login Now',function: (){
                Navigator.pushNamed(context, LoginPage.id);
              },)
            ),
          ],
        ),
      ),
    );
  }
}
