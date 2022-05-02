import 'package:flutter/material.dart';
import 'package:hyper_sell/app_provider.dart';
import 'package:hyper_sell/controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
String loginType ='Customer';
void main() {
   SharedPreferences.getInstance().then((value) {
    loginType= value.getString("type")??"Customer";
  });
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AppProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hyper Sell',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Controller(type:loginType =='Customer'?0:loginType =='Admin'?1:2 ),
    ));


  }
}
