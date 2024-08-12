import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/RestaurantListScreen.dart';
import 'package:foodgeo_partner/views/widget/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Profile.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _currentUser;
  String? _userName;
  String? _userImageUrl;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String _searchText = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
    _fetchProducts();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['name'];
            _userImageUrl = userDoc['imageUrl'];
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _fetchProducts() async {
    try {
      QuerySnapshot productDocs = await FirebaseFirestore.instance
          .collection('products')
          .get();

      List<Map<String, dynamic>> products = productDocs.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        _products = products;
        _filterProducts();
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        return _searchText.isEmpty ||
            product['name'].toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePageContent(),
      RestaurantListScreen(),

    ];

    return Scaffold(
      drawer: DrawerW(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            child: CircleAvatar(
              backgroundImage: _userImageUrl != null
                  ? NetworkImage(_userImageUrl!)
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
              backgroundColor: Colors.white,
              radius: 20,
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          SizedBox(width: 16),
        ],
        title: Center(
          child: Text(
            _userName ?? "Guest User",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),

          ),

        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Your Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePageContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                      _filterProducts();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 15, // Spacing between columns
              mainAxisSpacing: 15, // Spacing between rows
              childAspectRatio: 0.75, // Aspect ratio for slightly taller cards
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              final mediaQuery = MediaQuery.of(context);
              final heightFactor = mediaQuery.size.height / 800;

              return GestureDetector(
                onTap: () {
                  // Handle onTap interaction here (e.g., navigate to product details)
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 20 * heightFactor,
                      child: Container(
                        height: 250 * heightFactor,
                        width: 180 * mediaQuery.size.width / 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFa8edea),
                              Color(0xFFfed6e3)
                            ], // Soft pastel gradient
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2 * heightFactor,
                            horizontal:
                            15 * mediaQuery.size.width / 400,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 80 *
                                      heightFactor), // Reduced space for the floating image
                              Text(
                                product['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  18 * heightFactor,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                  height: 5 *
                                      heightFactor),
                              Text(
                                product['description'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14 *
                                      heightFactor,
                                ),
                                maxLines: 2,
                                overflow:
                                TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                  height: 10 *
                                      heightFactor),
                              Text(
                                '\$${product['price']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 18 *
                                      heightFactor,
                                  color: Color(0xFFFF8C00), // Bright orange for price
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Floating Image at the top
                    Positioned(
                      top: 10 * heightFactor, // Adjust position to avoid overlapping
                      child: Container(
                        width: 120 * heightFactor, // Reduced size for better alignment
                        height: 120 * heightFactor,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            product['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
