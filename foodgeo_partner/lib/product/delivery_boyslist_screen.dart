import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgeo_partner/views/screen/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryBoysScreen extends StatefulWidget {
  final String orderId;
  DeliveryBoysScreen({ Key? super.key, required this.orderId});
  @override
  _DeliveryBoysScreenState createState() => _DeliveryBoysScreenState();
}
class _DeliveryBoysScreenState extends State<DeliveryBoysScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, bool> _selectedDeliveryBoys = {};
  late Future<List<Map<String, dynamic>>> _deliveryBoysFuture = Future.value([]);
  bool _showCheckboxes = false;

  @override
  void initState() {
    super.initState();
    _initializeDeliveryBoys();
  }

  void _initializeDeliveryBoys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? restaurantId = prefs.getString('restaurantId');

    if (restaurantId == null) {
      print('No restaurantId found in SharedPreferences.');
      return;
    }

    setState(() {
      _deliveryBoysFuture = _getDeliveryBoys();
    });
  }

  Future<List<Map<String, dynamic>>> _getDeliveryBoys() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('delivery').get();
      List<Map<String, dynamic>> boys = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
      return boys;
    } catch (e) {
      print("Error fetching delivery boys: $e");
      return [];
    }
  }

  Future<void> _assignSelectedDeliveryBoys() async {
    List<String> selectedIds = _selectedDeliveryBoys.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedIds.isNotEmpty) {
      await _firestore.collection('orders').doc(widget.orderId).update({
        'delivery_boys': selectedIds,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected delivery boys assigned to order'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select drivers'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Delivery Boys', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _deliveryBoysFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No delivery boys available.'));
                } else {
                  List<Map<String, dynamic>> deliveryBoys = snapshot.data!;
                  return ListView.builder(
                    itemCount: deliveryBoys.length,
                    itemBuilder: (context, index) {
                      var boy = deliveryBoys[index];
                      String boyId = boy['id'];

                      // Initialize checkbox state
                      if (!_selectedDeliveryBoys.containsKey(boyId)) {
                        _selectedDeliveryBoys[boyId] = false;
                      }

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _showCheckboxes = true; // Long press pe checkbox dikhai denge
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            leading: ClipOval(
                              child: boy['imageUrl'] != null
                                  ? Image.network(
                                boy['imageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                                  : Icon(Icons.person, size: 50),
                            ),
                            title: Text(
                              boy['name'] ?? 'No name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address: ${boy['address'] ?? 'No address'}'),
                                Text('Age: ${boy['age'] ?? 'No age'}'),
                              ],
                            ),
                            trailing: _showCheckboxes
                                ? Checkbox(
                              activeColor: Colors.orange,
                              value: _selectedDeliveryBoys[boyId],
                              onChanged: (bool? selected) {
                                setState(() {
                                  _selectedDeliveryBoys[boyId] = selected ?? false;
                                });
                              },
                            )
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (_showCheckboxes && _selectedDeliveryBoys.containsValue(true))
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  _assignSelectedDeliveryBoys();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  'Send Request Now',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
