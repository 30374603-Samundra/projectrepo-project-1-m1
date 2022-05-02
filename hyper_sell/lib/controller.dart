import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyper_sell/ui/admin/home.dart';
import 'package:hyper_sell/ui/customer/home.dart';
import 'package:hyper_sell/ui/login_selector.dart';
import 'package:hyper_sell/ui/retailler/dashboard.dart';

class Controller extends StatelessWidget {
  const Controller({Key? key, required this.type}) : super(key: key);
  final int type;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            SystemNavigator.pop();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final FirebaseAuth _auth = FirebaseAuth.instance;
            if (_auth.currentUser == null) {
              return const LoginSelector();
            } else {
              if (type == 0) {
                return const HomePage();
              } else if(type == 1){
                return const AdminHomePage();
              }else{
                return const RetailerHomePage();
              }
            }
          }

          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [Text("Hyper Product Sell")],
            ),
          );
        });
  }
}
