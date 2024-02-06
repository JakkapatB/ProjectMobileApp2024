import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'workzone.dart';

class WorkzoneTimerPage extends StatelessWidget {
  final int selectedItemIndex;
  final String image;
  final String name;
  final List<int> timerValue;
  const WorkzoneTimerPage({
    super.key,
    required this.selectedItemIndex,
    required this.image,
    required this.name,
    required this.timerValue,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('#245798'),
          title: Text(
            'WORK ON $name',
            style: TextStyle(
                fontSize: 20,
                color: HexColor('#FFFFFF'),
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // ส่งค่ากลับไปที่หน้าที่เรียก WorkzoneTimerPage ด้วย Navigator.pop
              Navigator.pop(
                  context,
                  Provider.of<MainPageProvider>(context, listen: false)
                      .isMainPage = true);
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
              image: AssetImage(
                  'assets/images/Star.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(24.0),
                child: _Countdonw(
                  timerValue: timerValue[0],
                  breaktime: timerValue[1],
                  longbreaktime: timerValue[2],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12.0),
                height: 280,
                width: 280,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover)),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Text(
                  'WORK ON $name',
                  style: TextStyle(
                    fontSize: 24,
                    color: HexColor('#FFFFFF'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(
                child: TimerStepper(),
              ),
            ],
          ),
        ));
  }
}

class _Countdonw extends StatefulWidget {
  final int timerValue;
  final int breaktime;
  final int longbreaktime;
  const _Countdonw({
    required this.timerValue,
    required this.breaktime,
    required this.longbreaktime,
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
  bool isCountdown = true;
  bool isWorkTime = true;
  bool isBreakTime = false;
  bool isLongBreakTime = false;
  @override
  void initState() {
    super.initState();
    workTimeDuration = Duration(minutes: widget.timerValue);
    breakTimeDuration = Duration(minutes: widget.breaktime);
    longBreakTimeDuration = Duration(minutes: widget.longbreaktime);
    duration = workTimeDuration;
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
                )
              ]),
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
  // ... other code

  @override
  Widget build(BuildContext context) {
    final timerStepperProvider =
        Provider.of<TimerStepperProvider>(context, listen: true);
    int currentStep = timerStepperProvider.currentStep;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _StepContainer(
          imageUrl: 'assets/images/work.gif',
          backgroundColor:
              currentStep == 0 ? HexColor('#FFD700') : HexColor('#D0CBD1'),
          showImage: currentStep == 0,
          label: 'Work Time',
        ),
        _StepContainer(
          imageUrl: 'assets/images/break.gif',
          backgroundColor:
              currentStep == 1 ? HexColor('#C56BB9') : HexColor('#D0CBD1'),
          showImage: currentStep == 1,
          label: 'Break',
        ),
        _StepContainer(
          imageUrl: 'assets/images/longbreak.gif',
          backgroundColor:
              currentStep == 2 ? HexColor('#333333') : HexColor('#D0CBD1'),
          showImage: currentStep == 2,
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
          child: const Text(
            'Work Time',
            style: TextStyle(
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
