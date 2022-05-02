import 'package:flutter/material.dart';
import 'package:hyper_sell/ui/login.dart';

class LoginSelector extends StatelessWidget {
  const LoginSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Selector"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Column(
          children: [
            const Text("Welcome User Login To Your Account",
            style: TextStyle(
              fontSize: 20
            ),),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (BuildContext context) =>
                    //                 const LoginScreen(
                    //                   loginType: "Retailer",
                    //                 )));
                    //   },
                    //   child: const Text("Retailer"),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen(
                              loginType: "Admin",
                            ),
                          ),
                        );
                      },
                      child: const Text("Admin"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen(
                              loginType: "Retailer",
                            ),
                          ),
                        );
                      },
                      child: const Text("Retailer"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen(
                              loginType: "Customer",
                            ),
                          ),
                        );
                      },
                      child: const Text("Customer"),
                    )
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
