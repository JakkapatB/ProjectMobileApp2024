import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_mobile/bar_graph/bar_graph.dart';
import 'package:project_mobile/color/color.dart';
import 'package:project_mobile/service/auth.dart';
import 'package:project_mobile/service/database.dart';

class Myfood {
  final String foodName;
  final String kCal;
  final String meal;
  final DateTime day;

  Myfood({
    required this.foodName,
    required this.kCal,
    required this.meal,
    required this.day,
  });
}

final Future<FirebaseApp> firebaseFood = Firebase.initializeApp();
CollectionReference _foodCollection =
    FirebaseFirestore.instance.collection("Foods");

Future<void> sendPostRequestFood(
  int cal,
  String foodname,
  String meal_time,
) async {
  await _foodCollection.add({
    'foodName': foodname,
    'kCal': cal,
    'meal': meal_time,
    'day': DateTime.now(),
  });

  // ignore: avoid_print
  print('Foods added successfully');
}

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

final Future<FirebaseApp> firebaseTask = Firebase.initializeApp();
CollectionReference _taskCollection =
    FirebaseFirestore.instance.collection("Tasks");

Future<void> sendPostRequestTask(
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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String selectedGraph = 'Calories';

  late User _user;
  late Stream<QuerySnapshot> _taskStream;
  late Stream<QuerySnapshot> _foodStream;
  double totalTasks = 0;
  double finishedTasks = 0;
  double total_cal = 0;
  List<String> foodNames = [];
  List<String> foodKcal = [];

  @override
  void initState() {
    super.initState();
    // _fetchTasksFuture = fetchTasks();
    _user = FirebaseAuth.instance.currentUser!;

    _taskCollection = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Tasks");
    _taskStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Tasks")
        .snapshots();
    _foodStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Foods")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    print('totalTask $totalTasks');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: HexColor('#245798'),
            image: const DecorationImage(
              image: AssetImage('assets/images/Star.png'),
              fit: BoxFit.contain,
            ),
          ),
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _taskStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<MyTasks> tasks = [];
                    final data = snapshot.data!.docs;
                    tasks = data.map((doc) {
                      return MyTasks(
                        id: doc.id,
                        name: doc['name'],
                        color: doc['color'],
                        isSelected: doc['isSelected'],
                        time: doc['time'],
                        dateTime: doc['dateTime'].toDate(),
                      );
                    }).toList();
                    // Calculate totalTasks and finishedTasks
                    totalTasks = tasks.length.toDouble();
                    finishedTasks = tasks
                        .where((task) => task.isSelected)
                        .length
                        .toDouble();

                    return Container();
                  }
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _foodStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While data is being fetched, show a loading indicator
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If there's an error in fetching data, show an error message
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Myfood> foods = [];
                    final data = snapshot.data!.docs;
                    foods = data.map((doc) {
                      Timestamp timestamp = doc['day'];
                      DateTime dateTime =
                          timestamp.toDate(); // Convert Timestamp to DateTime
                      return Myfood(
                        foodName: doc['foodName'],
                        kCal: doc['kCal'].toString(),
                        meal: doc['meal'],
                        day: dateTime, // Assign the converted DateTime object
                      );
                    }).toList();

                    foodNames = foods.map((food) => food.foodName).toList();
                    foodKcal = foods.map((food) => food.kCal).toList();

                    return Container();
                  }
                },
              ),
              Column(
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.purple, // Set border color
                        width: 4.0, // Set border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 48.0,
                      backgroundImage: _user?.photoURL != null
                          ? NetworkImage(_user!.photoURL!)
                              as ImageProvider<Object>?
                          : AssetImage(
                              'assets/images/cat.jpg'), // Default image
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _user?.displayName ?? 'User Name', // Display user name
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  _buildDataGrid(),
                  SizedBox(height: 16.0),
                  _buildGraph(),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: () {
                      AuthMethods().signOut(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red,
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.white,
    );
  }

  Widget _buildDataRow(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDataGrid() {
    return GridView.count(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 36),
      crossAxisCount: 2,
      crossAxisSpacing: 20.0,
      mainAxisSpacing: 20.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      children: [
        _buildDataBox(Icons.task, 'Tasks'),
        _buildDataBox(Icons.fastfood_outlined, 'Calories'),
      ],
    );
  }

  Widget _buildDataBox(IconData iconData, String label) {
    bool isSelected = selectedGraph == label;

    return InkWell(
      onTap: () {
        setState(() {
          selectedGraph = label;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? HexColor(colorPink) : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(iconData,
                size: 35.0, color: Colors.white), // Adjust size and color
            const SizedBox(width: 24.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph() {
    Widget graph;
    switch (selectedGraph) {
      case 'Tasks':
        graph = _buildBarGraph(selectedGraph);
        break;
      case 'Calories':
        graph = _buildBarGraph(selectedGraph);
        break;
      default:
        graph = Container();
    }

    return graph;
  }

  Widget _buildBarGraph(String graphName) {
    double heightContainer = 350;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: heightContainer,
      width: double.infinity,
      child: Column(
        children: [
          Text(
            graphName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Visibility(
            visible: graphName == 'Calories',
            child: MyPieChartFoods(
              foodName: foodNames,
              foodKcal: foodKcal,
            ),
          ),
          Visibility(
            visible: graphName == 'Tasks',
            child: MyPieChart(
              heightContainer: heightContainer,
              finishedTasks: finishedTasks,
              totalTasks: totalTasks,
            ),
          ),
        ],
      ),
    );
  }
}
