import 'package:flutter/material.dart';
import 'package:hyper_sell/ui/admin/add_retailer.dart';
import 'package:hyper_sell/ui/register.dart';
class RetailerListScreen extends StatefulWidget {
  const RetailerListScreen({Key? key}) : super(key: key);

  @override
  State<RetailerListScreen> createState() => _RetailerListScreenState();
}

class _RetailerListScreenState extends State<RetailerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
    title: const Text("Retailers "),
    ),
    body:   Padding(
      padding: const EdgeInsets.all(50),
      child: SizedBox(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const AddRetailerScreen(
                        )));
              },
              child: const Text("Add new Retailer"))
      ),
    ),);
  }
}
