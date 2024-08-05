import 'package:flutter/material.dart';
import '../../controller/restaurant_registration_controller.dart';
import '../../product/product_add.dart';

class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final RegisterControllers _controller = RegisterControllers();
  late Future<List<Map<String, dynamic>>> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture = _controller.getUserRestaurants();
  }

  void _navigateToAddProduct(BuildContext context, String restaurantId) {
    // Implement navigation logic to Add Product screen here
    // Pass restaurantId to the Add Product screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen(restaurantId: restaurantId)));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double imageHeight = screenHeight * 0.25; // 25% of screen height

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Restaurants'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _restaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No restaurants found.'));
          } else {
            List<Map<String, dynamic>> restaurants = snapshot.data!;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: screenWidth * 0.05),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image section
                      restaurant['imageUrl'] != null
                          ? Image.network(
                        restaurant['imageUrl'],
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.fill,
                      )
                          : Container(
                        width: double.infinity,
                        height: imageHeight,
                        color: Colors.grey[200],
                        child: Icon(Icons.restaurant, size: imageHeight * 0.5, color: Colors.grey[600]),
                      ),
                      // Text details section
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Restaurant Name: ${restaurant['name'] ?? 'No restaurant name'}',
                              style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text('Address: ${restaurant['address'] ?? 'No address'}'),
                            Text('Location: ${restaurant['location'] ?? 'No location'}'),
                            Text('Category: ${restaurant['category'] ?? 'No category'}'),
                            Text('Owner: ${restaurant['ownerName'] ?? 'No owner'}'),
                            Text('Gender: ${restaurant['gender'] ?? 'No gender'}'),
                            Text('Verification: ${restaurant['verification'] ?? 'No verification'}'),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              width: double.infinity,
                              height: 45,
                              margin: EdgeInsets.symmetric(horizontal: 18),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductAdd(),));
                                },
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'Product Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
