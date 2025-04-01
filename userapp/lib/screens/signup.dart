import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/home.dart';
import 'package:userapp/Utilities/state.dart';
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
  bool signUpPressed = false;

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

  void accountVerification() async {
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
    if (!errorname && !errorEmail && !errorPass && !confpassError) {
      signUpPressed = true;
      setState(() {
        
      });
      String email = emailController.text;
      String password = passController.text;
      String username = usernameController.text;
      bool result = await DatabaseMethods().signUp(email, password);
      int id = DateTime.now().millisecondsSinceEpoch;
      if(result) {
        Map<String, dynamic> userInfo = {
          "email" : email,
          "displayname": username,
          "username" : email.split("@")[0],
          "profilePic" : "https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900",
          "reports" : 0,
          "posts" : 0,
          "ranking" : 0,
          "id" : id
        };
        var result = await DatabaseMethods().addUserInfo(userInfo);
        if(result != null) {
          String docID = result;
          if(mounted) {
            Provider.of<StateManagement>(context, listen: false).setProfile(email.split("@")[0], username, email, "https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900", 0, 0, 0, id, docID);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()), 
              (Route<dynamic> route) => false
            );
          }
        }else{
          if(mounted) {
            IconSnackBar.show(
              context,
              label: "Unable to sign up at the moment",
              snackBarType: SnackBarType.fail,
              labelTextStyle: TextStyle(color: Colors.white)
            );
          }
        }
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Opacity(
        opacity: signUpPressed ? 0.5 : 1.0,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                children: [
                  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(int.parse('0xffECE3CE')),Color(int.parse('0xff739072')),], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70), bottomRight: Radius.circular(70),)
                      ),
                      child: SafeArea(child:
                        Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                            Center(
                              child: Text(
                                "Create A New Account",
                                style: TextStyle(
                                  letterSpacing: 2.0,
                                  fontSize: 0.36.dp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(int.parse('0xff739072'))
                                ),
                                )
                            ),
                            Center(
                              child: Text(
                                "With Us",
                                style: TextStyle(
                                  letterSpacing: 5.0,
                                  fontSize: 0.36.dp,
                                  fontWeight: FontWeight.w900,
                                  color: Color(int.parse('0xff739072'))
                                ),
                              )
                            )
                          ],
                          ),
                        )
                      ),
                  ),
                Container(
                  margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 20.h),
                  height: 65.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(int.parse('0xff4F6F52')),Color(int.parse('0xff3A4D39'))], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 5.h, bottom: 5.h),
                    child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                                child: TextField(
                                controller: usernameController,
                                maxLength: 20,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(int.parse('0xffECE3CE'))
                                ),
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  errorText: errorname? errornameText: null,
                                  prefixIcon: Icon(Icons.person_outline_rounded, color: Color(int.parse('0xffECE3CE'))),
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
                            SizedBox(height: 2.h,),
                              SizedBox(
                                height: 10.h,
                                child: TextField(
                                controller: emailController,
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  color: Color(int.parse('0xffECE3CE'))
                                ),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  errorText: errorEmail? erroremailText: null,
                                  prefixIcon: Icon(Icons.email_outlined, color: Color(int.parse('0xffECE3CE'))),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 0.3.dp, letterSpacing:2 
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
                            SizedBox(height: 2.h),
                            SizedBox(
                              height: 10.h,
                              child: TextField(
                                controller: passController,
                                maxLength: 20,
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  color: Color(int.parse('0xffECE3CE'))
                                ),
                               decoration: InputDecoration(
                                  hintText: "Password",
                                  errorText: errorPass? errorpassText: null,
                                  prefixIcon: Icon(Icons.key_outlined, color: Color(int.parse('0xffECE3CE'))),
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
                                  child: Icon(hidePass, color: Color(int.parse('0xffECE3CE')))
                                  ),
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
                            SizedBox(height: 2.h,),
                            SizedBox(
                              height: 10.h,
                              child: TextField(
                                controller: confpassController,
                                maxLength: 20,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(int.parse('0xffECE3CE'))
                                ),
                                obscureText: obscureConfPass,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  errorText: confpassError? confpasserrorText: null,
                                  prefixIcon: Icon(Icons.key_outlined, color: Color(int.parse('0xffECE3CE'))),
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
                                  child: Icon(hideConfPass, color: Color(int.parse('0xffECE3CE')))
                                  ),
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
                            SizedBox(height: 2.h,),
                            ElevatedButton(onPressed: signUpPressed ? null : () => {
                              accountVerification()
                            }, 
                            style: ButtonStyle(
                              textStyle: WidgetStateProperty.all(TextStyle(
                                fontSize: 0.3.dp,
                                letterSpacing: 3,
                              )),
                              elevation: WidgetStateProperty.all(7),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              )),
                              padding: WidgetStateProperty.all(EdgeInsets.only(left: 22.w, right: 22.w, top:2.h, bottom: 2.h)),
                              backgroundColor: WidgetStateProperty.all(Color(int.parse('0xffECE3CE')))
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold
                              ),
                            )
                            ),
                            ]
                          ),
                        
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
                      Navigator.pop(context);
                    },
                    child: Text("Sign In!", 
                    style: TextStyle(fontSize: 25, color: Colors.blue.shade200),),
                  )
                ],
              )
              ],
            )
        
        )
          ),
      ),
      if(signUpPressed)...{
        Center(child: SizedBox(height: 8.h, width: 8.h,child: CircularProgressIndicator()))
      }
      ]
    );
  }
}