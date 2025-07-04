import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:sizer/sizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/home.dart';
import 'package:userapp/Screens/signup.dart';
import 'package:userapp/Utilities/state.dart';

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

  final TextEditingController _forgotPasswordController = TextEditingController();


  var animationLink = 'assets/animated_login_character.riv';
  rive.StateMachineController? stateMachineController;
  rive.Artboard? artboard;
  rive.SMITrigger? failTrigger, successTrigger;
  rive.SMIBool? isHandsUp, isChecking;
  rive.SMINumber? lookNum;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    _forgotPasswordController.dispose();
    super.dispose();
  }

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
      bool result = await DatabaseMethods().signIn(emailController.text, passController.text);

      if(result) {
        successTrigger?.fire();
        QuerySnapshot details = await DatabaseMethods().getUserInfo(emailController.text);
        log("${details.docs[0]}");
        String username = "${details.docs[0]["username"]}";
        String displayname = "${details.docs[0]["displayname"]}";
        String email = "${details.docs[0]["email"]}";
        String profilePic = "${details.docs[0]["profilePic"]}";
        int userID= details.docs[0]['id'];
        int posts = details.docs[0]['posts'];
        int reports = details.docs[0]['reports'];
        int ranking = details.docs[0]['ranking'];
        String docID = details.docs[0].id;
        passError = false;
        emailError = false;
        QuerySnapshot result = await DatabaseMethods().getUserPosts(userID);
        List<Map<String, dynamic>> userPosts = [];
        int i = 0;
        for(var doc in result.docs) {
          userPosts.add(doc.data() as Map<String, dynamic>);
          userPosts[i]['postID'] = doc.id;
          if(mounted) {      
            if(userPosts[i]['likesId'].contains(userID)) {
              userPosts[i]['liked'] = true;
            }else{
              userPosts[i]['liked'] = false;
            }
          }
          i++;
        }
        log("$userPosts");
        signInPressed = false;
        setState(() {
        });
        if (mounted) {
          Provider.of<StateManagement>(context, listen: false).setProfile(username, displayname, email, profilePic, ranking, reports, posts, userID, docID);
          Provider.of<StateManagement>(context, listen: false).setUserPosts(posts: userPosts);
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

  Future forgotPassword() async {
    if(_forgotPasswordController.text != "") {
      bool result = await DatabaseMethods().forgotPassword(_forgotPasswordController.text);
      if(result) {
        if(mounted) {
          Navigator.of(context).pop();
          IconSnackBar.show(
            context,
            label: "Password Reset Link Sent",
            snackBarType: SnackBarType.success,
            labelTextStyle: TextStyle(color: Colors.white)
          );
        }
      } else {
        if(mounted) {
          Navigator.of(context).pop();
          IconSnackBar.show(
            context,
            label: "Error Occured",
            snackBarType: SnackBarType.fail,
            labelTextStyle: TextStyle(color: Colors.white)
          );
        }
      }
      _forgotPasswordController.clear();
    }
  }

  Future signInWithGoogle() async {
    var result = await DatabaseMethods().signInWithGoogle();
    signInPressed = true;
    setState(() {
      
    });
    log("RESULT: $result");
    if(result != null) {
      successTrigger?.fire();
      String username = "${result["username"]}";
      String displayname = "${result["displayname"]}";
      String email = "${result["email"]}";
      String profilePic = "${result["profilePic"]}";
      int userID= result['id'];
      int posts = result['posts'];
      int reports = result['reports'];
      int ranking = result['ranking'];
      String docID = result['docID'];
      passError = false;
      emailError = false;
      signInPressed = false;
      setState(() {
        
      });
      if (mounted) {
        Provider.of<StateManagement>(context, listen: false).setProfile(username, displayname, email, profilePic, ranking, reports, posts, userID, docID);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } else {
      signInPressed = false;
      failTrigger?.fire();
      setState(() {
        
      });
      if(mounted) {
        IconSnackBar.show(
          context,
          label: "Couldnt Sign In!! Try Again!",
          snackBarType: SnackBarType.fail,
          labelTextStyle: TextStyle(color: Colors.white)
        );
      }
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
                            "Civic Link",
                            style: TextStyle(
                              letterSpacing: 2.w,
                              fontSize: 0.5.dp,
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
                  height: 60.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(int.parse('0xff4F6F52')),Color(int.parse('0xff3A4D39'))], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w, top:3.h, bottom: 2.h),
                    child: Column(
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
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(context: context, builder: (context) => SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h, bottom: 1.h),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              cursorColor: Colors.green,
                                              controller: _forgotPasswordController,
                                              decoration: InputDecoration(
                                                hintText: "Enter Email...",
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                  borderRadius: BorderRadius.circular(20)
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                  borderRadius: BorderRadius.circular(20)
                                                )
                                              ),
                                              style: TextStyle(
                                                fontSize: 0.3.dp,
                                              ),
                                            ),
                                            SizedBox(width: 2.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    forgotPassword();
                                                  }, 
                                                  icon: Icon(Icons.check_rounded, color: Colors.green,)
                                                ),
                                                IconButton(
                                                  onPressed: () { 
                                                    _forgotPasswordController.clear();
                                                    Navigator.of(context).pop();
                                                    }, 
                                                  icon: Icon(Icons.close, color: Colors.red,)
                                                )
                                              ],
                                              ),
                                          ],
                                        )
                                        ),
                                    ),
                                  )
                                  );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 0.32.dp,
                                      color: Colors.blue.shade400
                                    ),
                                    
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
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                Expanded(child: Divider(thickness: 3, endIndent: 10, color: Color(int.parse('0xffECE3CE')),)),
                                Text("Or Continue With", style: TextStyle(fontSize: 0.3.dp, color: Colors.green),),
                                Expanded(child: Divider(thickness: 3, indent: 10, color: Color(int.parse('0xffECE3CE')),))
                              ],
                            ),
                            SizedBox(height: 3.h),
                            ElevatedButton(onPressed: () {
                              signInWithGoogle();
                            }, 
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              padding: WidgetStateProperty.all(EdgeInsets.only(top: 2.h, bottom: 2.h, left: 5.w, right: 5.w))
                            ),
                            child: Image.asset('assets/google.png', fit: BoxFit.fitHeight, height: 5.h,)
                            ),
                            ]
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  Text("Dont Have An Account?  ",
                  style: TextStyle(
                    fontSize: 0.27.dp
                  ),),
                  GestureDetector(
                    onTap: signInPressed ? null : () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) =>  SignUpScreen())));
                    },
                    child: Text("Sign Up Now!", 
                    style: TextStyle(fontSize: 0.36.dp, color: Colors.blue.shade200),),
                  )
                ],
              )
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