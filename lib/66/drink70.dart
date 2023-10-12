import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drink66 {
  final String name;
  final String imageUrl;
  static const String hostName = 'https://example.com';

  Drink66({
    required this.name,
    required this.imageUrl,
  });

  factory Drink66.fromJson(Map<String, dynamic> json) {
    return Drink66(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }

  void addToCart(String selectedSugar) async {
    List<Map<String, String>> myList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('cart_items')) {
      String? jsonString = prefs.getString('cart_items');
      print("sss");
      if (jsonString != null) {
        try {
          dynamic decoded = jsonDecode(jsonString);
          if (decoded is List<dynamic>) {
            myList = decoded.map((item) => Map<String, String>.from(item)).toList();
          } else {
            print('Error decoding cart items: Unexpected format.');
          }
        } catch (e) {
          print('Error decoding cart items: $e');
        }
      }
    }

    myList.add({
      'المطلوب': name,
      'السكر': selectedSugar,
    });

// Define the text style for the "المطلوب" and "السكر" fields
    final TextStyle boldStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    final TextStyle normalStyle = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.grey[700],
    );

// Create a Map object that stores the "المطلوب" and "السكر" fields with the rich text style
    Map<String, String> richTextMap = {
      'المطلوب': 'المطلوب: $name',
      'السكر': 'السكر: $selectedSugar',
    };

// Apply the text style to each field

// Add the map to the list
    myList.add(richTextMap);

    await prefs.setString('cart_items', jsonEncode(myList));
  }








}
