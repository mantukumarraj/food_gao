import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'delivery_boyslist_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _orders = [];
  List<DocumentSnapshot> _filteredOrders = [];

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
          .get();

      setState(() {
        _orders = querySnapshot.docs;
        _filteredOrders = _orders;
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.03;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Orders'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index].data() as Map<String, dynamic>;

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
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
                            SizedBox(width:30 ,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Text(
                                    order['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  SizedBox(height: padding / 2),
                                  Text(
                                    order['description'],
                                    style: TextStyle(
                                      fontSize: fontSize * 0.9,
                                    ),
                                  ),
                                  SizedBox(height: padding / 2),
                                  Text(
                                    '${order['price']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DeliveryBoysScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange, // Background color
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                                    ),
                                    child: Text('Ready to delivery', style: TextStyle(color: Colors.white),), // Button label
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