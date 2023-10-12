import 'package:bmbuffet/66/test/floorfield.dart';
import 'package:bmbuffet/66/test/namefield.dart';
import 'package:bmbuffet/70/test/floorfield.dart';
import 'package:bmbuffet/test/floorfield.dart';
import 'package:bmbuffet/test/namefield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottom.dart';
import 'bottom.dart';


class DeliveryDataScreen66 extends StatefulWidget {
  final Function onSave;

  DeliveryDataScreen66({required this.onSave});

  @override
  _DeliveryDataScreen66State createState() => _DeliveryDataScreen66State();
}

class _DeliveryDataScreen66State extends State<DeliveryDataScreen66> {
  final TextEditingController _nameController = TextEditingController();
  int _floor = 1;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name66') ?? '';
    final floor = prefs.getInt('الدور66') ?? 1;
    setState(() {
      _nameController.text = name;
      _floor = floor;
    });
  }

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name66', _nameController.text);
    prefs.setInt('الدور66', _floor);

    // Navigate to next screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyBottomNavigationBar66()),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80.0),

                Center(
                  child: Text(
                    '66 Buffet!',
                    style: GoogleFonts.cairo(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Text(
                    'Let\'s set your delivery details',
                    style: GoogleFonts.cairo(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                  'EnterYour Delivery name*',
                  style: GoogleFonts.cairo(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                NameField66(
                  controller: _nameController,
                ),
                SizedBox(height: 30.0),
                FloorField66(
                  onChanged: (newValue) {
                    setState(() {
                      _floor = newValue;
                    });
                  },
                ),
                SizedBox(height: 40.0),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _nameController.text.isNotEmpty ? Colors.brown : Colors.grey,
                    ),
                    onPressed: _nameController.text.isNotEmpty ? _saveUserData : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        'Save Your Data',
                        style: GoogleFonts.cairo(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'You can edit your preferences from inside the app on Preference tab.',
                  style: GoogleFonts.cairo(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
