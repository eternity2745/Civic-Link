import 'dart:developer';
import 'package:authorityapp/Database/methods.dart';
import 'package:authorityapp/Screens/home.dart';
import 'package:authorityapp/Utilities/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  int emailLcounter = 0;
  int passLcounter = 0;

  IconData hidePass = Icons.visibility_off_outlined;

  bool obscureText = true;
  bool error = false;
  bool emailError = false;
  bool passError = false;
  bool signInPressed = false;
  bool passObfuscate = true;

  String passerrorText = 'Invalid Password';
  String emailerrorText = "Invalid Email Id";

  var emailController = TextEditingController();
  var passController = TextEditingController();


  var animationLink = 'assets/animated_login_character.riv';
  rive.StateMachineController? stateMachineController;
  rive.Artboard? artboard;
  rive.SMITrigger? failTrigger, successTrigger;
  rive.SMIBool? isHandsUp, isChecking;
  rive.SMINumber? lookNum;

  @override
  void initState() {
      rootBundle.load(animationLink).then((value) {
        final file = rive.RiveFile.import(value);
        final art = file.mainArtboard;
        stateMachineController =
            rive.StateMachineController.fromArtboard(art, "Login Machine");

        if (stateMachineController != null) {
        art.addController(stateMachineController!);

        for (var element in stateMachineController!.inputs) {
          if (element.name == "isChecking") {
            isChecking = element as rive.SMIBool;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as rive.SMIBool;
          } else if (element.name == "trigSuccess") {
            successTrigger = element as rive.SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as rive.SMITrigger;
          } else if (element.name == "numLook") {
            lookNum = element as rive.SMINumber;
          }
        }
      }
      setState(() => artboard = art);
    });
    super.initState();
    }

  void lookAround() {
    if(passObfuscate) { 
      isChecking?.change(true);
      isHandsUp?.change(false);
      lookNum?.change(0);
    }
  }

  void moveEyes(value) {
    if(passObfuscate) {
      log('hhhh');
      lookNum?.change((value.length+30.0).toDouble());
    }
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
    passObfuscate = false;
  }

  void handsDownFromEyes() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    passObfuscate = true;
  }

  void loginClick() async {
    isChecking?.change(false);
    isHandsUp?.change(false);

    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
      List details = await DatabaseMethods().signIn(emailController.text, passController.text);

      if(details.isNotEmpty) {
        successTrigger?.fire();
        log("${details[0]}");
        String username = "${details[0]["username"]}";
        String email = "${details[0]["email"]}";
        String profilePic = "${details[0]["profilePic"]}";
        String locality = "${details[0]['locality']}";
        int userID= details[0]['id'];
        String docID = details[1];
        passError = false;
        emailError = false;
        // QuerySnapshot result = await DatabaseMethods().getUserPosts(userID);
        // List<Map<String, dynamic>> userPosts = [];
        // int i = 0;
        // for(var doc in result.docs) {
        //   userPosts.add(doc.data() as Map<String, dynamic>);
        //   userPosts[i]['postID'] = doc.id;
        //   i++;
        // }
        // log("$userPosts");
        signInPressed = false;
        setState(() {
        });
        if (mounted) {
          Provider.of<StateManagement>(context, listen: false).setProfile(username, email, profilePic, locality, userID, docID);
          // Provider.of<StateManagement>(context, listen: false).setUserPosts(posts: userPosts);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
        
      } else {
        signInPressed = false;
        failTrigger?.fire();
        passError = false;
        emailError = false;
        if(mounted) {
          IconSnackBar.show(
            context,
            label: "Inavild Email or Password Entered",
            snackBarType: SnackBarType.fail,
            labelTextStyle: TextStyle(color: Colors.white)
          );
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: (Text("Inavild Email or Password Entered"))));
        }
        setState(() {
          
        });
      }
    } else {
      signInPressed = false;
      failTrigger?.fire();
      setState(() {
        emailError = emailController.text.isEmpty ? true : false; 
        passError = passController.text.isEmpty ? true : false;
        passerrorText = (passController.text.isEmpty? "Password cannot be empty": "");
        emailerrorText = (emailController.text.isEmpty? "Email cannot be empty": "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Opacity(
        opacity: signInPressed ? 0.5 : 1,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                children: [
                   AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: 50.h,//containerHeight==0?containerHeight = MediaQuery.of(context).size.height/height: containerHeight,
                    width: 100.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(int.parse('0xffECE3CE')),Color(int.parse('0xff739072')),], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70), bottomRight: Radius.circular(70),)
                    ),
                    child: SafeArea(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Center(
                          child: Text(
                            "Login To",
                            style: TextStyle(
                              letterSpacing: 1.w,
                              fontSize: 0.34.dp,
                              fontWeight: FontWeight.w600,
                              color: Color(int.parse('0xff739072'))
                            ),
                            )
                        ),
                        Center(
                          child: Text(
                            "Authority Link",
                            style: TextStyle(
                              letterSpacing: 2.w,
                              fontSize: 0.42.dp,
                              fontWeight: FontWeight.w900,
                              color: Color(int.parse('0xff739072'))
                            ),
                          )
                        )
                      ],
                      )
                    ),
                  ),
                if (artboard != null)
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onDoubleTapDown: (de) {
                                  // if (details.globalPosition.dx > MediaQuery.of(context).size.width/2.85 && details.globalPosition.dx < MediaQuery.of(context).size.width/1.65 && details.globalPosition.dy > MediaQuery.of(context).size.height/7){
                                  // handsUpOnEyes();
                                  // }
                                  log("EVENT CALLED");
                                  handsUpOnEyes();
                                },
                                onTapDown: (de) {
                                  log('$passObfuscate ');
                                  if(passObfuscate == true) {
                                    handsDownFromEyes();
                                  }
                                },
                              child: Container(
                                margin: EdgeInsets.only(top: 7.5.h),
                                height: 21.sh,
                                child: rive.Rive(artboard: artboard!)),).animate(effects: [SlideEffect(duration: Duration(seconds: 1), begin: Offset(0, 1), end: Offset(0,0))]),
                Container(
                  margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 25.h),
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(int.parse('0xff4F6F52')),Color(int.parse('0xff3A4D39'))], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w),
                    child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10.h,
                                child: TextField(
                                enabled: signInPressed ? false : true,
                                controller: emailController,
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  color: Color(int.parse('0xffECE3CE'))
                                ),
                                decoration: InputDecoration(
                                  iconColor: Color(int.parse('0xffECE3CE')),
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.email_outlined, color: Color(int.parse('0xffECE3CE'))),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 18, letterSpacing:2 
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(int.parse('0xffECE3CE'))),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(int.parse('0xffECE3CE'))),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  errorText: emailError?emailerrorText:null
                                ),
                                onTap: lookAround,
                                onTapOutside: (event) {
                                  isChecking?.change(false);
                                  isHandsUp?.change(false);
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                  }
                                },
                                onEditingComplete: () {
                                  isChecking?.change(false);
                                  isHandsUp?.change(false);
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                  }
                                }
                                ,
                                onChanged: (value) {
                                   moveEyes(value);
                                }
                                //   int l = value.length;
                                //   if(l>0 && !emailheight){
                                //     emailheight = true;
                                //     height = height - 0.5;
                                //     setState(() {
                                      
                                //     });
                                //   }else if(l==0 && emailheight){
                                //     emailheight = false;
                                //     height = height + 0.5;
                                //     setState(() {
                                      
                                //     });
                                
                                //   }
                                // },
                                ),
                              ),
                            SizedBox(height: 1.h,),
                            SizedBox(
                              height: 10.h,
                              child: TextField(
                                enabled: signInPressed ? false : true,        
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  color: Color(int.parse('0xffECE3CE'))
                                ),
                                controller: passController,
                                obscureText: obscureText,
                               decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.key_outlined, color: Color(int.parse('0xffECE3CE'))),
                                  errorText: passError? passerrorText: null,
                                  suffixIcon: GestureDetector(
                                  onTap: () {
                                                      
                                    if (hidePass == Icons.visibility_off_outlined) {
                                      handsUpOnEyes();
                                      setState(() {
                                        hidePass = Icons.visibility_rounded;
                                        obscureText = false;
                                      });
                                    }else{
                                      handsDownFromEyes();
                                      setState(() {
                                        hidePass = Icons.visibility_off_outlined;
                                        obscureText = true;
                                      });
                                    }
                                  },
                                  child: Icon(hidePass, color: Color(int.parse('0xffECE3CE')))),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 18, letterSpacing:2 
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(int.parse('0xffECE3CE'))),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(int.parse('0xffECE3CE'))),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  ),
                                onTap: lookAround,
                                onTapOutside: (event) {
                                  isChecking?.change(false);
                                  isHandsUp?.change(false);
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                  }
                                },
                                onEditingComplete: () {
                                  isChecking?.change(false);
                                  isHandsUp?.change(false);
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                  }
                                },
                                onChanged: (value) {
                                   moveEyes(value);
                                }
                                //   int l = value.length;
                                //   if(l>0 && !passheight){
                                //     passheight = true;
                                //     height = height - 0.5;
                                //     setState(() {
                                      
                                //     });
                                //   }else if(l==0 && passheight){
                                //     passheight = false;
                                //     height = height + 0.5;
                                //     setState(() {
                                      
                                //     });
                              
                                //   }
                                // },
                                
                              ),
                            ),
                            SizedBox(height: 0.1.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 0.32.dp,
                                    color: Colors.blue.shade400
                                  ),
                                  
                                ),
                              ),
                            SizedBox(height: 3.h),
                            ElevatedButton(
                              onPressed: signInPressed ? null : () {
                              signInPressed = true;
                              setState(() {
                                
                              });
                              loginClick();
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()))
                            }, 
                            style: ButtonStyle(
                              textStyle: WidgetStateProperty.all(TextStyle(
                                fontSize: 0.32.dp,
                                letterSpacing: 3
                              )),
                              elevation: WidgetStateProperty.all(7),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              )),
                              padding: WidgetStateProperty.all(EdgeInsets.only(left: 22.w, right: 22.w, top: 1.5.h, bottom: 1.5.h)),
                              backgroundColor: WidgetStateProperty.all(Color(int.parse('0xffECE3CE')))
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 0.35.dp
                              ),
                            )
                            ),
                            ]
                          ),
                    ),
                  ),
                ],
              ),
              
              ],
            )
        
        )
          ),
      ),
      if(signInPressed)...{
        Center(child: SizedBox(height: 8.h, width: 8.h,child: CircularProgressIndicator()))
      }
    ]
  );
  }
}