import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DriverDetailsScreen.dart';

class DeliveredProductsScreen extends StatefulWidget {
  @override
  _DeliveredProductsScreenState createState() =>
      _DeliveredProductsScreenState();
}

class _DeliveredProductsScreenState extends State<DeliveredProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _deliveredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchDeliveredProducts();
  }

  Future<void> _fetchDeliveredProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? restaurantId = prefs.getString('restaurantId');

      if (restaurantId == null) {
        print('No restaurantId found in SharedPreferences.');
        return;
      }

      // Fetch only delivered orders for the current restaurant
      final querySnapshot = await _firestore
          .collection('orders')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('status', isEqualTo: 'Delivered')
          .get();

      setState(() {
        _deliveredProducts = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching delivered products: $e');
    }
  }

  // Date format function
  String _formatDate(Timestamp orderTime) {
    final DateTime date = orderTime.toDate();
    final int hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final String period = date.hour >= 12 ? 'PM' : 'AM';
    final String minute = date.minute.toString().padLeft(2, '0');
    return '${date.day}-${date.month}-${date.year}, $hour:$minute $period';
  }

  void _navigateToDriverDetails(String driverId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverDetailsScreen(driverId: driverId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivered Products',style: TextStyle(color: Colors.white),

        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: _deliveredProducts.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.orange,),)
          : ListView.builder(
        itemCount: _deliveredProducts.length,
        itemBuilder: (context, index) {
          final order =
          _deliveredProducts[index].data() as Map<String, dynamic>;
          final orderStatus = order['status'];

          // Extract the driver who accepted the order (if any)
          List<dynamic> deliveryBoys = order['delivery_boys'] ?? [];
          String acceptedDriverId = '';

          if (deliveryBoys.isNotEmpty) {
            // Check if a driver has accepted
            acceptedDriverId = deliveryBoys[0]; // Use the first driver ID (for example)
            // You can add logic here to select the accepted driver, based on how you store the acceptance status
          }

          return GestureDetector(
            onTap: () {
              // Navigate to driver details screen with the accepted driver ID
              if (acceptedDriverId.isNotEmpty) {
                _navigateToDriverDetails(acceptedDriverId);
              } else {
                print('No accepted driver found.');
              }
            },
            child: Card(
              elevation: 4,
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                          NetworkImage(order['image']),
                          radius: 50,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('OrderDateTime: ${_formatDate(order['orderTime'])}',),
                              Text('Name: ${order['name']}',),
                              Text('Price: ${order['price']}',),
                              Text('Status: $orderStatus',),
                              SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
