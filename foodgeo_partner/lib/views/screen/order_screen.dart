import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final querySnapshot = await _firestore.collection('orders').get();
    setState(() {
      _orders = querySnapshot.docs;
      _filteredOrders = _orders;
    });
  }

  void _filterOrders(String query) {
    final filteredOrders = _orders.where((order) {
      final name = order['name'].toLowerCase();
      final description = order['description'].toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower) || description.contains(searchLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredOrders = filteredOrders;
    });
  }

  void _handleAction(String action, DocumentSnapshot order) {
    print('$action clicked for order: ${order.id}');
    // Add logic to update Firestore based on the action
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.03;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterOrders,
            ),
          ),
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
                            SizedBox(width: padding),
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
                                    '₹${order['price']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  SizedBox(height: padding / 2),
                                  Text(
                                    'Status: ${order['status']}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: fontSize * 0.9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => _handleAction('Accept', _filteredOrders[index]),
                                child: Text('Accept'),
                              ),
                            ),
                            SizedBox(width: padding / 2),
                            Expanded(
                              child: TextButton(
                                onPressed: () => _handleAction('Cancel', _filteredOrders[index]),
                                child: Text('Cancel'),
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