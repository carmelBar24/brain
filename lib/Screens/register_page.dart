import 'package:brain/Screens/workbench_page.dart';
import 'package:brain/Widgets/icon_learning.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../Widgets/button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static const String id = "register screen";
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  bool _user_agree = false;
  String user_email='';
  String user_password='';
  bool emailfail=false;
  bool passfail=false;
  bool checkfail=false;
  String passfailtext='';
  String emailfailtext='';
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
            body:SafeArea(
            child: SingleChildScrollView(
              child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.grey.shade400,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:25.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'mainFont',
                              color: Colors.black,
                              fontSize: 30.0,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25.0,bottom: 5),
                          child: Text(
                            'please sign up to to enter in a app',
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.none,
                                fontSize: 14.0,
                                fontFamily: 'mainFont'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16,bottom: 16),
                          child: Center(
                            child: Card(
                              color: Colors.white,
                              shape: GradientBoxBorder(
                                gradient: LinearGradient(colors: [Colors.redAccent, Colors.indigoAccent.shade100]),
                                width: 4,
                              ),
                              elevation: 10,
                              child: SizedBox(
                              height:MediaQuery.of(context).size.height/2,
                              width:MediaQuery.of(context).size.height/2.3,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0, left: 22.0),
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                              fontFamily: 'mainFont',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0, bottom: 16.0, top: 10.0),
                                        child: TextField(
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              hintText: 'Enter Your Email',
                                              prefixIcon: Icon(Icons.email),
                                            errorText: emailfail ? emailfailtext : null,),
                                            onChanged: (value){user_email=value;}),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0, left: 22.0),
                                        child: Text('Password',
                                            style: TextStyle(
                                                fontFamily: 'mainFont',
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, right: 16.0,bottom: 16.0, top: 10.0),
                                        child: TextField(
                                            obscureText: true,
                                          decoration: InputDecoration(
                                              hintText: 'Enter Your Password',
                                            prefixIcon: Icon(Icons.lock),
                                            errorText: passfail ? passfailtext : null,),
                                            onChanged: (value){user_password=value;}),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                value: _user_agree,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _user_agree = value!;
                                  });
                                },
                              ),
                              Text('i agree with privacy policy'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Text(checkfail ? 'Please confirm privacy policy' : '',style: TextStyle(
                          color: Colors.red
                          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50.0, right: 50.0),
                          child:Button(function: () async{
                            try{
                              if(_user_agree==true)
                              {
                                setState(() {
                                  checkfail=false;
                                });
                                if(validateEmail(user_email)) {
                                  if(validatePassword(user_password)) {
                                    setState(() {
                                      _loading=true;
                                    });
                                    var user = await _auth
                                        .createUserWithEmailAndPassword(
                                        email: user_email!, password: user_password!);
                                    print("createUserWithEmail:success");
                                    Navigator.pushNamed(context, WorkbenchPage.id);
                                    setState(() {
                                      passfail = false;
                                      emailfail = false;
                                      checkfail = false;
                                      _loading=false;
                                    });
                                  }
                                }
                              }
                              else {
                                setState(() {
                                  checkfail=true;
                                });
                              }
                            }
                            on FirebaseAuthException catch( e){
                              print("createUserWithEmail:failed");
                              print(e.code);
                              setState(() {
                                passfail=false;
                                emailfail=false;
                                checkfail=false;
                                _loading=false;
                                if (e.code == 'weak-password') {
                                  passfail=true;
                                  passfailtext='The password provided is too weak.';
                                }
                                else if (e.code == 'email-already-in-use') {
                                  emailfail=true;
                                  emailfailtext='The account already exists for that email.';
                                }
                                else if (e.code=='invalid-email')
                                {
                                  emailfail=true;
                                  emailfailtext='The email provided is invalid.';
                                }
                              });
                            }
                            catch (e)
                            {
                              print(e);
                            }
                          },text: 'Sign up'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Row(
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.none,
                                    fontSize: 14.0,
                                    fontFamily: 'mainFont'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, LoginPage.id);
                                },
                                child: Text(
                                  'Login now',
                                  style: TextStyle(
                                      color: Color(0XFF446bec), fontFamily: 'mainFont'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              ),
            ),
          ),
      ),
    );
  }
  bool validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      setState(() {
        emailfail=true;
        emailfailtext= 'Email address is required.';
        _loading=false;
      });
      return false;
    }
    emailfailtext='';
    emailfail=false;
    return true;

  }
  bool validatePassword(String value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
    if (value.isEmpty) {
      setState(() {
        passfail=true;
        passfailtext= 'Please enter password';
      });
      return false;
    } else {
      if (!regex.hasMatch(value)) {
        setState(() {
          passfail=true;
          passfailtext= 'Enter valid password';
        });
        return false;
      }
      setState(() {
        passfail=false;
        passfailtext='';
      });
      return true;
    }
  }
}
