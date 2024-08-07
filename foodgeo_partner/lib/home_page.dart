import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/profile_page.dart';
import 'package:foodgeo_partner/widget/drawer_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    "https://tse2.mm.bing.net/th?id=OIP.9Izv-aszItToTtEqRMSE0QHaE6&pid=Api&P=0&h=180",
    "https://tse4.mm.bing.net/th?id=OIP.X13wU1ruWMk6SuiSNQze7wHaEP&pid=Api&P=0&h=180",
    "https://www.smallbusinesscoach.org/wp-content/uploads/2022/01/restaurant1.jpg"
  ];

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _searchText = '';

  User? _currentUser;
  String? _userName;
  String? _userImageUrl;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];

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

      print('Fetched Products: $products'); // Debug print

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
        return _searchText.isEmpty || product['name'].toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerW(),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        actions: [
          GestureDetector(
            child: CircleAvatar(
              backgroundImage: _userImageUrl != null
                  ? NetworkImage(_userImageUrl!)
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
              backgroundColor: Colors.white,
              radius: 25, // Adjust radius for the avatar size
            ),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          SizedBox(width: 16), // Add spacing between avatar and text
        ],
        title: Center(
          child: Text(
            _userName ?? "Guest User",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20, // Adjust font size for the AppBar title
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // Get all products from the snapshot
                  List<Map<String, dynamic>> products = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  return GridView.builder(
                    padding: EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                      crossAxisSpacing: 10.0, // Horizontal spacing between grid items
                      mainAxisSpacing: 10.0, // Vertical spacing between grid items
                      childAspectRatio: 3 / 4, // Aspect ratio of the grid items
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> product = products[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                product['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '\$${product['price'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No Data"));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _searchText = result.recognizedWords;
            _filterProducts();
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
