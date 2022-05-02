import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_sell/app_provider.dart';
import 'package:hyper_sell/controller.dart';
import 'package:hyper_sell/models/product_model.dart';
import 'package:hyper_sell/repository.dart';
import 'package:hyper_sell/ui/customer/cart.dart';
import 'package:hyper_sell/ui/customer/category_items.dart';
import 'package:hyper_sell/ui/customer/product.dart';
import 'package:hyper_sell/ui/customer/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _cartCount = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = '';
  String email = '';
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                SharedPreferences.getInstance().then((value) {
                  List<String> _productIDs =
                      value.getStringList('products') ?? [];
                  _cartCount = _productIDs.length;
                  context.read<AppProvider>().setCartProducts();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CartScreen(productIDs: _productIDs)));
                });
              },
              icon: const Icon(Icons.shopping_basket_outlined)),
          Text(_cartCount.toString())
        ],
      ),
      drawer: _buildDrawer(context),
      body: getContent(_selectedIndex),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.blue, textTheme: Theme.of(context).textTheme),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add_outlined), label: "Fav"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.logout_outlined), label: "Log Out")
          ],
        ),
      ),
    );
  }

  Widget getContent(int index) {
    switch (index) {
      case 0:
      return Consumer<AppProvider>(
            builder: (_, provider, __)=>
            ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context,index){
          var item = provider.products[index];
          return getProductItem(item);
        }));
      case 1:
        return Search();
      case 2:
        return Container();
      default:
        return Container();
    }
  }


  _buildDrawer(BuildContext context) {
    return Drawer(
      child:  Consumer<AppProvider>(
        builder: (_, provider, __)=>

      SizedBox(
        // decoration: gradientBackground,
        width: 300,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              const Icon(
                Icons.account_circle_outlined,
                size: 50,
                color: Colors.blue,
              ),
              SizedBox(
                  height: 80.0,
                  child: Text(
                    email,
                    style: const TextStyle(color: Colors.blue, fontSize: 18),
                  )),
              const SizedBox(height: 20.0),
              ...provider.categories.map((e) => GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                            CategoryItemListScreen(category: e,)));

                },
                child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12),
                      child: Row(children: [
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            e.toString(),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ]),
                    ),
              )),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                        onPressed: () {
                          _auth.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Controller(type: 0)));
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        elevation: 0,
                        color: Colors.blue,
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ))),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),)
    );
  }


  void initData() async {
    var products = await Repository().getProducts();
    context.read<AppProvider>().updateProducts(products);
    print("fetch products ${products.length}");
    var categories = await Repository().getCategories();
    context.read<AppProvider>().updateCategories(categories);
    print("fetch categories ${categories.length}");

    SharedPreferences.getInstance().then((value) {
      uid = value.getString("uid") ?? "";
      email = value.getString("email") ?? "";
      List<String> productIDs = value.getStringList('products') ?? [];
      _cartCount = productIDs.length;
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
