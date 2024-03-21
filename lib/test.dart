import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedChartIndex = 0; // Index of the selected chart

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Multiple Charts Example'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedChartIndex = 0; // Set selected chart index
                    });
                  },
                  child: Text('Chart 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedChartIndex = 1; // Set selected chart index
                    });
                  },
                  child: Text('Chart 2'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Show Chart 1 if selectedChartIndex is 0, otherwise hide
            Visibility(
              visible: selectedChartIndex == 0,
              child: MyPieChart(data: [
                25,
                35,
                20,
                10,
                10
              ], colors: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange
              ]),
            ),
            // Show Chart 2 if selectedChartIndex is 1, otherwise hide
            Visibility(
              visible: selectedChartIndex == 1,
              child: MyPieChart(data: [
                10,
                20,
                30,
                25,
                15
              ], colors: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPieChart extends StatelessWidget {
  final List<double> data;
  final List<Color> colors;

  const MyPieChart({
    Key? key,
    required this.data,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: List.generate(
            data.length,
            (index) => PieChartSectionData(
              color: colors[index],
              value: data[index],
              title: '${data[index].toStringAsFixed(1)}%',
              radius: 80,
            ),
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
          pieTouchData: PieTouchData(enabled: false),
        ),
      ),
    );
  }
}
