import 'package:http/http.dart' as http;
import 'dart:convert';

import 'juice.dart';


class JUICEList {
  final String _url =
      'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/juice.json';

  List<juice> _juice = [];

  List<juice> get juices => _juice;

  Future<void> loadDrinks() async {
    try {
      final response = await http.get(Uri.parse(_url));
      final data = json.decode(response.body) as List<dynamic>;
      _juice = data.map((json) => juice.fromJson(json)).toList();
    } catch (error) {
      print(error);
    }
  }
}
