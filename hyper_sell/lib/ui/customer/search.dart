import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_sell/app_provider.dart';
import 'package:hyper_sell/models/product_model.dart';
import 'package:hyper_sell/ui/customer/product.dart';
import 'package:hyper_sell/ui/customer/search_bar.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final dbRef = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamQuery;
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  List<Product> _searchProduct=[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
    // return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //   stream: streamQuery,
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return _isLoading
    //           ? const Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : Column(children: [
    //           SearchBar(
    //           controller: _controller,
    //           onChanged: (onChanged) {},
    //           onSubmitted: (value) {
    //             searchProducts(value);
    //           }),
    //         // snapshot.hasData?Container():Text("No results found !")
    //       ],);
    //
    //     } else {
    //       return Column(
    //         children: [
    //           SearchBar(
    //               controller: _controller,
    //               onChanged: (onChanged) {},
    //               onSubmitted: (value) {
    //                 searchProducts(value);
    //               }),
    //           snapshot.data!.docs.isNotEmpty?Container():const Text("No results found !"),
    //           Expanded(
    //             child: ListView(
    //               physics: BouncingScrollPhysics(),
    //               shrinkWrap: true,
    //               padding:
    //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //               children: snapshot.data!.docs.map((doc) {
    //                 return Card(
    //                   child: Column(
    //                     children: [
    //                       SizedBox(
    //                           height: 250,
    //                           child: doc.data()['image']==null?Image.asset('assets/images/phone.jpg'):Image.network(doc.data()['image'])),
    //                       ListTile(
    //                         title: Text(doc.data()['name']),
    //                         subtitle: Text(doc.data()['description']),
    //                         trailing:
    //                             Text("\$ " + doc.data()['price'].toString()
    //                             ),
    //                         onTap: () {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (BuildContext context) =>
    //                                       ProductScreen(productID: doc.id)));
    //                         },
    //                       ),
    //                     ],
    //                   ),
    //                 );
    //               }).toList(),
    //             ),
    //           )
    //         ],
    //       );
    //     }
    //   },
    // );
  }

  searchProducts(String query) {
    _isLoading = true;
    // var search1 = dbRef
    //     .collection('product')
    //     .orderBy('name')
    //     .startAt([query]).endAt([query+ '\uf8ff']).snapshots();
    // setState(() {
    //   streamQuery = search1;
    // });
    var searchQuery = context.read<AppProvider>().products.where((element) => element.title!.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      _searchProduct = searchQuery;
    });
    _isLoading = false;
  }

  buildBody(context){
    return Container(child: Column(
      children: [
        SearchBar(
            controller: _controller,
            onChanged: (onChanged) {},
            onSubmitted: (value) {
              searchProducts(value);
            }),
        _searchProduct.isNotEmpty?Container():const Text("No results !"),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: _searchProduct.map((data) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProductScreen(product: data)));
                },
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(
                          height: 250,
                          child: data.imageUrl==null?Image.asset('assets/images/phone.jpg'):Image.network(data.imageUrl??"")),
                      ListTile(
                        title: Text(data.title??""),
                        subtitle: Text(data.description??""),
                        trailing:
                        Text("\$ " + data.price.toString()
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    ),);
  }
}
