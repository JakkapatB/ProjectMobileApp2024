import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Workzone extends StatefulWidget {
  const Workzone({super.key});

  @override
  WorkzoneState createState() => WorkzoneState();
}

class WorkzoneState extends State<Workzone> {
  bool isWorkTimeSelectd = true;
  bool isMeditateSelectd = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#245798'),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Work Zone',
                  style: TextStyle(
                      fontSize: 20,
                      color: HexColor('#FFFFFF'),
                      fontWeight: FontWeight.bold),
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/cat.jpg'),
                ),
              ],
            ),
          ),
          body: Container(
            width: double.infinity,
            //This is the largest box that is the body of the app.
            color: HexColor('#245798'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //This is the section that follows the app bar and is used to add sections next to the app bar.
                Container(
                  height: 116,
                  width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 16.0),
                          width: 180,
                          child: Text(
                            'Quality work comes from good health.',
                            style: TextStyle(
                                color: HexColor('#F8EDFF'),
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isWorkTimeSelectd = true;
                                    isMeditateSelectd = false;
                                  });
                                },
                                child: Text(
                                  'Work Time',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: isWorkTimeSelectd
                                          ? HexColor('#FFD700')
                                          : HexColor('#FFFFFF')),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isWorkTimeSelectd = false;
                                    isMeditateSelectd = true;
                                  });
                                },
                                child: Text(
                                  'meditate',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: isMeditateSelectd
                                          ? HexColor('#FFD700')
                                          : HexColor('#FFFFFF')),
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
                //UI work zone and meditate
              ],
            ),
          )),
    );
  }
}
