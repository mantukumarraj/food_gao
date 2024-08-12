import 'package:flutter/material.dart';
import 'package:foodgeo_partner/product/product_add.dart';
import '../../controller/restaurant_registration_controller.dart';
import '../../product/product_list_screen.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductAdd(restaurantId: restaurantId),
      ),
    );
  }

  void _navigateToProductList(BuildContext context, String restaurantId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(restaurantId: restaurantId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double imageHeight = screenHeight * 0.25; // 25% of screen height

    return Scaffold(
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
            return PageView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Container(
                  width: screenWidth,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.06),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: restaurant['imageUrl'] != null
                              ? Image.network(
                            restaurant['imageUrl'],
                            width: double.infinity,
                            height: imageHeight,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            width: double.infinity,
                            height: imageHeight,
                            color: Colors.grey[200],
                            child: Icon(Icons.restaurant, size: imageHeight * 0.5, color: Colors.grey[600]),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Restaurant Name: ${restaurant['name'] ?? 'No restaurant name'}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Owner: ${restaurant['ownerName'] ?? 'No owner'}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text('Address: ${restaurant['address'] ?? 'No address'}'),
                        Text('Location: ${restaurant['location'] ?? 'No location'}'),
                        Text('Category: ${restaurant['category'] ?? 'No category'}'),
                        Text('Gender: ${restaurant['gender'] ?? 'No gender'}'),
                        Text('Verification: ${restaurant['verification'] ?? 'No verification'}'),
                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 45,
                              child: MaterialButton(
                                onPressed: () => _navigateToAddProduct(context, restaurant['id']),
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'Add Product',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              width: double.infinity,
                              height: 45,
                              child: MaterialButton(
                                onPressed: () => _navigateToProductList(context, restaurant['id']),
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'Show Products',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
