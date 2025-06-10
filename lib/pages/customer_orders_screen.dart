import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_distributor_app/app_colours.dart';
import 'package:smart_distributor_app/localized_text.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const LocalizedText(
          text: 'Customer Orders',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Info',
                'Filter feature coming soon!',
                backgroundColor: AppColors.primaryMaroon,
                colorText: Colors.white,
              );
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search customers or orders...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryMaroon,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppColors.primaryMaroon,
                tabs: const [
                  Tab(text: 'All Orders'),
                  Tab(text: 'Regular Customers'),
                  Tab(text: 'New Customers'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('all'),
          _buildOrdersList('regular'),
          _buildOrdersList('new'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddCustomerDialog();
        },
        backgroundColor: AppColors.primaryMaroon,
        icon: const Icon(Icons.person_add),
        label: const LocalizedText(text: 'Add Customer'),
      ),
    );
  }

  Widget _buildOrdersList(String type) {
    final orders = _getFilteredOrders(type);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            LocalizedText(
              text: 'No orders found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryMaroon.withOpacity(0.1),
          child: Text(
            order['customerName'][0].toUpperCase(),
            style: TextStyle(
              color: AppColors.primaryMaroon,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          order['customerName'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              order['phone'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: order['isRegular'] ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: LocalizedText(
                    text: order['isRegular'] ? 'Regular' : 'New',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: order['isRegular'] ? Colors.green[600] : Colors.orange[600],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${order['totalOrders']} orders',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocalizedText(
                  text: 'Recent Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ...order['recentOrders'].map<Widget>((recentOrder) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recentOrder['date'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${recentOrder['cylinders']} x ${recentOrder['type']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₹${recentOrder['amount']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _callCustomer(order['phone']),
                        icon: const Icon(Icons.phone, size: 16),
                        label: const LocalizedText(text: 'Call'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryMaroon,
                          side: BorderSide(color: AppColors.primaryMaroon),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _createNewOrder(order),
                        icon: const Icon(Icons.add, size: 16),
                        label: const LocalizedText(text: 'New Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryMaroon,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredOrders(String type) {
    final allOrders = [
      {
        'customerName': 'Amit Patel',
        'phone': '+91 98765 43210',
        'address': '123 MG Road, Sector 15, Gandhinagar',
        'isRegular': true,
        'totalOrders': 15,
        'recentOrders': [
          {'date': '12 Jan 2024', 'cylinders': 1, 'type': '14.2 KG', 'amount': '950'},
          {'date': '28 Dec 2023', 'cylinders': 1, 'type': '14.2 KG', 'amount': '950'},
          {'date': '15 Dec 2023', 'cylinders': 2, 'type': '14.2 KG', 'amount': '1900'},
        ],
      },
      {
        'customerName': 'Street Food Corner',
        'phone': '+91 87654 32109',
        'address': '456 Commercial Street, Ahmedabad',
        'isRegular': true,
        'totalOrders': 8,
        'recentOrders': [
          {'date': '11 Jan 2024', 'cylinders': 2, 'type': '19 KG', 'amount': '2400'},
          {'date': '05 Jan 2024', 'cylinders': 1, 'type': '19 KG', 'amount': '1200'},
        ],
      },
      {
        'customerName': 'Priya Sharma',
        'phone': '+91 54321 09876',
        'address': '654 Residential Complex, Rajkot',
        'isRegular': false,
        'totalOrders': 1,
        'recentOrders': [
          {'date': '14 Jan 2024', 'cylinders': 1, 'type': '14.2 KG', 'amount': '950'},
        ],
      },
      {
        'customerName': 'Maya Restaurant',
        'phone': '+91 65432 10987',
        'address': '321 Food Court, Vadodara',
        'isRegular': true,
        'totalOrders': 12,
        'recentOrders': [
          {'date': '10 Jan 2024', 'cylinders': 3, 'type': '19 KG', 'amount': '3600'},
          {'date': '03 Jan 2024', 'cylinders': 2, 'type': '19 KG', 'amount': '2400'},
        ],
      },
    ];

    var filtered = allOrders.where((order) {
      final matchesSearch = _searchQuery.isEmpty ||
          order['customerName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          order['phone']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final isRegular = order['isRegular'] == true;

      final matchesType = type == 'all' ||
          (type == 'regular' && isRegular) ||
          (type == 'new' && !isRegular);

      return matchesSearch && matchesType;
    }).toList();

    return filtered;
  }

  void _callCustomer(String phone) {
    print('Calling customer: $phone');
    Get.snackbar(
      'Info',
      'Calling $phone...',
      backgroundColor: AppColors.primaryMaroon,
      colorText: Colors.white,
    );
  }

  void _createNewOrder(Map<String, dynamic> customer) {
    Get.dialog(
      AlertDialog(
        title: LocalizedText(text: 'New Order for ${customer['customerName']}'),
        content: const LocalizedText(text: 'Would you like to create a new delivery order for this customer?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const LocalizedText(text: 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Redirecting to new order form...',
                backgroundColor: AppColors.primaryMaroon,
                colorText: Colors.white,
              );
            },
            child: const LocalizedText(text: 'Create Order'),
          ),
        ],
      ),
    );
  }

  void _showAddCustomerDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const LocalizedText(text: 'Add New Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const LocalizedText(text: 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                Get.back();
                Get.snackbar(
                  'Success',
                  'Customer added successfully!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: const LocalizedText(text: 'Add Customer'),
          ),
        ],
      ),
    );
  }
}