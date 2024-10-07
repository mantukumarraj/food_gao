import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/restaurant_Edit_Screen.dart';
import 'package:foodgeo_partner/views/screen/restaurant_register_screen.dart';
import '../../controller/restaurant_registration_controller.dart';
import '../../product/product_add.dart';
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

  void _showDeleteConfirmationDialog(BuildContext context, String restaurantId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Restaurant'),
          content: Text('Are you sure you want to delete this restaurant? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteRestaurant(restaurantId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRestaurant(String restaurantId) async {
    try {
      await _controller.deleteRestaurant(restaurantId);
      setState(() {
        _restaurantsFuture = _controller.getUserRestaurants();
      });
      print("Restaurant deleted successfully.");
    } catch (e) {
      print("Failed to delete restaurant: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double imageHeight = screenHeight * 0.25; // 25% of screen height

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          "Restaurant List",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _restaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No restaurants found.'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RestaurantRegistrationPage(),)); // Replace with your registration page route
                    },
                    child: Text('Register Your Restaurant'),
                  ),
                ],
              ),
            );
          } else {
            List<Map<String, dynamic>> restaurants = snapshot.data!;
            return PageView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final bool isVerified = restaurant['verification'] == true;
                return GestureDetector(
                  onTap: () => _navigateToProductList(
                      context, restaurant['restaurantId']),
                  child: Container(
                    width: screenWidth,
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.01,
                      vertical: screenHeight * 0.03,
                    ),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListView(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
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
                                  child: Icon(
                                    Icons.restaurant,
                                    size: imageHeight * 0.5,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 1,
                                right: 2,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: PopupMenuButton<String>(
                                    onSelected: (String result) {
                                      if (result == 'Update') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RestaurantEditScreen(
                                              restaurantId: restaurant['id'],
                                              restaurantData: {
                                                'name': restaurant['name'],
                                                'address': restaurant['address'],
                                                'ownerName': restaurant['ownerName'],
                                                'location': restaurant['location'],
                                                'category': restaurant['category'],
                                                'gender': restaurant['gender'],
                                                'phoneNo': restaurant['phoneNo'],
                                                'imageUrl': restaurant['imageUrl'],
                                              },
                                            ),
                                          ),
                                        );
                                      } else if (result == 'Delete') {
                                        _showDeleteConfirmationDialog(context, restaurant['id']);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'Update',
                                        child: Text('Update'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Restaurant Name: ${restaurant['name'] ?? 'No restaurant name'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('Owner Name: ${restaurant['ownerName'] ?? 'No owner'}'),
                          Text('Address: ${restaurant['address'] ?? 'No address'}'),
                          Text('Location: ${restaurant['location'] ?? 'No location'}'),
                          Text('PhoneNo: ${restaurant['phoneNo'] ?? 'No phoneNo'}'),
                          Text('RestaurantCategory: ${restaurant['category'] ?? 'No category'}'),
                          Text('Gender: ${restaurant['gender'] ?? 'No gender'}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            isVerified ? 'Verification Successful' : 'Not Verified',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: isVerified ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          if (isVerified)
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
                                      'Product Add',
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