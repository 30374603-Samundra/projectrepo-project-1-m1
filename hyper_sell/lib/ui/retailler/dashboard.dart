import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_sell/controller.dart';
import 'package:hyper_sell/ui/admin/product_list.dart';

class RetailerHomePage extends StatefulWidget {
  const RetailerHomePage({Key? key}) : super(key: key);

  @override
  _RetailerHomePageState createState() => _RetailerHomePageState();
}

class _RetailerHomePageState extends State<RetailerHomePage> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _productCount = 0;

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    db.collection('product').get().then((value) {
      _productCount = value.size;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home"),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const Controller(type: 2)));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SizedBox(
                width: double.infinity,
                height: 130,
                child: Card(
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text("Total Orders: 0"),
                        ),
                        ListTile(
                          title: Text("Total Products: $_productCount"),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "No Orders !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: const Text("Order List")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductList()));
                        },
                        child: const Text("Product List"))
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
