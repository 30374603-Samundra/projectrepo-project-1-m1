import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final db = FirebaseFirestore.instance;
  String name = "";
  String description = "";
  String price = "";
  File? productImage;
  String? category;

  List _categories = [];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                name = text;
              },
              obscureText: false,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Enter Product Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (text) {
                price = text;
              },
              obscureText: false,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Enter Product Price",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            const SizedBox(height: 20),
            TextField(
              maxLines: 8,
              onChanged: (text) {
                description = text;
              },
              obscureText: false,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Enter Product Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                value: category,
                items: _categories
                    .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: InkWell(
                onTap: () async {
                  File? selectedFile;
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                  title: const Text('Gallery'),
                                  onTap: () async {
                                    selectedFile = (await Picker().pickImage(
                                        ImageSource.gallery,
                                        cropStyle: CropStyle.rectangle));
                                    Navigator.pop(context);
                                    setState(() {
                                      productImage = selectedFile;
                                    });
                                  }),
                              ListTile(
                                  title: const Text('Camera'),
                                  onTap: () async {
                                    selectedFile = (await Picker().pickImage(
                                        ImageSource.camera,
                                        cropStyle: CropStyle.rectangle));
                                    setState(() {
                                      productImage = selectedFile;
                                    });
                                    Navigator.pop(context);
                                  })
                            ],
                          ));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        margin: const EdgeInsets.only(right: 4),
                        child: productImage == null
                            ? Container()
                            : Image.file(productImage!)),
                    productImage == null
                        ? const Text("Click to Upload")
                        : Container(),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () async {
                  var imageUrl = '';
                  if (productImage != null) {
                    imageUrl = await uploadImageToFirebase(context);
                  }
                  if (name != "" &&
                      price != "" &&
                      description != "" &&
                      productImage != null) {
                    Map<String, dynamic> data = {
                      'name': name,
                      'price': int.parse(price),
                      'description': description,
                      'search': name.toLowerCase(),
                      'category': category
                    };
                    if (imageUrl.isNotEmpty) {
                      data["image"] = imageUrl;
                    }
                    await db.collection('product').add(data).then((value) => db
                        .collection("product")
                        .doc(value.id)
                        .update({"id": value.id}));
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: "One or More Fields Empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {
    var filename = productImage!.path.split('/').last;
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(filename);
    final imagesStorageRef = storageRef.child("product/$filename");

    assert(imageRef.name == imagesStorageRef.name);
    assert(imageRef.fullPath != imagesStorageRef.fullPath);

    String filePath = productImage!.path;
    File file = File(filePath);

    try {
      return await imageRef.putFile(file).then((p0) => p0.ref.getDownloadURL());
    } on FirebaseException catch (e) {
      print("exception caught $e");
      return "";
    }
  }

  void getCategories() async {
    _categories.clear();
    var response = await db.collection('categories').get();
    var categories = response.docs.first['categories'];
    setState(() {
      // _categories.addAll(categories);
      _categories = categories;
    });
  }
}
