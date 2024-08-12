import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatelessWidget {
  final String restaurantId;

  ProductListScreen({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Product List",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back icon color to white
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantId)
            .snapshots(),
        builder: (context, restaurantSnapshot) {
          if (restaurantSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (restaurantSnapshot.hasError) {
            return Center(child: Text('Error: ${restaurantSnapshot.error}'));
          } else if (!restaurantSnapshot.hasData || !restaurantSnapshot.data!.exists) {
            return Center(child: Text('Restaurant not found.'));
          } else {
            var restaurantData = restaurantSnapshot.data!.data() as Map<String, dynamic>;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('restaurantId', isEqualTo: restaurantId)
                  .snapshots(),
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (productSnapshot.hasError) {
                  return Center(child: Text('Error: ${productSnapshot.error}'));
                } else if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No products found.'));
                } else {
                  var products = productSnapshot.data!.docs;

                  return ListView(
                    children: [
                      // Restaurant Details
                      Card(
                        margin: EdgeInsets.all(10.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              restaurantData['imageUrl'] != null
                                  ? Image.network(
                                restaurantData['imageUrl'],
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                                  : Icon(Icons.restaurant, size: 100),
                              SizedBox(height: 10),
                              Text(
                                'Restaurant Name: ${restaurantData['name'] ?? 'No restaurant name'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Owner: ${restaurantData['ownerName'] ?? 'No owner'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text('Address: ${restaurantData['address'] ?? 'No address'}'),
                              Text('Location: ${restaurantData['location'] ?? 'No location'}'),
                              Text('Category: ${restaurantData['category'] ?? 'No category'}'),
                            ],
                          ),
                        ),
                      ),
                      // Product List in GridView
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(), // Prevents scrolling inside the GridView
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in the grid
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.75, // Adjust as needed
                        ),
                        itemBuilder: (context, index) {
                          var product = products[index].data() as Map<String, dynamic>;
                          String productId = products[index].id; // Get the product ID

                          return Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      product['image'] != null
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                        child: Image.network(
                                          product['image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      )
                                          : Icon(Icons.fastfood, size: 100),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'Edit') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProductEdit(productId: productId),
                                                ),
                                              );
                                            } else if (value == 'Delete') {
                                              _deleteProduct(context, productId); // Pass the context here
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'Edit',
                                              child: Text('Edit'),
                                            ),
                                            PopupMenuItem(
                                              value: 'Delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                          icon: Icon(Icons.more_vert, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] ?? 'No product name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text('Price: ${product['price']}'),
                                      Text('Quantity: ${product['quantity']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteProduct(BuildContext context, String productId) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // User pressed 'Cancel'
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // User pressed 'Delete'
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance.collection('products').doc(productId).delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product deleted successfully')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting product')));
      }
    }
  }
}
