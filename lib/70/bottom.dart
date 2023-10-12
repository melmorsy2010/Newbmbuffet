import 'package:bmbuffet/70/foodscreen70.dart';
import 'package:bmbuffet/aboutme.dart';
import 'package:flutter/material.dart';

import 'cartscreen70.dart';
import 'drinkscreen70.dart';



class MyBottomNavigationBar70 extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar70> {
  int _currentIndex = 0;

  List<Widget> _children = [
    DrinksScreen70(),
    FoodScreen70(),
    AboutMePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Colors.brown,
        selectedIconTheme: IconThemeData(
            color: Colors.brown
        ),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.local_drink,),
            label:  "Drink",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.food_bank_rounded,),
            label:  "Food",

          ),

          BottomNavigationBarItem(
            icon: new Icon(Icons.person,),
            label:  "About ",

          ),
        ],
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('First Screen'),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Second Screen'),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Third Screen'),
    );
  }
}
