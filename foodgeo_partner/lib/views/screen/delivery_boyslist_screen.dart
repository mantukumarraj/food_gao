import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgeo_partner/views/screen/order_screen.dart';

class DeliveryBoysScreen extends StatefulWidget {
  @override
  _DeliveryBoysScreenState createState() => _DeliveryBoysScreenState();
}

class _DeliveryBoysScreenState extends State<DeliveryBoysScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getDeliveryBoys() async {
    QuerySnapshot snapshot = await _firestore.collection('delivery').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Boys List', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreen(),));// Navigate back to the previous screen
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getDeliveryBoys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No delivery boys found.'));
          } else {
            List<Map<String, dynamic>> deliveryBoys = snapshot.data!;
            return ListView.builder(
              itemCount: deliveryBoys.length,
              itemBuilder: (context, index) {
                var boy = deliveryBoys[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Card ke aas-pass margin
                  elevation: 4.0, // Card ka shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Card ke corner ko rounded banana
                  ),
                  child: ListTile(
                    title: Text(boy['driverId'] ?? 'No driver Id'),
                    subtitle: Text('Name: ${boy['name'] ?? 'No name'}'),
                    onTap: () {
                      // Handle tap event (if needed)
                    },
                  ),
                );
              },
            );

          }
        },
      ),
    );
  }
}