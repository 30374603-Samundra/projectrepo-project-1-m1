import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_sell/controller.dart';
import 'package:hyper_sell/ui/login.dart';

class AddRetailerScreen extends StatefulWidget {
  const AddRetailerScreen({Key? key,}) : super(key: key);


  @override
  _AddRetailerScreenState createState() => _AddRetailerScreenState();
}

class _AddRetailerScreenState extends State<AddRetailerScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  String email = "";
  String pass = "";
  //SIGN UP METHOD
  Future signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
    final addButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signUp(email: email, password: pass).then((value) {
             {
            Navigator.pop(context);
          Fluttertoast.showToast(
          msg: "Retailer added Successfully !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
          }
          });
        },
        child: Text("Add Retailer",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add retailer"),
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
                const SizedBox(height: 45.0),
                emailField,
                const SizedBox(height: 25.0),
                passwordField,
                const SizedBox(
                  height: 35.0,
                ),
                addButton,

              ],
            ),
          ),
        ),
      ),
    );
  }
}
