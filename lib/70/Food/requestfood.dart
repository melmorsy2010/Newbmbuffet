import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' ;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../test/floorfield.dart';
import '../test/namefield.dart';
import 'food.dart';
import 'package:bmbuffet/70/Food/foodlist.dart';




class FoodScreen70 extends StatefulWidget {
  @override
  _FoodScreen70State createState() => _FoodScreen70State();
}

class _FoodScreen70State extends State<FoodScreen70> {
  final _drinksList = Foodlist70();

  final TextEditingController _nameController = TextEditingController();
  int _floor = 1;
  List<String> _sugarOptions = ['1', '2', '3', '4',];
  String _selectedSugar = '1';
  String _searchText = '';
  var now = DateTime.now();
  String greeting = '';
  String animationAsset = '';
  Color cardColor = Colors.white;
  @override
  void initState() {
    super.initState();
    _drinksList.loadDrinks();
    _loadUserData();

  }

  Future<void> _openWhatsApp(Food70 food) async {
    final String apiUrl = 'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/70buffetcontact.json';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      print("nazmy");

      final phone = data['phone'];
      final message = '*بوفيه السبعين* لو سمحت \n المطلوب "   *${food.name}*" \n الكمية " *${_selectedSugar}* "  \n *التوصيل الى* 👈👈 "${_nameController.text}" \n  الدور " *${_floor.toString()}* "🏴󠁶󠁵󠁭󠁡󠁰󠁿🏴󠁶󠁵󠁭󠁡󠁰󠁿 ';
print(message);
      await launch('$phone&text=${Uri.encodeFull(message)}');
    } else {
      print('Failed to fetch JSON data.');
    }
  }
  void _setGreetingAndImage() {
    var hour = DateTime.now().hour;
    if (hour < 13) {
      setState(() {
        greeting = 'Good Morning!';
        cardColor = Colors.white;
        animationAsset = 'assets/images/morningh.json';
      });
    } else if (hour < 17) {
      setState(() {
        greeting = 'Good Afternoon!';
        cardColor = Colors.white;
        animationAsset = 'assets/images/daytime.json';
      });
    } else {
      setState(() {
        greeting = 'Good Evening!';
        cardColor = Colors.brown;
        animationAsset = 'assets/images/evening.json';
      });
    }
  }
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name70') ?? '';
    final floor = prefs.getInt('الدور70') ?? 1;
    setState(() {
      _nameController.text = name;
      _floor = floor;
    });
  }
  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name70', _nameController.text);
    prefs.setInt('الدور70', _floor);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Column(
          children: [




            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: TextField(
                style: GoogleFonts.cairo(),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Find Your favourite Food',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                  ),

                ),
              ),
            ),


            Expanded(
              child: FutureBuilder(
                future: _drinksList.loadDrinks(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading drinks'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _drinksList.drinks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final drink = _drinksList.drinks[index];

                      if (!_searchText.isEmpty &&
                          !drink.name.toLowerCase().contains(_searchText.toLowerCase())) {
                        return Container();
                      }

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: drink.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Text(
                                    drink.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  SizedBox(height: 8),
                                  Text(
                                    'Quantity:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),

                                  StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          DropdownButton<String>(
                                            value: _selectedSugar ?? null, // Set the default value to null
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedSugar = newValue!;
                                              });
                                            },
                                            items: _sugarOptions
                                                .map(
                                                  (String option) => DropdownMenuItem<String>(
                                                value: option == 'choose sugar' ? null : option,
                                                child: Text(
                                                  option,
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            )
                                                .toList(),
                                          ),
                                          SizedBox(height: 10),
                                          _selectedSugar == null
                                              ? Text(
                                            'Please select a sugar',
                                            style: TextStyle(color: Colors.red),
                                          )
                                              : SizedBox(),
                                          SizedBox(height: 2),

                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.send, color: Colors.brown),
                              onPressed: () {
                                var now = DateTime.now();
                                if (now.weekday == DateTime.sunday ||
                                    now.weekday == DateTime.monday ||
                                    now.weekday == DateTime.tuesday ||
                                    now.weekday == DateTime.wednesday ||
                                    now.weekday == DateTime.thursday) {
                                  if (now.hour >= 17) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Buffet Closed'),
                                          content: Text(
                                              'The buffet is closed after 5 pm .'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return null;
                                  }
                                  _openWhatsApp(drink);
                                } else {
                                  var weekdayName = DateFormat('EEEE').format(now);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Buffet Closed'),
                                        content: Text('The buffet is closed on $weekdayName.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return null;
                                }
                              },
                            ),

                          ],
                        ),);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
