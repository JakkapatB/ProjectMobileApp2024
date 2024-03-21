import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/bar_graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  final Color? colorBar;
  final double heightContainer;

  const MyBarGraph({
    super.key,
    required this.weeklySummary,
    this.colorBar,
    required this.heightContainer,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thurAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );
    myBarData.initializeBarData();

    return SizedBox(
      height: heightContainer - 50,
      child: BarChart(
        BarChartData(
          maxY: 5000,
          minY: 0,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 34,
                    showTitles: true,
                    getTitlesWidget: getLeftTitles)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getBottomTitles),
            ),
          ),
          barGroups: myBarData.barData
              .map(
                (data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                      toY: data.y,
                      color: colorBar,
                      width: 25,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

Widget getLeftTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget text;

  int calorieValue = (value / 1000).toInt();

  text = Text('$calorieValue k', style: style);

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('T', style: style);
      break;
    case 5:
      text = const Text('F', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}

class MyPieChart extends StatelessWidget {
  final double finishedTasks;
  final double totalTasks;
  final double heightContainer;

  MyPieChart({
    Key? key,
    required this.finishedTasks,
    required this.totalTasks,
    required this.heightContainer,
  }) : super(key: key);

  List colors = [
    Colors.red,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    double finishedPercentage = (finishedTasks / totalTasks) * 100;
    double unfinishedPercentage = 100 - finishedPercentage;

    List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        color: Colors.red,
        value: unfinishedPercentage,
        title: '${unfinishedPercentage.toStringAsFixed(1)}%',
        titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        radius: 70,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: finishedPercentage,
        title: '${finishedPercentage.toStringAsFixed(1)}%',
        titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        radius: 70,
      ),
    ];

    return AspectRatio(
      aspectRatio: 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: pieChartData,
                sectionsSpace: 0,
                centerSpaceRadius: 20,
                borderData: FlBorderData(show: false),
                startDegreeOffset: 270,
              ),
            ),
          ),
          const Column(
            children: <Widget>[
              Indicator(
                color: Colors.green,
                text: 'finish',
                isSquare: true,
              ),
              SizedBox(width: 4),
              Indicator(
                color: Colors.red,
                text: 'Not finished',
                isSquare: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class MyPieChartFoods extends StatelessWidget {
  final List<String> foodName;
  final List<String> foodKcal;

  MyPieChartFoods({required this.foodName, required this.foodKcal});

  @override
  Widget build(BuildContext context) {
    // print(foodKcal);
    // print(foodName);
    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: List.generate(
                  foodName.length,
                  (index) {
                    return PieChartSectionData(
                      color: Colors.primaries[index % Colors.primaries.length],
                      // value: double.parse(foodKcal[index]),
                      title: foodKcal[index],
                      radius: 70,
                      titleStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 20,
              ),
            ),
          ),
          Column(
            children: foodName.asMap().entries.map((entry) {
              int index = entry.key;
              String name = entry.value;

              return Padding(
                padding: EdgeInsets.only(right: 4),
                child: Indicator(
                  color: Colors.primaries[index % Colors.primaries.length],
                  text: name,
                  isSquare: true,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
