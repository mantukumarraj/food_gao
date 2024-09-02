import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double imageHeight = screenHeight * 0.30;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Product Details',style: TextStyle(color: Colors.white),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

      ),
      body: Container(
        width: screenWidth,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.01,
          vertical: screenHeight * 0.1,
        ),

        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView(
            padding: EdgeInsets.all(screenWidth * 0.03),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                  bottom: Radius.circular(12),
                ),
                child: product['image'] != null
                    ? Image.network(
                  product['image'],
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: double.infinity,
                  height: imageHeight,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.restaurant,
                    size: imageHeight * 0.23,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                'Product Name: ${product['name'] ?? 'No product name'}',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                'Description: ${product['description'] ?? 'No product description'}',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                ' Food Category: ${product['category'] ?? 'No category'}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                'Items: ${product['items'] ?? 'No Items'}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              Text(
                'Price: ₹${product['price']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
