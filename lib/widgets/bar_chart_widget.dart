import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../imports.dart';
import '../utils/color_palette.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 20, color: Palette.maroon),
              BarChartRodData(toY: 20, color: Colors.grey),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 10, color: Palette.maroon),
              BarChartRodData(toY: 10, color: Colors.grey),
            ],
            showingTooltipIndicators: [0],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  ["Sakku", "Heeralal"][v.toInt()],
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
