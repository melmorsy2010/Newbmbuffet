import 'package:http/http.dart' as http;
import 'dart:convert';

import 'drink.dart';

class DrinksList {
  final String _url =
  'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/drinkss.json';

  List<Drink> _drinks = [];

  List<Drink> get drinks => _drinks;

  Future<void> loadDrinks() async {
    try {
      final response = await http.get(Uri.parse(_url));
      final data = json.decode(response.body) as List<dynamic>;
      _drinks = data.map((json) => Drink.fromJson(json)).toList();
    } catch (error) {
      print(error);
    }
  }
}
