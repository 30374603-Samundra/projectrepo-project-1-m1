import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_sell/app_provider.dart';
import 'package:hyper_sell/models/product_model.dart';
import 'package:hyper_sell/ui/customer/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _cartCount = 0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      List<String> productIDs = value.getStringList('products') ?? [];
      _cartCount = productIDs.length;
      setState(() {});
    });

    print("length ${context.read<AppProvider>().products.length}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getBody(context);
  }

  getBody(BuildContext _context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.network(
            widget.product.imageUrl ?? "",
            fit: BoxFit.fitWidth,
          ),
          SafeArea(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  MaterialButton(
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    textColor: Colors.black,
                    minWidth: 0,
                    height: 40,
                    onPressed: () => Navigator.pop(context),
                  ),
                ]),
              ),
              Spacer(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey.withOpacity(0.2)),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30.0),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  widget.product.title??"",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  onPressed: () {},
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  widget.product.description??"",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ),
                              // ExpansionTile(
                              //   title: const Text(
                              //     "Details",
                              //     style: TextStyle(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              //   children: <Widget>[
                              //     Container(
                              //       alignment: Alignment.topLeft,
                              //       padding: const EdgeInsets.all(16.0),
                              //       child: Text(
                              //           widget.product.description??""),
                              //     )
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: Colors.blue.shade900,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "\$ ${widget.product.price}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            const SizedBox(width: 20.0),
                            Spacer(),
                            RaisedButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                List<String> productIDs =
                                    prefs.getStringList('products') ?? [];

                                if (productIDs.contains(widget.product.id)) {
                                  Fluttertoast.showToast(
                                      msg: "Product Already In Cart",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {

                                  productIDs.add(widget.product.id ?? "");
                                  prefs.setStringList('products', productIDs);
                                  setState(() {
                                    _cartCount++;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Product Added to Cart",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.pop(context);
                                }
                                context.read<AppProvider>().setCartProducts();
                              },
                              color: Colors.orange,
                              textColor: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.orange,
                                      size: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
