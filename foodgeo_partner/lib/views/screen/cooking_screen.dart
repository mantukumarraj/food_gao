import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'delivery_boyslist_screen.dart';

class CookingScreen extends StatelessWidget {
  final DocumentSnapshot order;

  CookingScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    final orderId = order.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Cooking Orders', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final restaurantId = orderData['restaurantId'];
          final orderStatus = orderData['status'] ?? 'Unknown';

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('restaurants').doc(restaurantId).get(),
            builder: (context, restaurantSnapshot) {
              if (restaurantSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!restaurantSnapshot.hasData || restaurantSnapshot.data == null) {
                return Center(child: Text('No restaurant data available'));
              }

              final restaurantData = restaurantSnapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              restaurantData['imageUrl'],
                              width: double.infinity,
                              height: 200, // Adjust height as needed
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Name: ${restaurantData['name']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Location: ${restaurantData['location']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(orderData['image']),
                                radius: 50,
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderData['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      'Status: $orderStatus',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      _getOrderStatusMessage(orderStatus),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: orderStatus.toLowerCase() == 'order confirm'
                                    ? TextButton(
                                  onPressed: () => _markOrderAsPreparation(context, orderId),
                                  child: Text('Ready to Prepare'),
                                )
                                    : orderStatus.toLowerCase() == 'preparation'
                                    ? TextButton(
                                  onPressed: () => _markOrderAsReadyToDeliver(context, orderId),
                                  child: Text('Cooking Complete'),
                                )
                                    : orderStatus.toLowerCase() == 'ready to deliver'
                                    ? TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryBoysScreen(orderId: order['orderId'],),));
                                  },
                                  child: Text('Ready to dilever'),
                                )
                                    : SizedBox.shrink(), // If status is none of the above, show nothing
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _getOrderStatusMessage(String orderStatus) {
    switch (orderStatus.toLowerCase()) {
      case 'preparation':
        return 'Your product is being made, please wait for some time.';
      case 'ready to deliver':
        return 'Your product is ready.';
      default:
        return 'Status: $orderStatus';
    }
  }

  Future<void> _markOrderAsPreparation(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'preparation',
      });

    } catch (e) {
      print('Error updating order: $e');

    }
  }

  Future<void> _markOrderAsReadyToDeliver(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'ready to deliver',
      });

    } catch (e) {
      print('Error updating order: $e');


    }
  }
}