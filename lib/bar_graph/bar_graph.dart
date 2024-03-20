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
          maxY: 100,
          minY: 0,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 30,
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

  switch (value.toInt()) {
    case 0:
      text = const Text('0', style: style);
      break;
    case 10:
      text = const Text('10', style: style);
      break;
    case 20:
      text = const Text('20', style: style);
      break;
    case 30:
      text = const Text('30', style: style);
      break;
    case 40:
      text = const Text('40', style: style);
      break;
    case 50:
      text = const Text('50', style: style);
      break;
    case 60:
      text = const Text('60', style: style);
      break;
    case 70:
      text = const Text('70', style: style);
      break;
    case 80:
      text = const Text('80', style: style);
      break;
    case 90:
      text = const Text('90', style: style);
      break;
    case 100:
      text = const Text('100', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

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
