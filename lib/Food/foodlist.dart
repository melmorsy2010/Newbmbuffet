import 'package:http/http.dart' as http;
import 'dart:convert';

import 'food.dart';


class Foodlist {
  final String _url =
      'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/drinks.json';

  List<Food> _drinks = [];

  List<Food> get drinks => _drinks;

  Future<void> loadDrinks() async {
    try {
      final response = await http.get(Uri.parse(_url));
      final data = json.decode(response.body) as List<dynamic>;
      _drinks = data.map((json) => Food.fromJson(json)).toList();
    } catch (error) {
      print(error);
    }
  }
}
