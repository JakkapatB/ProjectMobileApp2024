import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'workzone_timer.dart';

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
                      ),
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
  int selectedItemIndex = 0;
  List<String> textheader = ['EART', 'MARS', 'SATURN', 'URANUS'];
  List<String> textstory = [
    'The world has a chill atmosphere, easy work. 25-5-15',
    'Mars works a little hard but is still okay. 45-15-15',
    'Mars works a little hard but is still okay. 50-10-15',
    'Mars works a little hard but is still okay. 20-10-15'
  ];
  List<List<int>> timer = [
    [25, 5, 15],
    [45, 15, 15],
    [50, 10, 15],
    [20, 10, 15],
  ];

  Widget buildItemList(BuildContext context, int index) {
    int dataIndex = index % images.length;
    if (index == images.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    bool isSelected = index == selectedItemIndex;
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 220,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(images[dataIndex]), fit: BoxFit.cover)),
          ),
          Visibility(
            visible: isSelected,
            child: Container(
              margin: const EdgeInsets.only(top: 16.0),
              width: 220,
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: isSelected,
                    child: Text(
                      'WORK ON ${textheader[dataIndex]}',
                      style: TextStyle(
                          color: HexColor('#ffffff'),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Visibility(
                    visible: isSelected,
                    child: Text(
                      textstory[dataIndex],
                      style: TextStyle(
                        color: HexColor('#ffffff'),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 14.0),
          child: Column(
            children: [
              Text(
                '${timer[selectedItemIndex][0]}:00',
                style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#ffffff')),
              ),
              const SizedBox(height: 8.0),
              const Icon(
                Icons.timelapse_outlined,
                size: 36,
                color: Colors.white,
              )
            ],
          ),
        ),
        Expanded(
            child: ScrollSnapList(
          itemBuilder: (context, index) => buildItemList(context, index),
          itemSize: 220,
          dynamicItemSize: true,
          onReachEnd: () {
            Scrollable.ensureVisible(
              context,
              alignment: 1.0,
              duration: const Duration(milliseconds: 200),
            );
          },
          itemCount: images.length,
          onItemFocus: (int focusedIndex) {
            print('Item focused: ${focusedIndex + 1}');
            setState(() {
              selectedItemIndex = focusedIndex;
            });
          },
        )),
        Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ElevatedButton(
            onPressed: () {
              Provider.of<MainPageProvider>(context, listen: false).isMainPage =
                  false;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkzoneTimerPage(
                    selectedItemIndex: selectedItemIndex,
                    image: images[selectedItemIndex],
                    name: textheader[selectedItemIndex],
                    timerValue: timer[selectedItemIndex],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(240, 60),
                backgroundColor: HexColor('#FFD700'),
                foregroundColor: HexColor('#ffffff')),
            child: const Text(
              'Start',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class MainPageProvider extends ChangeNotifier {
  bool _isMainPage = true;

  bool get isMainPage => _isMainPage;

  set isMainPage(bool value) {
    _isMainPage = value;
    notifyListeners();
  }
}
