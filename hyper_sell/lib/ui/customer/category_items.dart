import 'package:flutter/material.dart';
import 'package:hyper_sell/app_provider.dart';
import 'package:hyper_sell/models/product_model.dart';
import 'package:hyper_sell/ui/customer/product.dart';
import 'package:provider/provider.dart';
class CategoryItemListScreen extends StatefulWidget {
  final String? category;
  const CategoryItemListScreen({Key? key,this.category}) : super(key: key);

  @override
  State<CategoryItemListScreen> createState() => _CategoryItemListScreenState();
}

class _CategoryItemListScreenState extends State<CategoryItemListScreen> {
  List<Product>? _products =[];
  @override
  void initState() {
    super.initState();
    getProducts(context);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title:  Text(widget.category??"")),
      body: _products !=null?_products!.isNotEmpty?ListView.builder(
        itemCount: _products!.length,
        itemBuilder: (context,index){
          var item = _products![index];
          return getProductItem(item);
        }):const Center(child: Text("No Products found !")):const Text("No Products found !"),);
  }

  void getProducts(BuildContext context) {
   var prods = context.read<AppProvider>().getCategoryItems(widget.category??"");
   setState(() {
     _products = prods;
   });
  }

  Widget getProductItem(Product item) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ProductScreen(product: item)));
      },
      child: Container(
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
      ),
    );
  }
}
