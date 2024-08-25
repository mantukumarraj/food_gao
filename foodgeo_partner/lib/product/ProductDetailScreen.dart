import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? restaurantName;
  String? restaurantImage;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantData();
  }

  Future<void> _fetchRestaurantData() async {
    try {
      // Fetch restaurant data using the restaurantId from product
      DocumentSnapshot restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.product['restaurantId'])
          .get();

      if (restaurantDoc.exists) {
        setState(() {
          restaurantName = restaurantDoc['name'];
          restaurantImage = restaurantDoc['imageUrl'];
        });
      }
    } catch (e) {
      print('Error fetching restaurant data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Restaurant Info
            if (restaurantName != null && restaurantImage != null) ...[
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(restaurantImage!),
                      radius: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      restaurantName!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Product Image
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Image.network(product['image']),
            ),
            // Product Name
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Product Description
            Text(
              product['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            // Product Price
            Text(
              '₹${product['price']}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
