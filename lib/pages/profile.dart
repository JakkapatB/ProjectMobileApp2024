import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_mobile/bar_graph/bar_graph.dart';
import 'package:project_mobile/color/color.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String selectedGraph = 'Time'; // Initial graph
  List<double> dataTime = [52, 55, 89, 55, 25, 45, 62];
  List<double> dataHealth = [40, 50, 60, 70, 80, 90, 100];
  List<double> dataTask = [50, 60, 70, 80, 70, 60, 50];
  List<double> dataCalories = [100, 90, 80, 70, 60, 50, 40];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        body: Container(
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
                  backgroundImage: AssetImage(
                      'assets/images/cat.jpg'), // Replace with your image path
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'User Name',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              _buildStatusBox(),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDataRow('8 h 30 m', 'Work Time'),
                  _buildLine(),
                  _buildDataRow('10', 'Tasks Done'),
                  _buildLine(),
                  _buildDataRow('5 h', 'Meditate'),
                ],
              ),
              SizedBox(height: 20.0),
              _buildDataGrid(),
              SizedBox(height: 20.0),
              _buildGraph(),
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

  Widget _buildStatusBox() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 233, 255, 233),
        border: Border.all(
          color: Colors.green,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        'Good',
        style: TextStyle(
          color: Colors.green,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
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
        _buildDataBox(Icons.access_time, 'Time'),
        _buildDataBox(Icons.monitor_heart, 'Health'),
        _buildDataBox(Icons.work, 'Task'),
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
    // Replace the following placeholder code with your actual graph implementation
    Widget graph;
    switch (selectedGraph) {
      case 'Time':
        graph = _buildBarGraph(dataTime);
        break;
      case 'Health':
        graph = _buildBarGraph(dataHealth);
        break;
      case 'Task':
        graph = _buildBarGraph(dataTask);
        break;
      case 'Calories':
        graph = _buildBarGraph(dataCalories);
        break;
      default:
        graph = Container();
    }

    return graph;
  }

  Widget _buildBarGraph(List<double> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      height: 200,
      child: MyBarGraph(
        weeklySummary: data,
      ),
    );
  }
}
