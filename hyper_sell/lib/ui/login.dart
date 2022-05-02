import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_sell/controller.dart';
import 'package:hyper_sell/ui/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.loginType}) : super(key: key);
  final String loginType;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  String email = "";
  String pass = "";

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      var userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      SharedPreferences _pref = await SharedPreferences.getInstance();
      print(userCred.user?.uid ?? "");
      _pref.setString("uid", userCred.user?.uid.toString() ?? "");
      _pref.setString("email", userCred.user?.email.toString() ?? "");
      _pref.setString("type", widget.loginType);
      return 0;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      onChanged: (text) {
        email = text;
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      onChanged: (text) {
        pass = text;
      },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signIn(email: email, password: pass).then((value) => {
                if (value != null)
                  {
                    if (value == 0)
                      {
                        if (widget.loginType == "Customer")
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Controller(type: 0)))
                          }
                        else if(widget.loginType == "Admin")
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Controller(type: 1)))
                          }
                        else
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Controller(type: 2)))
                          }
                      }
                    else
                      {
                        Fluttertoast.showToast(
                            msg: value,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0)
                      }
                  }
                else
                  {
                    Fluttertoast.showToast(
                        msg: "Something Went Wrong",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0)
                  }
              });
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loginType + " Login"),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50.0,
                  child: Text("Hyper Selling App",
                  style: TextStyle(
                    fontSize: 30
                  ),),
                ),
                const SizedBox(height: 45.0),
                emailField,
                const SizedBox(height: 25.0),
                passwordField,
                const SizedBox(
                  height: 35.0,
                ),
                loginButon,
                const SizedBox(
                  height: 15.0,
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RegisterScreen(
                                  regType: widget.loginType,
                                )));
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text("Register Now!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
