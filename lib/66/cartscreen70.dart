import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreenn70 extends StatefulWidget {
  @override
  _CartScreennState createState() => _CartScreennState();
}

class _CartScreennState extends State<CartScreenn70> {
  List<String>? cartItems;

  @override
  void initState() {
    super.initState();
    _getCartItems();
  }

  void _getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('cart_items')) {
      dynamic cartItemsData = prefs.get('cart_items');
      if (cartItemsData is List) {
        setState(() {
          cartItems = List<String>.from(cartItemsData);
        });
      } else if (cartItemsData is String) {
        setState(() {
          cartItems = [cartItemsData];
        });
      }
    }
  }

  void _clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cart_items');
    setState(() {
      cartItems = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cart items list has been deleted.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareCart() async {
    String message = 'My cart items:\n\n';
    message += cartItems!.join('\n');
    String encodedMessage = Uri.encodeComponent(message);
    String url = 'whatsapp://send?text=$encodedMessage';
    try {
      await launch(url);
      _clearCart();
    } catch (e) {
      print('Error sharing cart items: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartItems == null
          ? Center(
        child: Text('Your cart is empty.'),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: ListView.separated(
                  itemCount: cartItems!.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    color: Colors.grey,
                    height: 4,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItems![index],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )

            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearCart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Clear Cart',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _shareCart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Share Cart',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
