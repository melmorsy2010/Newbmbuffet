import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationField extends StatefulWidget {
  final Function(int)? onChanged;

  LocationField({required this.onChanged});

  @override
  _LocationFieldState createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  int? _selectedlocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose BM BUFFET*',
          style: GoogleFonts.cairo(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: DropdownButtonFormField<int>(
            value: _selectedlocation,
            onChanged: (int? newValue) {
              setState(() {
                _selectedlocation = newValue;
              });
              widget.onChanged?.call(newValue!); // pass the new value to the parent widget
            },
            items: [
              DropdownMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.three_k_plus, size: 16.0,),
                    SizedBox(width: 8.0),
                    Text(
                      'Polyoum',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.four_k_plus, size: 16.0,),
                    SizedBox(width: 8.0),
                    Text(
                      '70th',
                      style: TextStyle(fontSize: 16.0),


                    ),
                  ],
                ),


              ),
              DropdownMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.four_k_plus, size: 16.0,),
                    SizedBox(width: 8.0),
                    Text(
                      '50',
                      style: TextStyle(fontSize: 16.0),


                    ),
                  ],
                ),


              ),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select a floor';
              }
              return null;
            },
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
