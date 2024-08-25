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
              colors: [Colors.orange, Colors.orange],
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
          } else if (!restaurantSnapshot.hasData ||
              !restaurantSnapshot.data!.exists) {
            return Center(child: Text('Restaurant not found.'));
          } else {
            var restaurantData =
                restaurantSnapshot.data!.data() as Map<String, dynamic>;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('restaurantId', isEqualTo: restaurantId)
                  .snapshots(),
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (productSnapshot.hasError) {
                  return Center(child: Text('Error: ${productSnapshot.error}'));
                } else if (!productSnapshot.hasData ||
                    productSnapshot.data!.docs.isEmpty) {
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
                              Text(
                                  'Address: ${restaurantData['address'] ?? 'No address'}'),
                              Text(
                                  'Location: ${restaurantData['location'] ?? 'No location'}'),
                              Text(
                                  'Category: ${restaurantData['category'] ?? 'No category'}'),
                            ],
                          ),
                        ),
                      ),
                      // Product List in GridView
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in the grid
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.55, // Adjust as needed
                        ),
                        itemBuilder: (context, index) {
                          var product =
                              products[index].data() as Map<String, dynamic>;
                          String productId =
                              products[index].id; // Get the product ID

                          return GestureDetector(
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        product['image'] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            5.0)),
                                                child: Image.network(
                                                  product['image'],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              )
                                            : Icon(Icons.fastfood, size: 100),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${product['name'] ?? 'No product name'}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Des: ${product['description'] ?? 'No product description'}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text('Price: ${product['price']}'),
                                        Text('items: ${product['items']}'),
                                        Text('category: ${product['category']}'),
                                        SizedBox(height: 8),
                                        // Add some space before the buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductEdit(productId: productId, onProductUpdated: () {  }, ),));
                                              },
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            // Space between buttons
                                            TextButton(
                                              onPressed: () {
                                                // Handle delete action
                                                _deleteProduct(
                                                    context, productId);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
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
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product deleted successfully')));
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error deleting product')));
      }
    }
  }
}
