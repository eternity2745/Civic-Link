import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/screens/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool errorname = false;
  bool errorEmail = false;
  bool errorPass = false;
  bool confpassError = false;
  bool obscurePass = true;
  bool obscureConfPass = true;
  bool usernameheight = false;
  bool emailheight = false;
  bool passheight = false;
  bool confpassheight = false;

  String errornameText = "Invalid Username";
  String confpasserrorText = "Passwords Do Not Match";
  String errorpassText = 'Invalid Password';
  String erroremailText = "Invalid Email Id";

  IconData hidePass = Icons.visibility_off_outlined;
  IconData hideConfPass = Icons.visibility_off_outlined;

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var usernameController = TextEditingController();
  var confpassController = TextEditingController();

  void accountVerification() {
    if (usernameController.text.isEmpty) {
      errorname = true;
      errornameText = "Username Cant Be Empty";
    }else if(usernameController.text.contains("@")) {
      errorname = true;
      errornameText = "Username Cant have special characters like '@', '#', ','";
    }else{
      errorname=false;
    }

    if (emailController.text.isEmpty){
      errorEmail = true;
      erroremailText = "Email Cannot Be Empty";
    }
    else if (emailController.text != 'example@gmail.com') {
      errorEmail = true;
      erroremailText = "Invalid Email Id";
    }else{
      errorEmail = false;
    }
    if (passController.text.isEmpty) {
      errorPass = true;
      errorpassText = "Password Cannot Be Empty";
    }else{
      errorPass = false;
    }
    if (confpassController.text.isEmpty) {
      confpassError = true;
      confpasserrorText = "Password Cannot Be Empty";
    }else if(confpassController.text != passController.text) {
      errorPass = true;
      errorpassText = "Passwords Do Not Match";
      confpassError = true;
      confpasserrorText = "Passwords Do Not Match";
    }else{
      errorPass = false;
      confpassError = false;
    }

    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
            children: [
              AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: 30.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.deepPurple.shade600, Colors.pink.shade300], begin: Alignment.bottomCenter, end: Alignment.topRight),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70), bottomRight: Radius.circular(70),)
                  ),
                  child: SafeArea(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Center(
                        child: Text(
                          "Create A New Account",
                          style: TextStyle(
                            letterSpacing: 2.0,
                            fontSize: 0.36.dp,
                            fontWeight: FontWeight.w600,
                          ),
                          )
                      ),
                      Center(
                        child: Text(
                          "With Us",
                          style: TextStyle(
                            letterSpacing: 5.0,
                            fontSize: 0.36.dp,
                            fontWeight: FontWeight.w900
                          ),
                        )
                      )
                    ],
                    )
                  ),
              ),
            Container(
              margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 30.h),
              height: MediaQuery.of(context).size.height/1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple.shade900, Colors.purple.shade700, Colors.purple.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 12)]
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top:constraints.maxHeight/13, bottom: constraints.maxHeight/100),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: constraints.maxHeight>501? constraints.maxHeight/6: (constraints.maxHeight>497?constraints.maxHeight/6:constraints.maxHeight/6),
                                child: TextField(
                                controller: usernameController,
                                maxLength: 20,
                                style: TextStyle(
                                  fontSize: 20
                                ),
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  errorText: errorname? errornameText: null,
                                  prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.blue.shade100),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 18, letterSpacing:2 
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)
                                  )
                                ),
                                onTapOutside: (event) {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                }
                                },
                                onChanged: (value) {
                                int l = value.length;
                                if(l>0 && !usernameheight){
                                  usernameheight = true;
                                  // height = height - 0.69;
                                  setState(() {
                                    
                                  });
                                }else if(l==0 && usernameheight){
                                  usernameheight = false;
                                  // height = height + 0.69;
                                  setState(() {
                                    
                                  });
                          
                                }
                                }
                                                          ),
                              ),
                            SizedBox(height: constraints.maxHeight>501? constraints.maxHeight/30: constraints.maxHeight/30,),
                              SizedBox(
                                height: constraints.maxHeight>501? constraints.maxHeight/6: (constraints.maxHeight>497?constraints.maxHeight/6:constraints.maxHeight/6),
                                child: TextField(
                                controller: emailController,
                                style: TextStyle(
                                  fontSize: 0.3.dp
                                ),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  errorText: errorEmail? erroremailText: null,
                                  prefixIcon: Icon(Icons.email_outlined, color: Colors.blue.shade100),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 0.3.dp, letterSpacing:2 
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)
                                  )
                                ),
                                
                                onTapOutside: (event) {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                }
                                },
                                onChanged: (value) {
                                int l = value.length;
                                if(l>0 && !emailheight){
                                  emailheight = true;
                                  // height = height - 0.69;
                                  setState(() {
                                    
                                  });
                                }else if(l==0 && emailheight){
                                  emailheight = false;
                                  // height = height + 0.69;
                                  setState(() {
                                    
                                  });
                          
                                }
                                }
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight>501? constraints.maxHeight/30: constraints.maxHeight/20,),
                            SizedBox(
                              height: constraints.maxHeight>501? constraints.maxHeight/6: (constraints.maxHeight>497?constraints.maxHeight/6:constraints.maxHeight/6),
                              child: TextField(
                                controller: passController,
                                maxLength: 20,
                                style: TextStyle(
                                  fontSize: 0.3.dp
                                ),
                               decoration: InputDecoration(
                                  hintText: "Password",
                                  errorText: errorPass? errorpassText: null,
                                  prefixIcon: Icon(Icons.key_outlined, color: Colors.blue.shade100),
                                  suffixIcon: GestureDetector(
                                  onTap: () {
                                  if (hidePass == Icons.visibility_off_outlined) {
                                    setState(() {
                                      hidePass = Icons.visibility_rounded;
                                      obscurePass = false;
                                    });
                                  }else{
                                    setState(() {
                                      hidePass = Icons.visibility_off_outlined;
                                      obscurePass = true;
                                    });
                                  }
                                },
                                  child: Icon(hidePass, color: Colors.blue.shade100)
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 18, letterSpacing:2 
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)
                                  )
                                ),
                                obscureText: obscurePass,
                              
                                onTapOutside: (event) {
                                
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                }
                                },
                                onChanged: (value) {
                                int l = value.length;
                                if(l>0 && !passheight){
                                  passheight = true;
                                  // height = height - 0.69;
                                  setState(() {
                                    
                                  });
                                }else if(l==0 && passheight){
                                  passheight = false;
                                  // height = height + 0.69;
                                  setState(() {
                                    
                                  });
                          
                                }
                                }
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight>501? constraints.maxHeight/30: constraints.maxHeight/30,),
                            SizedBox(
                              height: constraints.maxHeight>501? constraints.maxHeight/6: (constraints.maxHeight>497?constraints.maxHeight/6:constraints.maxHeight/6),
                              child: TextField(
                                controller: confpassController,
                                maxLength: 20,
                                style: TextStyle(
                                  fontSize: 20
                                ),
                                obscureText: obscureConfPass,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  errorText: confpassError? confpasserrorText: null,
                                  prefixIcon: Icon(Icons.key_outlined, color: Colors.blue.shade100),
                                  suffixIcon: GestureDetector(
                                  onTap: () {
                                  if (hideConfPass == Icons.visibility_off_outlined) {
                                    setState(() {
                                      hideConfPass = Icons.visibility_rounded;
                                      obscureConfPass = false;
                                    });
                                  }else{
                                    setState(() {
                                      hideConfPass = Icons.visibility_off_outlined;
                                      obscureConfPass = true;
                                    });
                                  }
                                },
                                  child: Icon(hideConfPass, color: Colors.blue.shade100)
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 18, letterSpacing:2 
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)
                                  )
                                ),
                                
                                onTapOutside: (event) {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                }
                                },
                                onChanged: (value) {
                                int l = value.length;
                                if(l>0 && !confpassheight){
                                  confpassheight = true;
                                  // height = height - 0.69;
                                  setState(() {
                                    
                                  });
                                }else if(l==0 && confpassheight){
                                  confpassheight = false;
                                  // height = height + 0.69;
                                  setState(() {
                                    
                                  });
                          
                                }
                                }
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight>501? constraints.maxHeight/14: constraints.maxHeight/17,),
                            ElevatedButton(onPressed: () => {
                              accountVerification()
                            }, 
                            style: ButtonStyle(
                              textStyle: WidgetStateProperty.all(TextStyle(
                                fontSize: constraints.maxHeight>501? constraints.maxHeight/27: constraints.maxHeight/22,
                                letterSpacing: 3
                              )),
                              elevation: WidgetStateProperty.all(7),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              )),
                              padding: WidgetStateProperty.all(EdgeInsets.only(left: 40, right: 40, top:constraints.maxHeight>501? constraints.maxHeight/37: constraints.maxHeight/40, bottom: constraints.maxHeight>501? constraints.maxHeight/37: constraints.maxHeight/40)),
                              backgroundColor: WidgetStateProperty.all(Colors.blue.withGreen(100))
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            )
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
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Text("Already Have An Account?  ",
              style: TextStyle(
                fontSize: 17
              ),),
              GestureDetector(
                onTap: () {
                  Navigator.push
                  (context, MaterialPageRoute(builder: ((context) =>  LoginScreen())));
                },
                child: Text("Sign In!", 
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