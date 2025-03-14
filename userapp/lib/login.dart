import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' as rive;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  double height = 2.25;
  double containerHeight = 0;
  int emailLcounter = 0;
  int passLcounter = 0;

  IconData hidePass = Icons.visibility_off_outlined;

  bool obscureText = true;
  bool error = false;
  bool emailheight = false;
  bool passheight = false;

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
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(value) {
    lookNum?.change((value.length+30.0).toDouble());
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void handsDownFromEyes() {
    isHandsUp?.change(false);
    isChecking?.change(true);
  }

  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);

    if (emailController.text == "example@gmail.com" && passController.text == "pass") {
      successTrigger?.fire();
      setState(() {
        error = false;
      });
    } else {
      failTrigger?.fire();
      setState(() {
        error = true;
        passerrorText = (passController.text.isEmpty? "Password cannot be empty": "Invalid Password");
        emailerrorText = (emailController.text.isEmpty? "Email cannot be empty": "Invalid Email");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
            children: [
               AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: MediaQuery.of(context).size.height/height,//containerHeight==0?containerHeight = MediaQuery.of(context).size.height/height: containerHeight,
                width: MediaQuery.of(context).size.width,
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
                        "Login To The",
                        style: TextStyle(
                          letterSpacing: 2.0,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(int.parse('0xff739072'))
                        ),
                        )
                    ),
                    Center(
                      child: Text(
                        "Polls App",
                        style: TextStyle(
                          letterSpacing: 5.0,
                          fontSize: 35,
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
                            onLongPressUp: () {
                              handsDownFromEyes();
                            },
                          child: Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
                            height: MediaQuery.of(context).size.height/5,
                            // child: GestureDetector(
                            //   onDoubleTap: () {
                            //   // if (details.globalPosition.dx > MediaQuery.of(context).size.width/2.85 && details.globalPosition.dx < MediaQuery.of(context).size.width/1.65 && details.globalPosition.dy > MediaQuery.of(context).size.height/7){
                            //   // handsUpOnEyes();
                            //   // }
                            //   log("EVENT CALLED");
                            //   handsUpOnEyes();
                            // },
                            // onLongPressUp: () {
                            //   handsDownFromEyes();
                            // },
                            child: rive.Rive(artboard: artboard!)),).animate(effects: [SlideEffect(duration: Duration(seconds: 1), begin: Offset(0, 1), end: Offset(0,0))]),
                        
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: MediaQuery.of(context).size.height/4),
                height: MediaQuery.of(context).size.height/1.55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(int.parse('0xff4F6F52')),Color(int.parse('0xff3A4D39'))], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)]
                ),
                child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                    return Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top:constraints.maxHeight/20, bottom: constraints.maxHeight/100),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight<501? constraints.maxHeight/5.5: constraints.maxHeight/6.5,
                                  child: TextField(
                                  controller: emailController,
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email_outlined, color: Color(int.parse('0xffECE3CE'))),
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400, fontSize: 18, letterSpacing:2 
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    errorText: error?emailerrorText:null
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
                                    int l = value.length;
                                    if(l>0 && !emailheight){
                                      emailheight = true;
                                      height = height - 0.5;
                                      setState(() {
                                        
                                      });
                                    }else if(l==0 && emailheight){
                                      emailheight = false;
                                      height = height + 0.5;
                                      setState(() {
                                        
                                      });
                                  
                                    }
                                  },
                                                            ),
                                ),
                              SizedBox(height: constraints.maxHeight/30,),
                              SizedBox(
                                height: constraints.maxHeight<501? constraints.maxHeight/5.5: constraints.maxHeight/6.5,
                                child: TextField(              
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                  controller: passController,
                                  obscureText: obscureText,
                                 decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: Icon(Icons.key_outlined, color: Color(int.parse('0xffECE3CE'))),
                                    errorText: error? passerrorText: null,
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
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(15)
                                    )
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
                                    int l = value.length;
                                    if(l>0 && !passheight){
                                      passheight = true;
                                      height = height - 0.5;
                                      setState(() {
                                        
                                      });
                                    }else if(l==0 && passheight){
                                      passheight = false;
                                      height = height + 0.5;
                                      setState(() {
                                        
                                      });
                                
                                    }
                                  },
                                  
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight/50,),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue.shade400
                                    ),
                                    
                                  ),
                                ),
                              SizedBox(height: constraints.maxHeight>501? constraints.maxHeight/15: constraints.maxHeight/24,),
                              ElevatedButton(onPressed: () => {
                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()))
                              }, 
                              style: ButtonStyle(
                                textStyle: WidgetStateProperty.all(TextStyle(
                                  fontSize: constraints.maxHeight/22,
                                  letterSpacing: 3
                                )),
                                elevation: WidgetStateProperty.all(7),
                                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                                )),
                                padding: WidgetStateProperty.all(EdgeInsets.only(left: 40, right: 40, top:constraints.maxHeight>501? constraints.maxHeight/35: constraints.maxHeight/40, bottom: constraints.maxHeight>501? constraints.maxHeight/35: constraints.maxHeight/40)),
                                backgroundColor: WidgetStateProperty.all(Color(int.parse('0xffECE3CE')))
                              ),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.green
                                ),
                              )
                              ),
                              SizedBox(height: constraints.maxHeight>501? constraints.maxHeight/11: constraints.maxHeight/30,),
                              Row(
                                children: [
                                  Expanded(child: Divider(thickness: 3, endIndent: 10, color: Color(int.parse('0xffECE3CE')),)),
                                  Text("Or Continue With", style: TextStyle(fontSize: 17),),
                                  Expanded(child: Divider(thickness: 3, indent: 10, color: Color(int.parse('0xffECE3CE')),))
                                ],
                              ),
                              SizedBox(height: constraints.maxHeight>501? constraints.maxHeight/11: constraints.maxHeight/13,),
                              ElevatedButton(onPressed: () => {}, 
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                padding: WidgetStateProperty.all(EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10))
                              ),
                              child: Image.network('http://pngimg.com/uploads/google/google_PNG19635.png', fit: BoxFit.fitHeight, height: constraints.maxHeight/8.5,)
                              ),
                              ]
                            ),
                          );
                        }
                      ),
                    );
                  }
                )
              ),
            ),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Text("Dont Have An Account?  ",
              style: TextStyle(
                fontSize: 17
              ),),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: ((context) =>  RegistrationScreen())));
                },
                child: Text("Sign Up Now!", 
                style: TextStyle(fontSize: 25, color: Colors.blue.shade200),),
              )
            ],
          )
          ],
        )

    )
  );
  }
}