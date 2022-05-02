import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "Search",
          labelStyle:const TextStyle(color:Colors.grey),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search),
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 20,
          ),

          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          isDense: true,
          focusColor: Colors.blue,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
