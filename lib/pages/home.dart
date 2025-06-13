import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/analysis.dart';
import 'package:smart_distributor_app/pages/dashboard.dart';
import 'package:smart_distributor_app/pages/tools.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> deliveryHistory = [
    {
      'name': 'Ramesh Patel',
      'time': '10:30 AM',
      'paymentMode': 'Cash',
      'paymentStatus': 'Confirmed',
      'cylinders': 2,
      'amount': 1200,
    },
    {
      'name': 'Anita Shah',
      'time': '04:15 PM',
      'paymentMode': 'Cash',
      'paymentStatus': 'Unconfirmed',
      'cylinders': 3,
      'amount': 1800,
    },
    {
      'name': 'Mukesh Mehta',
      'time': '11:45 AM',
      'paymentMode': 'Cash',
      'paymentStatus': 'Confirmed',
      'cylinders': 1,
      'amount': 600,
    },
    {
      'name': 'Kavita Joshi',
      'time': '03:00 PM',
      'paymentMode': 'Monthly',
      'paymentStatus': 'Confirmed',
      'cylinders': 4,
      'amount': 2400,
    },
    {
      'name': 'Vikram Desai',
      'time': '09:20 AM',
      'paymentMode': 'Cash',
      'paymentStatus': 'Unconfirmed',
      'cylinders': 2,
      'amount': 1200,
    },
  ];

  final RoleController roleController = Get.put(RoleController());

  @override
  void initState() {
    super.initState();
    roleController.setRole();
  }

  Widget deliveryCard(Map<String, dynamic> entry) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("${entry['time']}")],
                ),
                Text("Cylinders: ${entry['cylinders']}"),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${entry['paymentMode']}"),
                    SizedBox(width: 5),
                    entry['paymentMode'] == "Cash"
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: entry['paymentStatus'] == "Confirmed"
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${entry['paymentStatus']}",
                              style: TextStyle(
                                color: entry['paymentStatus'] == "Confirmed"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : SizedBox(), // Empty widget if not "Cash"
                  ],
                ),
                SizedBox(height: 4),
              ],
            ),
            Column(
              children: [
                Text("Amount", style: TextStyle(fontWeight: FontWeight.normal)),
                Text(
                  "₹${entry['amount']}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [Dashboard(), Tools(), AnalysisPage()],
        ),
        bottomNavigationBar: roleController.role.value == 'worker'
            ? null
            : BottomNavigationBar(
                currentIndex: _currentIndex,
                selectedItemColor: primary,
                unselectedItemColor: Colors.grey[600],
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.dashboard),
                    ),
                    label: "Dashboard",
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.build),
                    ),
                    label: "Tools",
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.bar_chart),
                    ),
                    label: "Analysis",
                  ),
                ],
              ),
      ),
    );
  }
}

class RoleController extends GetxController {
  var role = 'worker'.obs;

  Future<void> setRole() async {
    final prefs = await SharedPreferences.getInstance();
    role.value = prefs.getString('role') ?? 'worker';
  }
}
