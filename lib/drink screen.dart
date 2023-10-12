import 'dart:convert';

import 'package:bmbuffet/test/floorfield.dart';
import 'package:bmbuffet/test/namefield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'cartscreen.dart';
import 'drinks_list.dart';
import 'drink.dart';
import 'juice/juice.dart';
import 'juice/juicelist.dart';
import 'notfiicationscreen.dart';
class DrinksScreen extends StatefulWidget {
  @override
  _DrinksScreenState createState() => _DrinksScreenState();
}

class _DrinksScreenState extends State<DrinksScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;



  final List<Tab> _tabs = [
    Tab(
      text: 'All',
    ),
    Tab(
      text: 'Hot',
    ),
    Tab(
      text: 'Cold',
    ),
  ];

  final _drinksList = DrinksList();
  final _juicelist = JUICEList();
  List<Map<String, dynamic>> _cartItems = [];

  String _link = '';
  String greeting = '';
  String animationAsset = '';
  Color cardColor = Colors.white;
  var now = DateTime.now();

  final TextEditingController _nameController = TextEditingController();
  int _floor = 1;
  List<String> _sugarOptions = ['بدون سكر(سادة)', 'مظبوط', 'زيادة', 'مانو','ع الريحة'];
  String? _selectedSugar;
  String _searchText = '';
  bool buffetOpen = true;

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened with payload: ${message.data}');

      // Extract notification data from the message
      final notification = message.notification;
      final data = message.data;

      // Navigate to the NotificationScreen and pass the notification data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(
            title: notification?.title ?? 'No Title',
            body: notification?.body ?? 'No Body', notificationData: {},
          ),
        ),
      );
    });




    super.initState();
    _drinksList.loadDrinks();
    _juicelist.loadDrinks();
    _loadUserData();
    _fetchLink();
    _setGreetingAndImage();
    _tabController = TabController(length: 2, vsync: this);


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




  Future<void> _openWhatsApp2(juice juice) async {
    final String apiUrl = 'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/number.json';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      print("nazmy");

      final phone = data['phone'];
      final message = 'لو سمحت \n المطلوب "   *${juice.name}*🍵🍵" \n *التوصيل الى* 👈👈 "${_nameController.text}" \n  الدور " *${_floor.toString()}* "🏴󠁶󠁵󠁭󠁡󠁰󠁿🏴󠁶󠁵󠁭󠁡󠁰󠁿 ';

      await launch('$phone&text=${Uri.encodeFull(message)}');
    } else {
      print('Failed to fetch JSON data.');
    }
  }


  Future<void> _openWhatsApp(Drink drink) async {
    final String apiUrl = 'https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/number.json';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      print("nazmy");

      final phone = data['phone'];
      final message = 'لو سمحت \n المطلوب "   *${drink.name}*🍵🍵" \n السكر " *${_selectedSugar}* "  \n *التوصيل الى* 👈👈 "${_nameController.text}" \n  الدور " *${_floor.toString()}* "🏴󠁶󠁵󠁭󠁡󠁰󠁿🏴󠁶󠁵󠁭󠁡󠁰󠁿 ';

      await launch('$phone&text=${Uri.encodeFull(message)}');
    } else {
      print('Failed to fetch JSON data.');
    }
  }
  void addItemToCart(Map<String, dynamic> cartItem) {
    setState(() {
      _cartItems.add(cartItem);
    });
    _saveCartItems();
  }
  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = json.encode(_cartItems);
    await prefs.setString('cart_items', cartItemsJson);
  }
  void _sendRequest(Drink drink) async {
    // Get the device token of the other user from your Firebase database or another source
    String? deviceToken = "eHeGMB2eQ6iW11usxrW7FB:APA91bGV_Y5LA5rHSYgzzwE2KB-biLXCmH71d6xUkXNpJ2lX9diqfwFk0pmdheLwLU7VC8t5sSNxNDiU8iPYoZKDCUNrUpk8GXN6gfuOrv6X8r3vOVRNaeelaWfC1AAXMvdR6ia63tnc";

    // Set up the FCM message
    var message1 = {
      "notification": {
        "title": "New drink request",
        "body": "You have a new drink request from ${drink.name}"
      },
      "data": {
        "drink_name": drink.name,
        "sugar_level": _selectedSugar ?? "No sugar selected",
      },
      "token": deviceToken,
    };

    try {
      String jsonString = json.encode(message1);
      print(jsonString);
      await FirebaseMessaging.instance.sendMessage(messageId: jsonString);
    } catch (e) {
      print("Failed to encode message: ${e.toString()}");
      String jsonString = "{\"error\": \"Failed to encode message\"}";
      await FirebaseMessaging.instance.sendMessage(messageId: jsonString);
    }
  }
  Future<void> _sendNotification(Drink drink) async {
    // Create a notification payload with the drink details
    final payload = {
      'notification': {
        'title': 'New Drink Added',
        'body': '${drink.name} is now available!',
        'sound': 'default'
      },
      'data': {
        'drinkId': drink.name // Optionally, include additional data like the drink ID
      }
    };

    // TODO: Send the notification payload to the user's device using a messaging service like Firebase Cloud Messaging

    // Show a toast message to confirm that the notification was sent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification sent!')),
    );
  }
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final floor = prefs.getInt('الدور') ?? 1;
    setState(() {
      _nameController.text = name;
      _floor = floor;
    });
  }

  Future<void> _fetchLink() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/melmorsy2010/Retailtribebuffet/main/number.json'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _link = json['link'];
      });
    } else {
      throw Exception('Failed to load link');
    }
  }

  void _onSharePressed() async {
    if (_link.isNotEmpty) {
      await Share.share(_link);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Link is not available'),
      ));
    }
  }

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setInt('الدور', _floor);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,

      appBar:
      AppBar(
        title: Text('Polyom Buffet'),
        backgroundColor: Colors.brown[900],
        centerTitle: true,


      ),

      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child:
                Card(
                  surfaceTintColor:Colors.brown,
                  shadowColor: Colors.brown,
                  elevation: 3,

                  borderOnForeground: true, // Set this to true if you want the border to appear on top of the card content
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Set the border radius of the card
                    side: BorderSide(
                      color: Colors.grey, // Set the border color
                      width: 0.0, // Set the border width
                    ),
                  ),

                  color: cardColor,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.brown[900]!, Colors.brown[800]!, Colors.brown[600]!],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  greeting,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    _nameController.text,
                                    style: GoogleFonts.cairo(

                                      color: Colors.yellow,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(left: 17),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Delivery to ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Floor ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '$_floor',
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                ),

                                SizedBox(height: 10),

                              ],
                            ),

                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red[300],),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 600.0,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20,right: 20),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Enter your Delivery name*',
                                                    style: GoogleFonts.cairo(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  NameField(
                                                    controller: _nameController,
                                                  ),
                                                  SizedBox(height: 30.0),
                                                  FloorField(
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _floor = newValue;
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(height: 20.0),
                                                  Center(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.brown,),
                                                      onPressed: () {
                                                        _saveUserData();
                                                      },
                                                      child: Text('Update your Data'),
                                                    ),
                                                  ),
                                                  // add your form fields here
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Edit Delivery Data',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              ),
            ),
      TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Text(
              'Hot Drinks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Tab(
            child: Text(
              'Cold Drinks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
        indicator: CustomTabIndicator(),
        labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
        onTap: (index) {},
        overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Tab(
                    child: Container(
                      child:   Column(
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
                                hintText: 'Find Your favourite Drink',
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

                                    return  Card(
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

                                                SizedBox(height: 8),
                                                Text(
                                                  'Select your sugar:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        DropdownButton<String>(
                                                          value: _selectedSugar ?? null, // Set the default value to null
                                                          onChanged: (String? newValue) {
                                                            setState(() {
                                                              _selectedSugar = newValue;
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
                  ),
                  Tab(
                    child:
                    Container(
                      child:   Column(
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
                                hintText: 'Find Your favourite Drink',
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
                              future: _juicelist.loadDrinks(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error loading drinks'));
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _juicelist.juices.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final Juice = _juicelist.juices[index];

                                    if (!_searchText.isEmpty &&
                                        !Juice.name.toLowerCase().contains(_searchText.toLowerCase())) {
                                      return Container();
                                    }

                                    return  Card(
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
                                                imageUrl: Juice.imageUrl,
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
                                                  Juice.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 8),

                                                SizedBox(height: 8),










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
                                                _openWhatsApp2(Juice);
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
                  ),
                ],
              ),
            ),
          ],

        ),
      ),





    );

  }
}

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = Offset(offset.dx, offset.dy + configuration.size!.height - 4.0) &
    Size(configuration.size!.width, 4.0);
    final paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(2.0)), paint);
  }
}