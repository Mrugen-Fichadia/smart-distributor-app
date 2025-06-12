import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GodownCapacityChart extends StatefulWidget {
  const GodownCapacityChart({super.key});

  @override
  State<GodownCapacityChart> createState() => _GodownCapacityChartState();
}

class _GodownCapacityChartState extends State<GodownCapacityChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sectionsSpace: 4,
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  response == null ||
                  response.touchedSection == null) {
                touchedIndex = -1;
              } else {
                touchedIndex = response.touchedSection!.touchedSectionIndex;
              }
            });
          },
        ),
        sections: List.generate(3, (i) {
          final isTouched = i == touchedIndex;
          final double radius = isTouched ? 65 : 55;
          final titleStyle = TextStyle(
            fontSize: isTouched ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          );

          switch (i) {
            case 0:
              return PieChartSectionData(
                title: "Godown",
                value: 50,
                color: Colors.orange,
                radius: radius,
                showTitle: true,
                titleStyle: TextStyle(
                  fontSize: isTouched ? 13 : 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            case 1:
              return PieChartSectionData(
                title: "Amrit Sagar",
                value: 15,
                color: Colors.blue,
                radius: radius,
                showTitle: true,
                titleStyle: TextStyle(
                  fontSize: isTouched ? 13 : 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            case 2:
              return PieChartSectionData(
                title: "Hanuman Taal",
                value: 10,
                color: Colors.purple,
                radius: radius,
                showTitle: true,
                titleStyle: TextStyle(
                  fontSize: isTouched ? 13 : 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            default:
              return throw Error();
          }
        }),
      ),
    );
  }
}
