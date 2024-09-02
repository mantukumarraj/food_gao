import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../product/cooking_screen.dart';
import '../../product/delivery_boyslist_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _orders = [];
  List<DocumentSnapshot> _filteredOrders = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? restaurantId = prefs.getString('restaurantId');

      if (restaurantId == null) {
        print('No restaurantId found in SharedPreferences.');
        return;
      }

      final querySnapshot = await _firestore
          .collection('orders')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('orderTime', descending: true)
          .get();

      // Filter out orders with status 'Delivered' or 'Cancelled'
      setState(() {
        _orders = querySnapshot.docs
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['status'] != 'Delivered' && data['status'] != 'Cancelled';
        }).toList();
        _filteredOrders = _orders;
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> _handleAction(String action, DocumentSnapshot order) async {
    try {
      await _firestore.collection('orders').doc(order.id).update({
        'status': action == 'Accept' ? 'order confirm' : 'Cancelled',
      });

      // Fetch updated orders to refresh the UI
      await _fetchOrders();

      print('$action clicked for order: ${order.id}');
    } catch (e) {
      print('Error updating order: $e');
    }
  }

  String _formatDate(Timestamp orderTime) {
    final DateTime date = orderTime.toDate();
    final int hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final String period = date.hour >= 12 ? 'PM' : 'AM';
    final String minute = date.minute.toString().padLeft(2, '0');

    return '${date.day} ${_getMonthName(date.month)} ${date.year} at $hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.03;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No Orders Available',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index].data() as Map<String, dynamic>;
                final orderStatus = order['status'];

                return GestureDetector(
                  onTap: () {
                    // Navigate to CookingScreen if the status is 'preparation' or 'ready to deliver'
                    if (orderStatus == 'preparation' || orderStatus == 'ready to deliver') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CookingScreen(order: _filteredOrders[index]),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(
                        horizontal: padding, vertical: padding / 2),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(order['image']),
                                radius: screenWidth * 0.15,
                              ),
                              SizedBox(width: padding),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order Date Time : ${_formatDate(order['orderTime'])}',
                                      style: TextStyle(fontSize: fontSize),
                                    ),
                                    Text('Name : ${order['name']}'),
                                    SizedBox(height: padding / 2),
                                    Text('Price : ${order['price']}'),
                                    SizedBox(height: padding / 2),
                                    Text('Status: $orderStatus'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: padding),
                          if (orderStatus != 'order confirm' &&
                              orderStatus != 'preparation' &&
                              orderStatus != 'ready to deliver' &&
                              orderStatus != 'Delivered' &&
                              orderStatus != 'Cancelled')
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => _handleAction(
                                        'Accept', _filteredOrders[index]),
                                    child: Text('Accept'),
                                  ),
                                ),
                                SizedBox(width: padding / 2),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => _handleAction(
                                        'Cancel', _filteredOrders[index]),
                                    child: Text('Cancel'),
                                  ),
                                ),
                              ],
                            ),
                          if (orderStatus == 'order confirm')
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CookingScreen(order: _filteredOrders[index]),
                                    ),
                                  );
                                },
                                child: Text('Send to restaurant'),
                              ),
                            ),
                          if (orderStatus == 'ready to deliver')
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeliveryBoysScreen(
                                            orderId: order['orderId'],
                                          ),
                                    ),
                                  );
                                },
                                child: Text('Ready to deliver'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
