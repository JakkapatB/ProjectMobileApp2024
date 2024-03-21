import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'dart:async';

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

final Future<FirebaseApp> firebase = Firebase.initializeApp();
CollectionReference _foodCollection =
    FirebaseFirestore.instance.collection("Foods");

Future<void> sendPostRequest(
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

class Focusfood extends StatelessWidget {
  const Focusfood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor('#245798'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Focus Food',
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: HexColor('#245798'),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/Star.png'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment:
                        Alignment.topLeft, // Align to the top left corner
                    child: Header(), // Wrap the Header widget with Align
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: MealCard(),
                    ),
                  )
                ],
              ),
            )
            //`selectedDate` the new date selected.
            ,
          ),
        ),
      ),
    );
  }
}

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late String formattedDateTime;
  late String formattedTime;
  late int total_cal = 0;
  late User _user;
  late Stream<QuerySnapshot> _foodStream;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _foodStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Foods")
        .snapshots();

    updateDateTime(); // Call the function to update date and time
  }

  // Function to update date and time
  void updateDateTime() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time
    formattedDateTime = DateFormat('EEEE, MMMM d, y').format(now);
    formattedTime = DateFormat('h:mm a').format(now);

    // Update the UI
    setState(() {});

    // Schedule the next update after 1 minute
    Timer(Duration(minutes: 1) - Duration(seconds: now.second), updateDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
          total_cal =
              foods.fold(0, (total, food) => total + int.parse(food.kCal));
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft, // Align to the top left corner
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    formattedDateTime,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter, // Align to the top left corner
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron'),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 2,
                    color: HexColor('#C56BB9'),
                  ),
                  color: HexColor('#C56BB9'), // เพิ่มบรรทัดนี้เพื่อเพิ่มเส้นขอบ
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total calories :',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      '$total_cal Kcal',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class MealCard extends StatefulWidget {
  const MealCard({
    Key? key,
  }) : super(key: key);

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  String? selectedFood;
  int selectedFoodCal = 0;
  @override
  Widget build(BuildContext context) {
    String imagePath = _getImagePath();
    String food = _getFoods();

    Map<String, int> Food_kcal = {
      'Vegetable': 90,
      'Chicken and Vegetables': 339,
      'Shrimp Pad Thai': 462,
      'Chicken Pad Thai': 316,
      'Peanut Dressing': 580,
      'Chicken Salad': 260,
      'Flatbread, Thai Chicken': 980,
      'Thai Chicken Yellow Curry': 391,
      'Green Curry Tofu': 170,
      'fish maw': 150,
      'Shrimp Tom Yum Noodles': 320,
      'Fried Shrimp with Garlic and Pepper': 235,
      'Chicken Green Curry': 240,
      'Beef and basil rice': 622,
      'Pak Mor Rice Crackers': 26,
      'Omelet rice': 445,
      'Crispy pork with basil fried rice': 650,
      'Chicken and fried egg with basil fried rice': 630,
      'Kale and Crispy Pork Fried Rice': 670,
      'Sausage Fried Rice': 520,
    };
    List<String> foodList = Food_kcal.keys.toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.timelapse_outlined,
          size: 36,
          color: Colors.white,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 25.0),
          child: Text(
            food,
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle, // Set shape to circle
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30.0),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 30, bottom: 10, right: 30, left: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  TabBar(
                                    tabs: const [
                                      Tab(
                                          icon:
                                              Icon(Icons.text_fields_outlined)),
                                      Tab(
                                          icon:
                                              Icon(Icons.camera_alt_outlined)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 300,
                                    child: TabBarView(
                                      children: [
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              DropDownFoods(
                                                value: foodList,
                                                cal: Food_kcal,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(child: Text('Coming soon....')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                },
              );
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 60),
                backgroundColor: HexColor('#FFD700'),
                foregroundColor: HexColor('#ffffff')),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.add_circle,
                  size: 30,
                ),
                Text('Food',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  String _getImagePath() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      // Morning: Breakfast
      return 'assets/images/BraekFastFood.png';
    } else if (hour >= 12 && hour < 18) {
      // Afternoon: Lunch
      return 'assets/images/LunchFood.png';
    } else {
      // Evening/Night: Dinner
      return 'assets/images/BraekFastFood.png'; // Use different image for dinner
    }
  }

  String _getFoods() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      // Morning: Breakfast
      return 'Breakfast Time';
    } else if (hour >= 12 && hour < 18) {
      // Afternoon: Lunch
      return 'Lunch Time ';
    } else {
      // Evening/Night: Dinner
      return 'Dinner Time'; // Use different image for dinner
    }
  }
}

class DropDownFoods extends StatefulWidget {
  final List<String> value; // Change the type to List<String>
  final Map<String, int> cal; // Use Map<String, int> for calorie values
  DropDownFoods({Key? key, required this.value, required this.cal});

  @override
  State<DropDownFoods> createState() => _DropDownFoodsState();
}

class _DropDownFoodsState extends State<DropDownFoods> {
  String? dropdownValue;
  int food_cal = 0;
  late String foodName;
  late User _user;
  late Stream<QuerySnapshot> _foodStream;
  @override
  void initState() {
    super.initState();
    // _fetchTasksFuture = fetchTasks();
    _user = FirebaseAuth.instance.currentUser!;
    _foodCollection = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Foods");
    _foodStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Foods")
        .snapshots();
  }

  String _getFoods() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      // Morning: Breakfast
      return 'Breakfast Time';
    } else if (hour >= 12 && hour < 18) {
      // Afternoon: Lunch
      return 'Lunch Time ';
    } else {
      // Evening/Night: Dinner
      return 'Dinner Time'; // Use different image for dinner
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.topLeft, child: Text('Food')),
        SizedBox(
          height: 10,
        ),
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          hint: Container(
            padding: EdgeInsets.only(left: 6),
            child: const Text(
              'Select Food',
              style: TextStyle(fontSize: 16),
            ),
          ),
          value: dropdownValue,
          items: widget.value
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        item,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
              // Lookup food_cal from widget.cal using the selected food
              food_cal = widget.cal[value] ?? 0;
              foodName = value!;
            });
            // Do something when selected item is changed.
            print(value);
            print(food_cal);
          },
        ),
        Container(
            margin: EdgeInsets.only(top: 12),
            child:
                Align(alignment: Alignment.topLeft, child: Text('Calories'))),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 200,
          height: 50,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(5.0)),
          child: Center(
              child: food_cal > 0
                  ? Text(
                      '$food_cal Kcal',
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    )
                  : Text(
                      "don't have Calories",
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    )),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            onPressed: () async {
              print(food_cal);
              if (foodName != null) {
                await sendPostRequest(
                  food_cal,
                  foodName,
                  _getFoods(),
                );
              }

              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Add food',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: HexColor('#245798')),
            ),
          ),
        ),
      ],
    );
  }
}
