import 'package:http/http.dart' as http;
import 'dart:convert';

import 'drink70.dart';

class DrinksList70 {
  final String _url =
  'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/drink70.json';

  List<Drink70> _drinks = [];

  List<Drink70> get drinks => _drinks;

  Future<void> loadDrinks() async {
    try {
      final response = await http.get(Uri.parse(_url));
      final data = json.decode(response.body) as List<dynamic>;
      _drinks = data.map((json) => Drink70.fromJson(json)).toList();
    } catch (error) {
      print(error);
    }
  }
}
