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
          title: const Text(
            'Centered Text Example',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: HexColor('#245798'),
        ),
        body: Center(
          child: Container(
            color: HexColor('#245798'),
            child: const Center(
              child: Text(
                'Work zone',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
