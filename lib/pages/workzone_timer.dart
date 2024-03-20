import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'workzone.dart';

class MyTasks {
  final String id;
  final String name;
  final String color;
  bool isSelected;
  final int time;
  final DateTime dateTime;

  MyTasks(
      {required this.id,
      required this.name,
      required this.color,
      this.isSelected = false,
      required this.time,
      required this.dateTime});
}

final Future<FirebaseApp> firebase = Firebase.initializeApp();
CollectionReference _taskCollection =
    FirebaseFirestore.instance.collection("Tasks");

Future<void> sendPostRequest(
  String textController,
  String color,
  bool isSelected,
) async {
  await _taskCollection.add({
    'name': textController,
    'color': color,
    'isSelected': isSelected,
    'time': 0,
    'dateTime': DateTime.now(),
  });

  // ignore: avoid_print
  print('Task added successfully');
}

class WorkzoneTimerPage extends StatefulWidget {
  final int selectedItemIndex;
  final String image;
  final String name;
  final List<int> timerValue;

  const WorkzoneTimerPage({
    Key? key,
    required this.selectedItemIndex,
    required this.image,
    required this.name,
    required this.timerValue,
  }) : super(key: key);

  @override
  _WorkzoneTimerPageState createState() => _WorkzoneTimerPageState();
}

class _WorkzoneTimerPageState extends State<WorkzoneTimerPage> {
  late Timer _timer;
  List<String> _workNames = [];

  @override
  void initState() {
    super.initState();
    _startTimer();
    fetchWorkNames(); // Fetch work names from Firebase
  }

  Future<void> fetchWorkNames() async {
    // Fetch work names from Firebase and update _workNames
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("Tasks").get();
      setState(() {
        _workNames =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching work names: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    // Start the timer to repeatedly show the delayed dialog
    _timer = Timer.periodic(Duration(hours: 1), (timer) {
      _showDelayedDialog(context);
    });
  }

  Future<void> _showDelayedDialog(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3)); // Delay for 5 seconds
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Water Reminder")),
          content: Container(
            width: 200, // Set the width of the container
            height: 200, // Set the height of the container
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/Water.png'), // Replace 'assets/image.jpg' with your image path
                fit: BoxFit
                    .cover, // Adjust the fit as needed (cover, contain, fill, etc.)
              ),
              borderRadius: BorderRadius.circular(
                  12), // Optional: Add border radius for rounded corners
              // You can add other decorations like border, boxShadow, etc. here
            ),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Drink Water',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#245798'),
        title: Text(
          'WORK ON ${widget.name}',
          style: TextStyle(
            fontSize: 20,
            color: HexColor('#FFFFFF'),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              Provider.of<MainPageProvider>(context, listen: false).isMainPage =
                  true,
            );
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: HexColor('#245798'),
          image: const DecorationImage(
            image: AssetImage('assets/images/Star.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: TimerStepper(),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              width: 300,
              child: DropDownWork(
                workNames: _workNames,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: _Countdonw(
                timerValue: widget.timerValue[0],
                breaktime: widget.timerValue[1],
                longbreaktime: widget.timerValue[2],
                image: widget.image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Countdonw extends StatefulWidget {
  final int timerValue;
  final int breaktime;
  final int longbreaktime;
  final String image;
  const _Countdonw({
    required this.timerValue,
    required this.breaktime,
    required this.longbreaktime,
    required this.image,
  });
  @override
  _CountdonwState createState() => _CountdonwState();
}

class _CountdonwState extends State<_Countdonw> {
  late Duration workTimeDuration;
  late Duration breakTimeDuration;
  late Duration longBreakTimeDuration;
  late Duration duration;
  Timer? timer;
  int numWorkTime = 0;
  int numBreakTime = 0;
  int numLongBreaktime = 0;
  int countBreak = 0;
  int total_work_m = 0;
  int total_work_s = 0;
  bool isCountdown = true;
  bool isWorkTime = true;
  bool isBreakTime = false;
  bool isLongBreakTime = false;
  bool isMusicPlaying = false; // Track the state of music
  late AudioPlayer _player;
  @override
  void initState() {
    super.initState();
    workTimeDuration = Duration(minutes: widget.timerValue);
    breakTimeDuration = Duration(minutes: widget.breaktime);
    longBreakTimeDuration = Duration(minutes: widget.longbreaktime);
    duration = workTimeDuration;
    _player = AudioPlayer();
    startTimer();
    updateCurrentStep(0);
  }

  void updateCurrentStep(int step) {
    final timerStepperProvider =
        Provider.of<TimerStepperProvider>(context, listen: false);
    timerStepperProvider.updateCurrentStep(step);
  }

  void reset() {
    setState(() {
      if (isCountdown) {
        if (isWorkTime) {
          duration = workTimeDuration;
        } else if (isBreakTime) {
          duration = breakTimeDuration;
        } else if (isLongBreakTime) {
          duration = longBreakTimeDuration;
        } else {
          duration = const Duration();
        }
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
        updateCurrentStep(0);
        if (isWorkTime) {
          countBreak += 1;
          updateCurrentStep(1);
          numWorkTime += widget.timerValue;
          if (countBreak == 3) {
            isLongBreakTime = true;
            isBreakTime = false;
          }
          if (countBreak < 4) {
            isWorkTime = false;
            isBreakTime = true;
            duration = breakTimeDuration;
            startTimer(resets: false);
          } else {
            isWorkTime = false;
            duration = longBreakTimeDuration;
            numLongBreaktime += widget.longbreaktime;
            countBreak = 0;
            updateCurrentStep(2);
            startTimer(resets: false);
          }
        } else {
          numBreakTime += widget.breaktime;
          isWorkTime = true;
          isBreakTime = false;
          duration = workTimeDuration;
          startTimer(resets: false);
        }
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    _player.play(AssetSource('audios/Beep_Short .mp3'));
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
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(12.0),
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: 250, // Adjust the width of the circular timer
                  height: 250, // Adjust the height of the circular timer
                  child: CircularTimer(
                    progress: duration.inSeconds / workTimeDuration.inSeconds,
                    strokeWidth: 10.0,
                    color: HexColor('#C56BB9'),
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
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
                        : Icons.play_circle_outline,
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
              ]),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 10),
          child: ElevatedButton(
            onPressed: () {
              Duration timeUsed = workTimeDuration - duration;
              print(
                  'Time used: ${timeUsed.inHours}:${timeUsed.inMinutes.remainder(60)}:${timeUsed.inSeconds.remainder(60)}');
              Navigator.pop(
                context,
                Provider.of<MainPageProvider>(context, listen: false)
                    .isMainPage = true,
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(240, 60),
              backgroundColor: HexColor('#FFD700'),
              foregroundColor: HexColor('#ffffff'),
            ),
            child: const Text(
              'END',
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

class TimerStepper extends StatefulWidget {
  const TimerStepper({
    super.key,
  });

  @override
  TimerStepperState createState() => TimerStepperState();
}

class TimerStepperState extends State<TimerStepper> {
  @override
  Widget build(BuildContext context) {
    final timerStepperProvider =
        Provider.of<TimerStepperProvider>(context, listen: true);
    int currentStep = timerStepperProvider.currentStep;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _StepContainer(
          imageUrl: currentStep == 0
              ? 'assets/images/work.gif'
              : 'assets/images/1.png',
          backgroundColor:
              currentStep == 0 ? HexColor('#FFD700') : HexColor('#D0CBD1'),
          label: 'Work Time',
          showImage: true,
        ),
        _StepContainer(
          imageUrl: currentStep == 1
              ? 'assets/images/break.gif'
              : 'assets/images/2.png',
          backgroundColor:
              currentStep == 1 ? HexColor('#C56BB9') : HexColor('#D0CBD1'),
          showImage: true,
          label: 'Break',
        ),
        _StepContainer(
          imageUrl: currentStep == 2
              ? 'assets/images/longbreak.gif'
              : 'assets/images/3.png',
          backgroundColor:
              currentStep == 2 ? HexColor('#333333') : HexColor('#D0CBD1'),
          showImage: true,
          label: 'Long Break',
        ),
      ],
    );
  }
}

class _StepContainer extends StatelessWidget {
  final String imageUrl;
  final Color backgroundColor;
  final bool showImage;
  final String label;

  const _StepContainer({
    required this.imageUrl,
    required this.backgroundColor,
    required this.showImage,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          painter: _LinePainter(),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: showImage
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    // Draw a line from the top to the center of the container
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TimerStepperProvider extends ChangeNotifier {
  int _currentStep = 0;

  int get currentStep => _currentStep;

  void updateCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }
}

class CircularTimer extends StatelessWidget {
  final double progress; // Value between 0 and 1 representing progress
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  const CircularTimer({
    required this.progress,
    this.strokeWidth = 10.0,
    this.color = Colors.blue,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircularTimerPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: backgroundColor,
      ),
      size: const Size(350, 350), // Set your desired size
    );
  }
}

class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  _CircularTimerPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    final startAngle =
        -90.0 * (3.141592653589793 / 180); // Start angle at 12 o'clock position
    final sweepAngle = 360.0 *
        progress *
        (3.141592653589793 / 180); // Convert progress to radians

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DropDownWork extends StatefulWidget {
  final List<String> workNames;

  const DropDownWork({Key? key, required this.workNames}) : super(key: key);

  @override
  State<DropDownWork> createState() => _DropDownWorkState();
}

class _DropDownWorkState extends State<DropDownWork> {
  String dropdownValue = '';
  String? selectedValue;
  late User _user;
  late Stream<QuerySnapshot> _taskStream;
  @override
  void initState() {
    super.initState();
    if (widget.workNames.isNotEmpty) {
      dropdownValue = widget.workNames[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      hint: Padding(
        padding: const EdgeInsets.only(left: 6.0),
        child: const Text(
          'Select Work',
          style: TextStyle(fontSize: 16),
        ),
      ),
      value: dropdownValue,
      items: widget.workNames.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select work.';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          dropdownValue = value!;
        });
        // Do something when selected item is changed.
      },
      onSaved: (value) {
        selectedValue = value;
      },
    );
  }
}

const List<String> workList = <String>[
  'Work A',
  'Work B',
  'Work C',
  'Work D'
  // Add your list of work items here
];
