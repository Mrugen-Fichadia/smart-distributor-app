import 'package:flutter/material.dart';
import 'delivery_detail_screen.dart';
import 'new_delivery_screen.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text(
          'Deliveries',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
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
                    hintText: 'Search deliveries...',
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
                labelColor: Colors.blue[600],
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.blue[600],
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDeliveryList('all'),
          _buildDeliveryList('pending'),
          _buildDeliveryList('completed'),
          _buildDeliveryList('cancelled'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewDeliveryScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue[600],
        icon: const Icon(Icons.add),
        label: const Text('New Delivery'),
      ),
    );
  }

  Widget _buildDeliveryList(String status) {
    final deliveries = _getFilteredDeliveries(status);

    if (deliveries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No deliveries found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first delivery to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: deliveries.length,
      itemBuilder: (context, index) {
        final delivery = deliveries[index];
        return _buildDeliveryCard(delivery);
      },
    );
  }

  Widget _buildDeliveryCard(Map<String, dynamic> delivery) {
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(delivery['status']).withOpacity(0.1),
          child: Icon(
            Icons.local_shipping,
            color: _getStatusColor(delivery['status']),
          ),
        ),
        title: Text(
          delivery['customerName'],
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
              '${delivery['address']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  delivery['date'],
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.propane_tank,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  '${delivery['cylinders']} cylinders',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(delivery['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    delivery['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(delivery['status']),
                    ),
                  ),
                ),
                Text(
                  '₹${delivery['amount']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailScreen(delivery: delivery),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'in progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredDeliveries(String status) {
    final allDeliveries = [
      {
        'id': '1',
        'customerName': 'Amit Patel',
        'address': '123 MG Road, Sector 15, Gandhinagar',
        'date': '12 Jan 2024',
        'cylinders': 1,
        'amount': '950',
        'status': 'Pending',
        'phone': '+91 98765 43210',
        'orderDate': '10 Jan 2024',
        'deliveryTime': '10:00 AM - 12:00 PM',
      },
      {
        'id': '2',
        'customerName': 'Street Food Corner',
        'address': '456 Commercial Street, Ahmedabad',
        'date': '11 Jan 2024',
        'cylinders': 2,
        'amount': '1100',
        'status': 'Completed',
        'phone': '+91 87654 32109',
        'orderDate': '09 Jan 2024',
        'deliveryTime': '2:00 PM - 4:00 PM',
      },
      {
        'id': '3',
        'customerName': 'Rajesh Kumar',
        'address': '789 Park Avenue, Surat',
        'date': '13 Jan 2024',
        'cylinders': 1,
        'amount': '950',
        'status': 'In Progress',
        'phone': '+91 76543 21098',
        'orderDate': '11 Jan 2024',
        'deliveryTime': '9:00 AM - 11:00 AM',
      },
      {
        'id': '4',
        'customerName': 'Maya Restaurant',
        'address': '321 Food Court, Vadodara',
        'date': '10 Jan 2024',
        'cylinders': 3,
        'amount': '1650',
        'status': 'Cancelled',
        'phone': '+91 65432 10987',
        'orderDate': '08 Jan 2024',
        'deliveryTime': '11:00 AM - 1:00 PM',
      },
      {
        'id': '5',
        'customerName': 'Priya Sharma',
        'address': '654 Residential Complex, Rajkot',
        'date': '14 Jan 2024',
        'cylinders': 1,
        'amount': '950',
        'status': 'Pending',
        'phone': '+91 54321 09876',
        'orderDate': '12 Jan 2024',
        'deliveryTime': '3:00 PM - 5:00 PM',
      },
    ];

    var filtered = allDeliveries.where((delivery) {
      final matchesSearch = _searchQuery.isEmpty ||
          delivery['customerName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          delivery['address']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesStatus = status == 'all' ||
          delivery['status'].toString().toLowerCase() == status.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();

    return filtered;
  }
}
