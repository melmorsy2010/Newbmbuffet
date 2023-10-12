import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;

class AboutMePage extends StatefulWidget {
  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final String phoneNumber = '201011937796';

  // replace with your phone number
  void launchWhatsApp(String phoneNumber) async {
    String url = "https://wa.me/$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchWhatsApp2() async {
    String url = "https://www.facebook.com/mhammednazmy";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown[400]!, Colors.brown[800]!],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100.0,
              backgroundImage: AssetImage(
                  'assets/images/nazmy.jpg'), // replace with your profile photo
            ),
            SizedBox(height: 20.0),
            Text(
              'Mohamed Nazmy',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Be',
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
                const SizedBox(width: 20.0, height: 100.0),
                DefaultTextStyle(
                  style: GoogleFonts.cairo(
                      fontSize: 20.0,
                      color: Colors.amber
                  ),
                  child: AnimatedTextKit(
                    repeatForever: true, // make the animation repeated

                    animatedTexts: [
                      RotateAnimatedText('AWESOME'),
                      RotateAnimatedText('OPTIMISTIC'),
                      RotateAnimatedText('DIFFERENT'),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                InkWell(
                  onTap: () => launchWhatsApp2(),
                  child: Icon(
                    FontAwesome.facebook,
                    color: Colors.white,
                  ),
                ),


                SizedBox(width: 15,),
                InkWell(
                  onTap: () {
                    _launchUrl(
                        'https://www.linkedin.com/in/mohamed-nazmy-1b572656/');
                  },
                  child: Icon(
                    FontAwesome.linkedin,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15,),

                InkWell(
                  onTap: () {
                    _launchUrl(
                        'https://www.instagram.com/mohammed_nazmy/?hl=en');
                  },
                  child: Icon(
                      FontAwesome.instagram,
                      color: Colors.white

                  ),
                ),
                SizedBox(width: 15,),

                InkWell(
                  onTap: () => launchWhatsApp(phoneNumber),
                  child: Icon(
                    FontAwesome.whatsapp,
                    color: Colors.white,
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }


  void _launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }




}
