import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Workzone extends StatelessWidget {
  const Workzone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#245798'),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Work Zone',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/cat.jpg'),
                ),
              ],
            ),
          ),
          body: Container( //This is the largest box that is the body of the app.
            color: HexColor('#245798'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //This is the section that follows the app bar and is used to add sections next to the app bar.
                Container(
                  height: 116,
                  decoration: BoxDecoration(
                    color: HexColor('#245798'),
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(24.0),
                        bottomLeft: Radius.circular(24.0)),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor('#333333').withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 13.9,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
