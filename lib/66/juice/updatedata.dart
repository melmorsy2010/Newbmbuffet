import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(JsonData66());
}

class JsonData66 extends StatefulWidget {


  const JsonData66({Key? key}) : super(key: key);

  @override
  _JsonData66State createState() => _JsonData66State();
}

class _JsonData66State extends State<JsonData66> {

  TextEditingController nameController = TextEditingController();
  TextEditingController _itemImageUrlController = TextEditingController();

  List<Map<String, dynamic>> _jsonData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/drinkss.json'));

    if (response.statusCode == 200) {
      setState(() {
        _jsonData = List<Map<String, dynamic>>.from(
            json.decode(response.body) as List<dynamic>);
        print(response.body);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> _updateData() async {
    final String updateDataEndpoint = 'http://localhost:3000/updateData';
    final String token = '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';
    final String username = 'melmorsy2010';
    final String repository = 'Retailtribebuffet';
    final String branch = 'main';
    final String path = 'drinkss.json';

    // Fetch the existing file's metadata, including its sha value
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/$username/$repository/contents/$path'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final existingFileData = jsonDecode(response.body);
      final String sha = existingFileData['sha'];

      // Update the file on GitHub with the new data
      final bytes = utf8.encode(json.encode(_jsonData));
      final putResponse = await http.put(
        Uri.parse(
            'https://api.github.com/repos/$username/$repository/contents/$path'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'message': 'Update data',
          'content': base64.encode(bytes),
          'sha': sha
        }),
      );

      if (putResponse.statusCode == 200) {
        print('Data updated successfully');
      } else {
        print('Failed to update data: ${putResponse.body}');
      }
    } else {
      print('Failed to fetch existing file metadata: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Data Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Data Demo'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: _jsonData.isEmpty
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: _jsonData.length,
                            itemBuilder: (context, index) {
                              final item = _jsonData[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  leading: Image.network(
                                    item['image_url'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _jsonData.removeAt(index);
                                        });
                                      }),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final nameController = TextEditingController(text: item['name']);

                                        final imageController = TextEditingController(text: item['image_url']);

                                        return AlertDialog(
                                          title: Text('Edit Item'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  labelText: 'Name',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              TextField(
                                                controller: imageController,
                                                decoration: InputDecoration(
                                                  labelText: 'Image URL',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                final updatedItem = {
                                                  'name': nameController.text,
                                                  'image_url': imageController.text,
                                                };

                                                setState(() {
                                                  _jsonData[index] = updatedItem;
                                                });

                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _updateData,
                          child: Text('حفظ التغييرات'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Drawer(
                                  elevation: 16.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: OutlineInputBorder(),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: _itemImageUrlController,
                                          decoration: InputDecoration(
                                            labelText: 'Image URL',
                                            border: OutlineInputBorder(),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            final itemName = nameController.text;
                                            final itemImageUrl = _itemImageUrlController.text;

                                            if (itemName.isNotEmpty && itemImageUrl.isNotEmpty) {
                                              setState(() {
                                                _jsonData.add({
                                                  'name': itemName,
                                                  'image_url': itemImageUrl,
                                                });
                                              });

                                              nameController.clear();
                                              _itemImageUrlController.clear();

                                              Navigator.of(context).pop();
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Please fill in the required fields.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: Text('Add Item'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },

                          child: Text('Add New Item'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),




                      ],
                    ),

            ),
          ),
        ),
      ),
    );
  }
}
