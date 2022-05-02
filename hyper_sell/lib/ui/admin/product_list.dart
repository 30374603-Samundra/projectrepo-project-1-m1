import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_sell/app_provider.dart';
import 'package:hyper_sell/models/product_model.dart';
import 'package:hyper_sell/repository.dart';
import 'package:hyper_sell/ui/admin/add.dart';
import 'package:hyper_sell/ui/customer/product.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
    getProducts(context);
  }
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AppProvider>(
                builder: (_, provider, __)=>
                    ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: provider.products.length,
                        itemBuilder: (context,index){
                          var item = provider.products[index];
                          return getProductItem(item);
                        })),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: 400,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const AddProduct()));
                  },
                  child: const Text("Add New Product")),
            ),
          )
        ],
      ),
    );
  }

  getProducts(BuildContext context)async{
    var products = await Repository().getProducts();
    context.read<AppProvider>().updateProducts(products);
    print("fetch products ${products.length}");
  }

  Widget getProductItem(Product item) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      height: 300,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Card(elevation: 12,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(item.imageUrl??""), fit: BoxFit.fitWidth),
                    borderRadius:const BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title??"",
                    style:
                    const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(item.productCategoryName??"",
                      style: const TextStyle(color: Colors.grey, fontSize: 18.0)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text("\$${item.price.toString()}",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 24.0,
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(item.description??"",
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18.0, color: Colors.grey, height: 1.5,overflow: TextOverflow.ellipsis))
                ],
              ),
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0)
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
