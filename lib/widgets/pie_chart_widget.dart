import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';


class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: primary,
            value: 47,
            title: '19KG',
            radius: 60,
            titleStyle: const TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.grey,
            value: 10,
            title: '14.2KG',
            radius: 55,
            titleStyle: const TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            color: gray,
            value: 0,
            title: '5KG',
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
