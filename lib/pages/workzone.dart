import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

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
            decoration: BoxDecoration(
              color: HexColor('#245798'),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/Star.png'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
            //This is the largest box that is the body of the app.
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
                isWorkTimeSelectd
                    ? isMeditateSelectd
                        ? const Center(child: Text("ERROR 5555"))
                        : const Expanded(child: CardHorizontal())
                    : Container(
                        color: Colors.yellow,
                        width: 100,
                        height: 100,
                      )
              ],
            ),
          )),
    );
  }
}

class CardHorizontal extends StatefulWidget {
  const CardHorizontal({super.key});

  @override
  State<CardHorizontal> createState() => _CardHorizontalState();
}

class _CardHorizontalState extends State<CardHorizontal> {
  List<String> images = [
    'assets/images/Earth.png',
    'assets/images/Mars.png',
    'assets/images/Saturn.png',
    'assets/images/Uranus.png'
  ];
  List<String> textheader = ['EART', 'MARS', 'SATURN', 'URANUS'];
  Widget buildItemList(BuildContext context, int index) {
    int dataIndex = index % images.length;
    if (index == images.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: 150,
      margin: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(images[dataIndex]), fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'WORK ON ${textheader[dataIndex]}', // You can replace this with your desired text
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#ffffff')),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: ScrollSnapList(
            itemBuilder: (context, index) => buildItemList(context, index),
            itemSize: 150,
            dynamicItemSize: true,
            onReachEnd: () {
              Scrollable.ensureVisible(
                context,
                alignment: 1.0,
                duration: const Duration(milliseconds: 300),
              );
            },
            itemCount: images.length,
            onItemFocus: (int focusedIndex) {
              print('Item focused: ${focusedIndex + 1}');
            },
          )),
        ],
      ),
    );
  }
}
