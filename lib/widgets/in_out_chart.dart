import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InOutChart extends StatelessWidget {
  const InOutChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 50,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 47, color: Colors.green),
              BarChartRodData(toY: 3, color: Colors.red),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 10, color: Colors.green),
              BarChartRodData(toY: 0, color: Colors.red),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 5, color: Colors.green),
              BarChartRodData(toY: 1, color: Colors.red),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                const names = ['Sakku', 'Heeralal', 'Sanjay'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(names[value.toInt()]),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              reservedSize: 28,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }
}
