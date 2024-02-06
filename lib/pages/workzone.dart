import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:audioplayers/audioplayers.dart';
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
                    : Meditate()
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
    'Work like a worldly person with style. 25-5-15',
    'Work like a Martian with style. 45-15-15',
    'Work like a Saturnian with style. 50-10-15',
    'Work like a Uranus man with style. 20-10-15'
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

class Meditate extends StatefulWidget {
  const Meditate({super.key});

  @override
  _MeditateState createState() => _MeditateState();
}

class _MeditateState extends State<Meditate> {
  bool isStart = false;
  final GlobalKey<_CountdonwState> countdownKey = GlobalKey<_CountdonwState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(8.0),
          child: _Countdonw(
            key: countdownKey,
            onTimerEnd: (value) {
              setState(() {
                isStart = value;
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 12, 0, 8),
          height: 280,
          width: 280,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Meditate.png'),
                  fit: BoxFit.cover)),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isStart = !isStart;
              });
              if (isStart) {
                countdownKey.currentState?.startTimer(resets: false);
              } else if (!isStart) {
                countdownKey.currentState?.stopTimer(resets: false);
                // _player.stop();
              }
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(240, 60),
                backgroundColor:
                    !isStart ? HexColor('#FFD700') : HexColor('#C56BB9'),
                foregroundColor: HexColor('#ffffff')),
            child: Text(!isStart ? 'Start' : 'Stop',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )),
          ),
        )
      ],
    );
  }
}

class _Countdonw extends StatefulWidget {
  final Function(bool) onTimerEnd;
  const _Countdonw({super.key, required this.onTimerEnd});
  @override
  _CountdonwState createState() => _CountdonwState();
}

class _CountdonwState extends State<_Countdonw> {
  late Duration meditateTimeDuration;
  late Duration duration;
  Timer? timer;
  bool isCountdown = true;
  bool isMeditateTime = false;
  late AudioPlayer _player;
  bool isMusicPlaying = false; // Track the state of music

  @override
  void initState() {
    super.initState();
    meditateTimeDuration = Duration(minutes: 5);
    duration = meditateTimeDuration;
    _player = AudioPlayer();
  }

  void reset() {
    setState(() {
      if (isCountdown) {
        duration = meditateTimeDuration;
      } else {
        duration = const Duration();
      }
    });
  }

  void addTime() {
    const addSeconds = -1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        widget.onTimerEnd(false);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (context) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() {
      timer?.cancel();
    });
  }

  @override
  void dispose() {
    _player.dispose(); // Dispose the AudioPlayer instance
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      buildTime(),
    ]);
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    bool isRunning = timer == null ? false : timer!.isActive;
    return Column(
      children: <Widget>[
        Text(
          '$minutes:$seconds',
          style: const TextStyle(
              fontSize: 48, color: Colors.white, fontFamily: 'Orbitron'),
        ),
        Container(
          margin: const EdgeInsets.all(4.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (isRunning) {
                      stopTimer(resets: false);
                    } else {
                      startTimer(resets: false);
                    }
                  },
                  icon: Icon(
                    isRunning
                        ? Icons.stop_circle_outlined
                        : Icons.play_circle_outlined,
                  ),
                  iconSize: 40, // Set the desired icon size
                  color: Colors.white, // Set the desired icon color
                ),
                IconButton(
                  onPressed: () {
                    reset();
                  },
                  icon: const Icon(Icons.restart_alt_outlined),
                  iconSize: 40, // Set the desired icon size
                  color: Colors.white, // Set the desired icon color
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isMusicPlaying = !isMusicPlaying; // Toggle music state
                    });
                    if (isMusicPlaying) {
                      _player.play(AssetSource(
                          'audios/In Memory of Jean Talon - Mini Vandals.mp3'));
                    } else {
                      _player.stop();
                    }
                  },
                  icon: Icon(
                    (isMusicPlaying)
                        ? Icons.volume_mute_outlined
                        : Icons.volume_off_outlined,
                  ),
                  iconSize: 40,
                  color: Colors.white,
                )
              ]),
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
