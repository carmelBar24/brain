import 'package:brain/Screens/register_page.dart';
import 'package:brain/Screens/workbench_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Widgets/button.dart';


class LoginPage extends StatefulWidget {
  static const String id = "login screen";
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String user_email='';
  late String user_password='';
  final _auth = FirebaseAuth.instance;
  bool passfail = false;
  bool emailfail = false;
  String passfailtext = '';
  String emailfailtext = '';
  bool _loading=false;
  final _Google_sign_in=GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ModalProgressHUD(
          inAsyncCall:_loading,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                    padding: const EdgeInsets.only(left:25.0),
                    child: Text(
                      'Login Now',
                      style: TextStyle(
                        fontFamily: 'mainFont',
                        color: Colors.black,
                        fontSize: 30.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0,bottom: 5),
                    child: Text(
                      'please login to continue using our app',
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
                                        errorText: emailfail ? emailfailtext : null,
                                      ),
                                      onChanged: (value) {
                                        user_email = value;
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0, left: 22.0),
                                  child: Text('Password',
                                      style: TextStyle(
                                          fontFamily: 'mainFont',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, top: 10.0),
                                  child: TextField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Your Password',
                                        prefixIcon: Icon(Icons.lock),
                                        errorText: passfail ? passfailtext : null,
                                      ),
                                      onChanged: (value) {
                                        user_password = value;
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:16.0,top:16.0),
                                  child: Text(
                                    'Or continue with',
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        decoration: TextDecoration.none,
                                        fontSize: 14.0,
                                        fontFamily: 'mainFont'),
                                  ),
                                ),
                               Padding(
                                 padding: const EdgeInsets.only(left:16.0),
                                 child: Card(elevation: 5,child: TextButton(onPressed: (){
                                   _Google_sign_in.signIn().then((value){Navigator.pushNamed(context, WorkbenchPage.id);
                                   }).onError((error, stackTrace) {print(error);});},child:SizedBox(child: Image.asset('images/google.png',fit: BoxFit.cover),height: 40,width: 40,))),
                               )

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                         left: 40.0, right: 40.0),
                    child: Button(
                        function: () async {
                          setState(() {
                            _loading=true;
                          });
                          try {
                            if(validateEmail(user_email)) {
                              if(validatePass(user_password)) {
                                var user = await _auth.signInWithEmailAndPassword(
                                    email: user_email, password: user_password);
                                Navigator.pushNamed(context, WorkbenchPage.id);
                                setState(() {
                                  passfail = false;
                                  emailfail = false;
                                });
                              }
                            }
                            setState(() {
                              _loading=false;
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _loading=false;
                            });
                            print("createUserWithEmail:failed");
                            print(e.code);
                            setState(() {
                              passfail = false;
                              emailfail = false;
                              if (e.code == 'wrong-password') {
                                passfail = true;
                                passfailtext = 'The password provided is invalid.';
                              } else if (e.code == 'invalid-email') {
                                emailfail = true;
                                emailfailtext = 'The email provided is invalid.';
                              } else if (e.code == 'user-not-found') {
                                emailfail = true;
                                emailfailtext =
                                    'There is no user corresponding to the given email.';
                              }
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        text: 'Login'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Text(
                          'Dont have an account? ',
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.none,
                              fontSize: 14.0,
                              fontFamily: 'mainFont'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterPage.id);
                          },
                          child: Text(
                            'Register now',
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
    );
  }
  bool validateEmail(String? Email) {
    if (Email == null || Email.isEmpty) {
      setState(() {
        emailfail=true;
        emailfailtext= 'Email address is required.';
      });
      return false;
    }
    emailfailtext='';
    emailfail=false;
    return true;

  }
  bool validatePass(String? Pass) {
    if (Pass == null || Pass.isEmpty) {
      setState(() {
        passfail=true;
       passfailtext= 'password is required.';
      });
      return false;
    }
    passfailtext='';
    passfail=false;
    return true;

  }
}
