import 'package:http/http.dart' as http;
import 'dart:convert';

import 'juice70.dart';



class JUICEList70 {
  final String _url =
      'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/juice70.json';

  List<juice70> _juice = [];

  List<juice70> get juices => _juice;

  Future<void> loadDrinks() async {
    try {
      final response = await http.get(Uri.parse(_url));
      final data = json.decode(response.body) as List<dynamic>;
      _juice = data.map((json) => juice70.fromJson(json)).toList();
    } catch (error) {
      print(error);
    }
  }
}
