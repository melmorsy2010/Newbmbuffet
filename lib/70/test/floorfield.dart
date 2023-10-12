import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloorField70 extends StatefulWidget {
  final Function(int)? onChanged;

  FloorField70({required this.onChanged});

  @override
  _FloorField70State createState() => _FloorField70State();
}

class _FloorField70State extends State<FloorField70> {
  int? _selectedFloor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your delivery floor*',
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
            value: _selectedFloor,
            onChanged: (int? newValue) {
              setState(() {
                _selectedFloor = newValue;
              });
              widget.onChanged?.call(newValue!); // pass the new value to the parent widget
            },
            items: [
              DropdownMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.three_k_plus, size: 16.0,),
                    SizedBox(width: 8.0),
                    Text(
                      'Second Floor',
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
                      'Third Floor',
                      style: TextStyle(fontSize: 16.0),


                    ),
                  ],
                ),


              ),
              DropdownMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.four_k_plus, size: 16.0,),
                    SizedBox(width: 8.0),
                    Text(
                      'Fourth Floor',
                      style: TextStyle(fontSize: 16.0),


                    ),
                  ],
                ),


              ),

              DropdownMenuItem(
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.four_k_plus, size: 16.0,),
                    SizedBox(width: 8.0),
                    Text(
                      'Fifth Floor',
                      style: TextStyle(fontSize: 16.0),


                    ),
                  ],
                ),


              ),

              DropdownMenuItem(
                value: 6,
                child: Row(
                  children: [
                    Icon(Icons.four_k_plus, size: 16.0,),
                    SizedBox(width: 8.0),
                    Text(
                      'Roof',
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
