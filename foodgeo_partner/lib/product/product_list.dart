import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';



class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10, // Spacing between columns
                  mainAxisSpacing: 10, // Spacing between rows
                  childAspectRatio: 0.6, // Aspect ratio of each item
                ),
                itemCount: data.size,
                itemBuilder: (context, index) {
                  final product = data.docs[index];
                  return ProductCard(
                    imageUrl: product['image'],
                    title: product['title'],
                    description: product['description'],
                    price: product['price'],
                    productId: product.id, // Pass the product ID to the ProductCard widget
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final String productId; // Product ID

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start, // Center the Row vertically
            children: [
            
           
              Image.network(
                imageUrl,
                width: 90,
                height: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 3),
              Text(
                'Title : $title', style: TextStyle(fontSize: 15),
              ),
              Text('Description : $description', style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                children: [
                  Text('Price : $price', style: TextStyle(fontSize: 20, color: Colors.cyan)),
                  Icon(Icons.currency_rupee, color: Colors.cyan,), // Currency icon
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to delete the product
  void deleteProduct(String productId, String imageUrl) async {
    try {
      // Delete the document from Firestore
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      // Delete the image from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (error) {
      print('Error deleting product: $error');
    }
  }
}



