import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math'; // For max() function in hawker deliveries
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/Profile/View/profile.dart';
import 'package:smart_distributor_app/pages/notifications/notifications_screen.dart';

class AnalysisController extends GetxController {
  var selectedCylinder = '14kg'.obs;

  final Map<String, int> stockData = {'14kg': 1000, '19kg': 750, '5kg': 500};

  final Map<String, List<Map<String, dynamic>>> dailyCylinderStock = {
    '14kg': [
      {'day': 'Jun 6', 'stock': 1000},
      {'day': 'Jun 7', 'stock': 980},
      {'day': 'Jun 8', 'stock': 970},
      {'day': 'Jun 9', 'stock': 950},
      {'day': 'Jun 10', 'stock': 940},
      {'day': 'Jun 11', 'stock': 920},
      {'day': 'Jun 12', 'stock': 910},
    ],
    '19kg': [
      {'day': 'Jun 6', 'count': 750},
      {'day': 'Jun 7', 'count': 740},
      {'day': 'Jun 8', 'count': 725},
      {'day': 'Jun 9', 'count': 710},
      {'day': 'Jun 10', 'count': 705},
      {'day': 'Jun 11', 'count': 695},
      {'day': 'Jun 12', 'count': 685},
    ],
    '5kg': [
      {'day': 'Jun 6', 'count': 500},
      {'day': 'Jun 7', 'count': 480},
      {'day': 'Jun 8', 'count': 470},
      {'day': 'Jun 9', 'count': 460},
      {'day': 'Jun 10', 'count': 455},
      {'day': 'Jun 11', 'count': 445},
      {'day': 'Jun 12', 'count': 440},
    ],
  };

  final Map<String, List<Map<String, dynamic>>> dailyDeliveryAreas = {
    'Palanpur': [
      {'day': 'Jun 6', 'count': 20},
      {'day': 'Jun 7', 'count': 22},
      {'day': 'Jun 8', 'count': 25},
      {'day': 'Jun 9', 'count': 23},
      {'day': 'Jun 10', 'count': 28},
      {'day': 'Jun 11', 'count': 26},
      {'day': 'Jun 12', 'count': 30},
    ],
    'Deesa': [
      {'day': 'Jun 6', 'count': 15},
      {'day': 'Jun 7', 'count': 18},
      {'day': 'Jun 8', 'count': 17},
      {'day': 'Jun 9', 'count': 16},
      {'day': 'Jun 10', 'count': 20},
      {'day': 'Jun 11', 'count': 19},
      {'day': 'Jun 12', 'count': 22},
    ],
    'Mehsana': [
      {'day': 'Jun 6', 'count': 12},
      {'day': 'Jun 7', 'count': 14},
      {'day': 'Jun 8', 'count': 13},
      {'day': 'Jun 9', 'count': 15},
      {'day': 'Jun 10', 'count': 16},
      {'day': 'Jun 11', 'count': 15},
      {'day': 'Jun 12', 'count': 18},
    ],
    'Ahmedabad': [
      {'day': 'Jun 6', 'count': 18},
      {'day': 'Jun 7', 'count': 20},
      {'day': 'Jun 8', 'count': 19},
      {'day': 'Jun 9', 'count': 25},
      {'day': 'Jun 10', 'count': 22},
      {'day': 'Jun 11', 'count': 28},
      {'day': 'Jun 12', 'count': 27},
    ],
    'Gandhinagar': [
      {'day': 'Jun 6', 'count': 10},
      {'day': 'Jun 7', 'count': 11},
      {'day': 'Jun 8', 'count': 10},
      {'day': 'Jun 9', 'count': 12},
      {'day': 'Jun 10', 'count': 13},
      {'day': 'Jun 11', 'count': 11},
      {'day': 'Jun 12', 'count': 14},
    ],
    'Surat': [
      {'day': 'Jun 6', 'count': 17},
      {'day': 'Jun 7', 'count': 16},
      {'day': 'Jun 8', 'count': 20},
      {'day': 'Jun 9', 'count': 21},
      {'day': 'Jun 10', 'count': 25},
      {'day': 'Jun 11', 'count': 24},
      {'day': 'Jun 12', 'count': 29},
    ],
    'Vadodara': [
      {'day': 'Jun 6', 'count': 14},
      {'day': 'Jun 7', 'count': 15},
      {'day': 'Jun 8', 'count': 16},
      {'day': 'Jun 9', 'count': 19},
      {'day': 'Jun 10', 'count': 21},
      {'day': 'Jun 11', 'count': 20},
      {'day': 'Jun 12', 'count': 26},
    ],
  };

  final Map<String, List<Map<String, dynamic>>> dailyHawkerDeliveries = {
    'Ramesh': [
      {'day': 'Jun 6', 'count': 10},
      {'day': 'Jun 7', 'count': 12},
      {'day': 'Jun 8', 'count': 15},
      {'day': 'Jun 9', 'count': 11},
      {'day': 'Jun 10', 'count': 18},
      {'day': 'Jun 11', 'count': 13},
      {'day': 'Jun 12', 'count': 16},
    ],
    'Suresh': [
      {'day': 'Jun 6', 'count': 8},
      {'day': 'Jun 7', 'count': 10},
      {'day': 'Jun 8', 'count': 11},
      {'day': 'Jun 9', 'count': 9},
      {'day': 'Jun 10', 'count': 12},
      {'day': 'Jun 11', 'count': 10},
      {'day': 'Jun 12', 'count': 11},
    ],
    'Mahesh': [
      {'day': 'Jun 6', 'count': 7},
      {'day': 'Jun 7', 'count': 8},
      {'day': 'Jun 8', 'count': 9},
      {'day': 'Jun 9', 'count': 8},
      {'day': 'Jun 10', 'count': 10},
      {'day': 'Jun 11', 'count': 9},
      {'day': 'Jun 12', 'count': 10},
    ],
  };

  Map<String, int> getTotalHawkerDeliveries() {
    Map<String, int> totals = {};
    dailyHawkerDeliveries.forEach((hawkerName, deliveries) {
      totals[hawkerName] = deliveries.fold(
        0,
        (sum, item) => sum + (item['count'] as int),
      );
    });
    return totals;
  }

  final List<Map<String, dynamic>> dailyDeliveries = [
    {'day': 'Jun 6', 'count': 50},
    {'day': 'Jun 7', 'count': 65},
    {'day': 'Jun 8', 'count': 70},
    {'day': 'Jun 9', 'count': 60},
    {'day': 'Jun 10', 'count': 80},
    {'day': 'Jun 11', 'count': 75},
    {'day': 'Jun 12', 'count': 90},
  ];

  final Map<String, List<Map<String, dynamic>>> dailyAccessoriesSold = {
    'Hoseplate': [
      {'day': 'Jun 6', 'count': 5},
      {'day': 'Jun 7', 'count': 6},
      {'day': 'Jun 8', 'count': 7},
      {'day': 'Jun 9', 'count': 5},
      {'day': 'Jun 10', 'count': 8},
      {'day': 'Jun 11', 'count': 7},
      {'day': 'Jun 12', 'count': 9},
    ],
    'DRP': [
      {'day': 'Jun 6', 'count': 3},
      {'day': 'Jun 7', 'count': 4},
      {'day': 'Jun 8', 'count': 3},
      {'day': 'Jun 9', 'count': 2},
      {'day': 'Jun 10', 'count': 5},
      {'day': 'Jun 11', 'count': 4},
      {'day': 'Jun 12', 'count': 4},
    ],
    'Hotplate': [
      {'day': 'Jun 6', 'count': 4},
      {'day': 'Jun 7', 'count': 5},
      {'day': 'Jun 8', 'count': 6},
      {'day': 'Jun 9', 'count': 5},
      {'day': 'Jun 10', 'count': 7},
      {'day': 'Jun 11', 'count': 6},
      {'day': 'Jun 12', 'count': 8},
    ],
  };

  final List<Map<String, dynamic>> dispatchReturn = [
    {'day': 'Jun 6', 'dispatched': 25, 'returned': 20},
    {'day': 'Jun 7', 'dispatched': 30, 'returned': 25},
    {'day': 'Jun 8', 'dispatched': 35, 'returned': 28},
    {'day': 'Jun 9', 'dispatched': 28, 'returned': 22},
    {'day': 'Jun 10', 'dispatched': 40, 'returned': 35},
    {'day': 'Jun 11', 'dispatched': 38, 'returned': 30},
    {'day': 'Jun 12', 'dispatched': 45, 'returned': 40},
  ];
}

class AnalysisPage extends StatelessWidget {
  final AnalysisController controller = Get.put(AnalysisController());

  @override
  Widget build(BuildContext context) {
    // Get all unique days from dailyDeliveryAreas to ensure we can filter for the last 4
    final allDeliveryDays = controller.dailyDeliveryAreas.values.first
        .map((e) => e['day'].toString())
        .toList();

    final hoseplateSalesSpots = controller.dailyAccessoriesSold['Hoseplate']!
        .asMap()
        .entries
        .map(
          (entry) =>
              FlSpot(entry.key.toDouble(), entry.value['count'].toDouble()),
        )
        .toList();
    final drpSalesSpots = controller.dailyAccessoriesSold['DRP']!
        .asMap()
        .entries
        .map(
          (entry) =>
              FlSpot(entry.key.toDouble(), entry.value['count'].toDouble()),
        )
        .toList();
    final hotplateSalesSpots = controller.dailyAccessoriesSold['Hotplate']!
        .asMap()
        .entries
        .map(
          (entry) =>
              FlSpot(entry.key.toDouble(), entry.value['count'].toDouble()),
        )
        .toList();

    final accessoryDays = controller.dailyAccessoriesSold['Hoseplate']!
        .map((e) => e['day'].toString())
        .toList();

    // Helper function to build common grid data for charts
    FlGridData buildGridData() {
      return FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        getDrawingVerticalLine: (value) =>
            FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
      );
    }

    // Helper function to build common border data for charts
    FlBorderData buildBorderData() {
      return FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      );
    }

    // Helper function to build common line touch data for line charts
    LineTouchData buildLineTouchData() {
      return LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toInt()}',
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
          tooltipRoundedRadius: 8.0,
        ),
        handleBuiltInTouches: true,
      );
    }

    // Top Delivery Areas - Bar Chart Data Preparation
    List<BarChartGroupData> topDeliveryAreaBarGroups = [];
    // Display data for the last 4 days from all available delivery days
    final List<String> targetDeliveryDays = allDeliveryDays
        .skip(allDeliveryDays.length - 4)
        .toList();

    // Define a consistent set of colors for the top 3 bars for visual consistency across days
    List<Color> areaBarColors = [
      secondary, // Color for Top 1 area
      Colors.green, // Color for Top 2 area
      Colors.orange,
    ]; // Top 1, Top 2, Top 3 colors

    for (int i = 0; i < targetDeliveryDays.length; i++) {
      String day = targetDeliveryDays[i];
      List<Map<String, dynamic>> dailyAreaCounts = [];

      // Collect delivery counts for all areas for the current day
      controller.dailyDeliveryAreas.forEach((areaName, dataList) {
        var dayData = dataList.firstWhereOrNull((item) => item['day'] == day);
        if (dayData != null) {
          dailyAreaCounts.add({'area': areaName, 'count': dayData['count']});
        }
      });

      // Sort by count in descending order to get top areas
      dailyAreaCounts.sort((a, b) => b['count'].compareTo(a['count']));
      // Take only the top 3 areas for the current day
      List<Map<String, dynamic>> top3AreasForDay = dailyAreaCounts
          .take(3)
          .toList();

      List<BarChartRodData> rodData = [];
      // Create a bar for each of the top 3 areas
      for (int j = 0; j < top3AreasForDay.length; j++) {
        rodData.add(
          BarChartRodData(
            toY: top3AreasForDay[j]['count'].toDouble(),
            color:
                areaBarColors[j %
                    areaBarColors
                        .length], // Assign colors cyclically based on rank (1st, 2nd, 3rd)
            width: 12, // Width of each individual bar within a group
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }

      // Add a BarChartGroupData for the current day, containing the top 3 bars
      topDeliveryAreaBarGroups.add(
        BarChartGroupData(
          x: i, // X-axis index for the day
          barRods: rodData,
          barsSpace: 4, // Space between the 3 bars within the same day's group
        ),
      );
    }

    // Hawker Deliveries - Bar Chart Data Preparation (New)
    final Map<String, int> totalHawkerDeliveries = controller
        .getTotalHawkerDeliveries();
    List<String> hawkerNames = totalHawkerDeliveries.keys.toList();
    List<BarChartGroupData> hawkerDeliveryBarGroups = [];
    List<Color> hawkerBarColors = [Colors.blue, Colors.green, secondary];

    for (int i = 0; i < hawkerNames.length; i++) {
      String hawkerName = hawkerNames[i];
      int totalCount = totalHawkerDeliveries[hawkerName]!;
      hawkerDeliveryBarGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: totalCount.toDouble(),
              color: hawkerBarColors[i % hawkerBarColors.length],
              width: 20, // Wider bars for total deliveries
              borderRadius: BorderRadius.circular(4),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis', style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.to(() => const ProfilePage());
          },
          child: Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2),
            ),
            child: Icon(Icons.person, size: 24),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const NotificationsPage());
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Icon(Icons.notifications, color: primary, size: 28),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cylinder Stock',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => DropdownButton<String>(
                        value: controller.selectedCylinder.value,
                        items: ['14kg', '19kg', '5kg', 'Total Stock']
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            controller.selectedCylinder.value = val!,
                        dropdownColor: offwhite,
                        style: GoogleFonts.poppins(color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => controller.selectedCylinder.value == 'Total Stock'
                          ? SizedBox(
                              height: 220,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              color: secondary,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '14kg',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '19kg',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              color: Colors.orange,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '5kg',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Total Stock',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: LineChart(
                                      LineChartData(
                                        gridData: buildGridData(),
                                        borderData: buildBorderData(),
                                        lineTouchData: LineTouchData(
                                          touchTooltipData: LineTouchTooltipData(
                                            tooltipBgColor: Colors.blueGrey
                                                .withOpacity(0.8),
                                            getTooltipItems: (touchedSpots) {
                                              return touchedSpots.map((spot) {
                                                String label = '';
                                                if (spot.barIndex == 0)
                                                  label = '14kg';
                                                if (spot.barIndex == 1)
                                                  label = '19kg';
                                                if (spot.barIndex == 2)
                                                  label = '5kg';
                                                if (spot.barIndex == 3)
                                                  label = 'Total';
                                                return LineTooltipItem(
                                                  '$label: ${spot.y.toInt()}',
                                                  GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }).toList();
                                            },
                                            tooltipRoundedRadius: 8.0,
                                          ),
                                          handleBuiltInTouches: true,
                                        ),
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              interval: 1,
                                              getTitlesWidget: (value, meta) {
                                                int index = value.toInt();
                                                final days = controller
                                                    .dailyCylinderStock['14kg']!
                                                    .map((e) => e['day'])
                                                    .toList();
                                                if (index >= 0 &&
                                                    index < days.length) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8.0,
                                                        ),
                                                    child: Text(
                                                      days[index],
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 10,
                                                          ),
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              },
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 30,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  value.toInt().toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: controller
                                                .dailyCylinderStock['14kg']!
                                                .asMap()
                                                .entries
                                                .map(
                                                  (entry) => FlSpot(
                                                    entry.key.toDouble(),
                                                    entry.value['stock']
                                                        .toDouble(),
                                                  ),
                                                )
                                                .toList(),
                                            isCurved: true,
                                            color: secondary,
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter:
                                                  (spot, percent, bar, index) =>
                                                      FlDotCirclePainter(
                                                        radius: 4,
                                                        color: bar.color!,
                                                      ),
                                            ),
                                          ),
                                          LineChartBarData(
                                            spots: controller
                                                .dailyCylinderStock['19kg']!
                                                .asMap()
                                                .entries
                                                .map(
                                                  (entry) => FlSpot(
                                                    entry.key.toDouble(),
                                                    entry.value['count']
                                                        .toDouble(),
                                                  ),
                                                )
                                                .toList(),
                                            isCurved: true,
                                            color: Colors.blue,
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter:
                                                  (spot, percent, bar, index) =>
                                                      FlDotCirclePainter(
                                                        radius: 4,
                                                        color: bar.color!,
                                                      ),
                                            ),
                                          ),
                                          LineChartBarData(
                                            spots: controller
                                                .dailyCylinderStock['5kg']!
                                                .asMap()
                                                .entries
                                                .map(
                                                  (entry) => FlSpot(
                                                    entry.key.toDouble(),
                                                    entry.value['count']
                                                        .toDouble(),
                                                  ),
                                                )
                                                .toList(),
                                            isCurved: true,
                                            color: Colors.orange,
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter:
                                                  (spot, percent, bar, index) =>
                                                      FlDotCirclePainter(
                                                        radius: 4,
                                                        color: bar.color!,
                                                      ),
                                            ),
                                          ),
                                          LineChartBarData(
                                            spots: List.generate(
                                              controller
                                                  .dailyCylinderStock['14kg']!
                                                  .length,
                                              (i) => FlSpot(
                                                i.toDouble(),
                                                controller
                                                        .dailyCylinderStock['14kg']![i]['stock']
                                                        .toDouble() +
                                                    controller
                                                        .dailyCylinderStock['19kg']![i]['count']
                                                        .toDouble() +
                                                    controller
                                                        .dailyCylinderStock['5kg']![i]['count']
                                                        .toDouble(),
                                              ),
                                            ),
                                            isCurved: true,
                                            color: Colors.green,
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter:
                                                  (spot, percent, bar, index) =>
                                                      FlDotCirclePainter(
                                                        radius: 4,
                                                        color: bar.color!,
                                                      ),
                                            ),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              color: Colors.green.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: controller
                                          .dailyCylinderStock[controller
                                              .selectedCylinder
                                              .value]!
                                          .asMap()
                                          .entries
                                          .map(
                                            (entry) => FlSpot(
                                              entry.key.toDouble(),
                                              entry.value['stock'] != null
                                                  ? entry.value['stock']
                                                        .toDouble()
                                                  : entry.value['count']
                                                        .toDouble(),
                                            ),
                                          )
                                          .toList(),
                                      isCurved: true,
                                      color: secondary,
                                      barWidth: 3,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, bar, index) =>
                                                FlDotCirclePainter(
                                                  radius: 4,
                                                  color: bar.color!,
                                                ),
                                      ),
                                    ),
                                  ],
                                  gridData: buildGridData(),
                                  borderData: buildBorderData(),
                                  lineTouchData: buildLineTouchData(),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          int index = value.toInt();
                                          final data =
                                              controller
                                                  .dailyCylinderStock[controller
                                                  .selectedCylinder
                                                  .value]!;
                                          if (index >= 0 &&
                                              index < data.length) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
                                              child: Text(
                                                data[index]['day'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          String text = value
                                              .toInt()
                                              .toString();
                                          return Text(
                                            text,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Delivery Areas',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Added legend for Top Delivery Areas
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: secondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Ahemdabad',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ), // Label for Top 1 Area
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Palanpur',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ), // Label for Top 2 Area
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Surat',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ), // Label for Top 3 Area
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        // Changed to BarChart
                        BarChartData(
                          maxY: 35, // Adjust based on your data's max count
                          gridData: buildGridData(),
                          borderData: buildBorderData(),
                          barGroups:
                              topDeliveryAreaBarGroups, // Using the new bar groups
                          alignment: BarChartAlignment.spaceAround,
                          groupsSpace: 12, // Space between day groups
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final String currentDay =
                                    targetDeliveryDays[groupIndex];
                                List<Map<String, dynamic>>
                                currentDayAllDeliveries = [];
                                // Get all areas' deliveries for the current day to find the top 3 dynamically
                                controller.dailyDeliveryAreas.forEach((
                                  areaName,
                                  dataList,
                                ) {
                                  var dayData = dataList.firstWhereOrNull(
                                    (item) => item['day'] == currentDay,
                                  );
                                  if (dayData != null) {
                                    currentDayAllDeliveries.add({
                                      'area': areaName,
                                      'count': dayData['count'],
                                    });
                                  }
                                });
                                // Sort by count in descending order
                                currentDayAllDeliveries.sort(
                                  (a, b) => b['count'].compareTo(a['count']),
                                );
                                // Get the top 3 for this specific day
                                final List<Map<String, dynamic>>
                                top3ForThisDay = currentDayAllDeliveries
                                    .take(3)
                                    .toList();

                                String areaName = 'N/A';
                                if (rodIndex < top3ForThisDay.length) {
                                  areaName = top3ForThisDay[rodIndex]['area'];
                                }

                                return BarTooltipItem(
                                  '$areaName: ${rod.toY.toInt()}', // Display area name and count
                                  GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                              tooltipRoundedRadius: 8.0,
                            ),
                            handleBuiltInTouches: true,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < targetDeliveryDays.length) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 10,
                                      child: Text(
                                        targetDeliveryDays[index], // Display the day
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value
                                        .toInt()
                                        .toString(), // Display number of deliveries
                                    style: GoogleFonts.poppins(fontSize: 11),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hawker Deliveries (Total Last Month)', // Updated title
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          maxY: totalHawkerDeliveries.values.isEmpty
                              ? 10
                              : totalHawkerDeliveries.values
                                        .reduce(max)
                                        .toDouble() +
                                    20, // Dynamic max Y
                          gridData: buildGridData(),
                          borderData: buildBorderData(),
                          barGroups: hawkerDeliveryBarGroups,
                          alignment: BarChartAlignment.spaceAround,
                          groupsSpace: 12,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                    final String hawkerName =
                                        hawkerNames[groupIndex];
                                    final int totalCount =
                                        totalHawkerDeliveries[hawkerName]!;
                                    return BarTooltipItem(
                                      '$hawkerName: $totalCount',
                                      GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                              tooltipRoundedRadius: 8.0,
                            ),
                            handleBuiltInTouches: true,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < hawkerNames.length) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 10,
                                      child: Text(
                                        hawkerNames[index],
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: GoogleFonts.poppins(fontSize: 11),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Deliveries',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          lineBarsData: [
                            LineChartBarData(
                              spots: controller.dailyDeliveries
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => FlSpot(
                                      entry.key.toDouble(),
                                      entry.value['count'].toDouble(),
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              color: secondary,
                              barWidth: 3,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) =>
                                    FlDotCirclePainter(
                                      radius: 4,
                                      color: bar.color!,
                                    ),
                              ),
                            ),
                          ],
                          gridData: buildGridData(),
                          borderData: buildBorderData(),
                          lineTouchData: buildLineTouchData(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index <
                                          controller.dailyDeliveries.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        controller
                                            .dailyDeliveries[index]['day'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: GoogleFonts.poppins(fontSize: 11),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accessory Sales',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Hoseplate',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'DRP',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Hotplate',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: hoseplateSalesSpots,
                                  isCurved: true,
                                  color: secondary,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, bar, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: bar.color!,
                                            ),
                                  ),
                                ),
                                LineChartBarData(
                                  spots: drpSalesSpots,
                                  isCurved: true,
                                  color: Colors.green,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, bar, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: bar.color!,
                                            ),
                                  ),
                                ),
                                LineChartBarData(
                                  spots: hotplateSalesSpots,
                                  isCurved: true,
                                  color: Colors.orange,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, bar, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: bar.color!,
                                            ),
                                  ),
                                ),
                              ],
                              gridData: buildGridData(),
                              borderData: buildBorderData(),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor: Colors.blueGrey.withOpacity(
                                    0.8,
                                  ),
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      String label = '';
                                      if (spot.barIndex == 0)
                                        label = 'Hoseplate';
                                      if (spot.barIndex == 1) label = 'DRP';
                                      if (spot.barIndex == 2)
                                        label = 'Hotplate';
                                      return LineTooltipItem(
                                        '$label: ${spot.y.toInt()}',
                                        GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  tooltipRoundedRadius: 8.0,
                                ),
                                handleBuiltInTouches: true,
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= 0 &&
                                          index < accessoryDays.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            accessoryDays[index],
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dispatch & Returns (Daily)',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Dispatched',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Returned',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 240,
                          child: LineChart(
                            LineChartData(
                              gridData: buildGridData(),
                              borderData: buildBorderData(),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor: Colors.blueGrey.withOpacity(
                                    0.8,
                                  ),
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      String label = spot.barIndex == 0
                                          ? 'Dispatched'
                                          : 'Returned';
                                      return LineTooltipItem(
                                        '$label: ${spot.y.toInt()}',
                                        GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  tooltipRoundedRadius: 8.0,
                                ),
                                handleBuiltInTouches: true,
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= 0 &&
                                          index <
                                              controller
                                                  .dispatchReturn
                                                  .length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            controller
                                                .dispatchReturn[index]['day'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: controller.dispatchReturn
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value['dispatched'].toDouble(),
                                        ),
                                      )
                                      .toList(),
                                  isCurved: true,
                                  color: secondary,
                                  barWidth: 4,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, bar, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: bar.color!,
                                            ),
                                  ),
                                ),
                                LineChartBarData(
                                  spots: controller.dispatchReturn
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value['returned'].toDouble(),
                                        ),
                                      )
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.green,
                                  barWidth: 4,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, bar, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: bar.color!,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
