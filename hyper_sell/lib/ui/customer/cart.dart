import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_sell/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key, required this.productIDs}) : super(key: key);
  final List<String> productIDs;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final db = FirebaseFirestore.instance;
  List<String> _products = [];
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  void initState() {
    super.initState();
    _products = widget.productIDs;


  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Cart")),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [Text("Your Cart is Empty")],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          actions: [
            IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('products');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text("Your Cart"),
            // Expanded(
            //   child: ListView.builder(
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            //       itemCount: _products.length,
            //       itemBuilder: (context, index) {
            //         return Container();
            //         // return FutureBuilder<
            //         //     DocumentSnapshot<Map<String, dynamic>>>(
            //         //   future:
            //         //       db.collection('product').doc(_products[index]).get(),
            //         //   builder: (context, snapshot) {
            //         //     if (!snapshot.hasData) {
            //         //       return const Center(
            //         //         child: CircularProgressIndicator(),
            //         //       );
            //         //     } else {
            //         //       Map<String, dynamic>? doc = snapshot.data!.data();
            //         //       return Card(
            //         //         child: ListTile(
            //         //           leading: Image.asset('assets/images/phone.jpg'),
            //         //           title: Text(doc!['name']),
            //         //           subtitle: Text("\$ " + doc['price'].toString()),
            //         //           trailing: IconButton(
            //         //               onPressed: () {
            //         //                 setState(() {
            //         //                   _products.remove(_products[index]);
            //         //                 });
            //         //               },
            //         //               icon: const Icon(Icons.delete_forever)),
            //         //         ),
            //         //       );
            //         //     }
            //         //   },
            //         // );
            //       }),
            // ),
            getCartItem(context),
            _products.isNotEmpty?Container(
              color: Colors.blue,
              child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: ()async {
                var uid ='';
                SharedPreferences.getInstance()
                    .then((value) => uid = value.getString("uid") ?? "");
                await db.collection('orders').doc(uid);
              },
              child: Text("Checkout",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),):Container()
          ],
        ),
      );
    }
  }

  getCartItem(BuildContext context){
    return  Consumer<AppProvider>(
        builder: (_, provider, __)=>Expanded(child: ListView.builder(
          padding:const EdgeInsets.all(16.0),
          itemCount: provider.cartProducts.length,
          itemBuilder: (BuildContext context, int index){
            var item = provider.cartProducts[index];
            return Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(right: 30.0, bottom: 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    elevation: 3.0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            height: 80,
                            child: Image.network(item.imageUrl??""),
                          ),
                          const SizedBox(width: 10.0,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.title??"", style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),),
                                const SizedBox(height: 20.0,),
                                Text("\$${item.price}", style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0
                                ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 15,
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.red,
                      child: const Icon(Icons.clear, color: Colors.white,),
                      onPressed: () {
                        _products.remove(_products[index]);
                        print(_products.length);
                        SharedPreferences.getInstance().then((value) {
                          value.setStringList('products', _products);
                        });
                        context.read<AppProvider>().setCartProducts();
                      },
                    ),
                  ),
                )
              ],
            );
          },

        ),));

  }
}
