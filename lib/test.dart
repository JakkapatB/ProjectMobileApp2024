import 'package:flutter/material.dart';
import 'package:project_mobile/bar_graph/bar_graph.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<double> weeklySummary = [2.65, 5.64, 7.95, 5.62, 2.63, 4.89, 12.55];

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 200,
            // child: MyBarGraph(
            //   weeklySummary: weeklySummary,
            // ),
            child: Text('da'),
          ),
        ),
      ),
    );
  }
}
