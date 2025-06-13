import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/widgets/payment_status_chart.dart';
import 'package:smart_distributor_app/widgets/product_category_chart.dart';
import 'chart_legend.dart';
import 'godown_capacity_chart.dart';
import 'in_out_chart.dart';
import 'money_line_chart.dart';

class FullChartView extends StatelessWidget {
  const FullChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("1️⃣ Product Category (Bar)"),
          const SizedBox(height: 200, child: ProductCategoryChart()),

          _sectionTitle("2️⃣ In / Out Cylinder Flow (Bar)"),
          const SizedBox(height: 220, child: InOutChart()),
          const SizedBox(height: 12),
          const ChartLegend(
            items: [
              {'label': 'Delivered', 'color': Colors.green},
              {'label': 'Returned', 'color': Colors.red},
            ],
          ),

          _sectionTitle("3️⃣ Go-down Capacity (Pie)"),
          const SizedBox(height: 220, child: GodownCapacityChart()),

          _sectionTitle("4️⃣ Payment Status (Pie)"),
          const SizedBox(height: 200, child: PaymentStatusChart()),

          _sectionTitle("5️⃣ Money Collected Over Time (Line)"),
          const SizedBox(height: 200, child: MoneyLineChart()),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    ),
  );
}
