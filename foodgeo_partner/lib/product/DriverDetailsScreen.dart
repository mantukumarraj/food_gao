import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverDetailsScreen extends StatefulWidget {
  final String driverId;

  DriverDetailsScreen({required this.driverId});

  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _driverDetails;
  @override
  void initState() {
    super.initState();
    _fetchDriverDetails();
  }

  Future<void> _fetchDriverDetails() async {
    try {
      // Fetch driver details from Firestore using driverId
      final driverSnapshot = await _firestore.collection('delivery').doc(widget.driverId).get();

      if (driverSnapshot.exists) {
        setState(() {
          _driverDetails = driverSnapshot;
        });
      } else {
        // Handle the case where the driver document does not exist
        print('Driver not found');
        setState(() {
          _driverDetails = null;
        });
      }
    } catch (e) {
      print('Error fetching driver details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Details',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: _driverDetails == null
          ? Center(child: CircularProgressIndicator(color: Colors.orange,),)
          : _driverDetails!.exists
          ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 170,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding /2), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(_driverDetails!['imageUrl'] ?? 'https://via.placeholder.com/150'),
                        radius: screenWidth * 0.15,
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${_driverDetails!['name'] ?? 'N/A'}',
                            ),
                            SizedBox(height: 4), // Reduced space
                            Text(
                              'Address: ${_driverDetails!['address'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            SizedBox(height: 4), // Reduced space
                            Text(
                              'Age: ${_driverDetails!['age'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          : Center(child: Text('Driver details not found.')),
    );
  }
}
