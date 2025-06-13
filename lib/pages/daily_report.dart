import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/report_card_extended.dart';
import '../widgets/full_chart_view.dart';
import '../services/pdf_service.dart';
import '../utils/color_palette.dart';

class DailyReportScreen extends StatefulWidget {
  const DailyReportScreen({super.key});

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  bool showList = true;

  void _toggleView() {
    setState(() => showList = !showList);
  }

  void _generatePDF() async {
    CustomSnackbar.show(context, "Generating PDF...");

    final reportData = [
      {
        'product': '19KG Cylinder',
        'qty': '50',
        'rate': '1970',
        'amount': '98500',
        'in': '47',
        'out': '50',
        'man': 'Sakku',
        'status': 'Paid',
      },
      {
        'product': '14.2KG Cylinder',
        'qty': '10',
        'rate': '932',
        'amount': '9320',
        'in': '10',
        'out': '10',
        'man': 'Heeralal',
        'status': 'Paid',
      },
      {
        'product': '5KG Cylinder',
        'qty': '5',
        'rate': '633',
        'amount': '3165',
        'in': '0',
        'out': '5',
        'man': 'Sanjay',
        'status': 'Unpaid',
      },
      {
        'product': 'DRP',
        'qty': '8',
        'rate': '150',
        'amount': '1200',
        'in': '0',
        'out': '8',
        'man': 'Ravi',
        'status': 'Paid',
      },
      {
        'product': 'Hose Pipe',
        'qty': '12',
        'rate': '100',
        'amount': '1200',
        'in': '0',
        'out': '12',
        'man': 'Manoj',
        'status': 'Paid',
      },
    ];

    await PDFService.generateReportFromData(reportData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.ashBackground,
      appBar: AppBar(
        backgroundColor: Palette.maroon,
        title: Text(
          "Daily Report",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _toggleView,
            icon: Icon(
              showList ? Icons.bar_chart : Icons.list,
              color: Colors.white,
            ),
            tooltip: showList ? "Chart View" : "List View",
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: showList ? const ListReportView() : const FullChartView(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Palette.maroon,
        onPressed: _generatePDF,
        label: const Text(
          "Generate PDF",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
      ),
    );
  }
}

class ListReportView extends StatelessWidget {
  const ListReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final reportData = [
      {
        'product': '19KG Cylinder',
        'qty': '50',
        'rate': '1970',
        'amount': '98500',
        'in': '47',
        'out': '50',
        'paidQty': '50', // Fully Paid ✅
      },
      {
        'product': '14.2KG Cylinder',
        'qty': '20',
        'rate': '932',
        'amount': '18640',
        'in': '20',
        'out': '20',
        'paidQty': '10', // Partially Paid 🟧
      },
      {
        'product': '5KG Cylinder',
        'qty': '10',
        'rate': '633',
        'amount': '6330',
        'in': '7',
        'out': '10',
        'paidQty': '8', // Partially Paid 🟧
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reportData.length,
      itemBuilder: (context, index) {
        final data = reportData[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 12),
          child: ReportCardExtended(
            product: data['product']!,
            qty: data['qty']!,
            rate: data['rate']!,
            amount: data['amount']!,
            inVal: data['in']!,
            outVal: data['out']!,
            paidQty: data['paidQty']!,
          ),
        );
      },
    );
  }
}
