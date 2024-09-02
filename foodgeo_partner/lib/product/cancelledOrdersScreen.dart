import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelledOrdersScreen extends StatefulWidget {
  @override
  _CancelledOrdersScreenState createState() => _CancelledOrdersScreenState();
}

class _CancelledOrdersScreenState extends State<CancelledOrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _cancelledOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCancelledOrders();
  }

  Future<void> _fetchCancelledOrders() async {
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
          .where('status', isEqualTo: 'Cancelled')
          .orderBy('orderTime', descending: true)
          .get();

      setState(() {
        _cancelledOrders = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching cancelled orders: $e');
    } finally {
      setState(() {
        _loading = false;
      });
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
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
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
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          'Cancelled Orders',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      )
          : _cancelledOrders.isEmpty
          ? Center(child: Text('No cancelled orders found.'))
          : Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _cancelledOrders.length,
              itemBuilder: (context, index) {
                final order =
                _cancelledOrders[index].data() as Map<String, dynamic>;

                return Card(
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
                                    'Order Date Time: ${_formatDate(order['orderTime'])}',
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                  Text('Name: ${order['name']}'),
                                  SizedBox(height: padding / 2),
                                  Text('Price: ${order['price']}'),
                                  SizedBox(height: padding / 2),
                                  Text(
                                    'Status: ${order['status']}',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: fontSize),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
