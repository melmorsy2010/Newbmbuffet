import 'package:http/http.dart' as http;
import 'dart:convert';

import 'juice.dart';



class JUICEList66 {
  final String _url =
      'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/juice66.json';

  List<juice66> _juice = [];

  List<juice66> get juices => _juice;

  Future<void> loadDrinks() async {
    try {
      final response = await http.get(Uri.parse(_url));
      final data = json.decode(response.body) as List<dynamic>;
      _juice = data.map((json) => juice66.fromJson(json)).toList();
    } catch (error) {
      print(error);
    }
  }
}
