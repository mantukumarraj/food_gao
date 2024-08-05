import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgeo_partner/views/screen/phone_verification_screen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  String name = '';
  String email = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users1').doc(user.uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;

        setState(() {
          name = data['userName'];
          email = data['email'];
          imageUrl = data['imageUrl'];
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  List<Widget> _pages = <Widget>[
    HomeScreen(),
    AddProductScreen(),
    OffersScreen(),
    AccountScreen(),  // Added AccountScreen here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for restaurant or a dish...',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 16),
                SizedBox(width: 4),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Search for restaurant or a dish...',
                      style: TextStyle(color: Colors.grey)),
                ),
                Icon(Icons.mic, color: Colors.red),
              ],
            ),
          ],
        ),
        actions: _isSearching
            ? [
          IconButton(
            icon: Icon(Icons.clear, color: Colors.red),
            onPressed: _stopSearch,
          ),
        ]
            : [
          IconButton(
            icon: Icon(Icons.search, color: Colors.red),
            onPressed: _startSearch,
          ),
        ],
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture:  CircleAvatar(
        radius: 60,
        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,    ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the alert dialog
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Perform logout operation
                            FirebaseAuth.instance.signOut();
                            // Close the alert dialog
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneAuth(),));
                          },
                          child: Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.red), label: 'Home'),
          BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.red), label: 'AddProduct'

    ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Add resturant",
          ),
        ],
      ),
    );
  }
}

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Add Product Screen'),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChoiceChip(
                  label: Text('Delivery'), selected: true, onSelected: (_) {}),
              ChoiceChip(
                  label: Text('Self Pickup'),
                  selected: false,
                  onSelected: (_) {}),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 150.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: [
              'https://media.istockphoto.com/id/182148711/photo/pizza-from-the-top-deluxe.jpg?s=612x612&w=0&k=20&c=uI6keT3AMInUhQAq21IBHki2krITOzgMAKU9oeXjQns=',
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP0HMuYpGWBZIGACw--0Mxku5WA9W5c-vG7g&s',
              'https://w7.pngwing.com/pngs/917/998/png-transparent-plate-of-spring-rolls-spring-roll-indian-cuisine-vegetarian-cuisine-chaat-dosa-vegetable-food-recipe-cooking.png',
              'https://static.vecteezy.com/system/resources/thumbnails/018/128/189/small_2x/schezwan-noodles-or-szechuan-vegetable-png.png',
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(i, fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(label: Text('Sort'), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Fast Delivery'), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Great Offers'), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Rating 4.0+'), onSelected: (_) {}),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Eat what makes you happy',
              style: TextStyle(fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 300,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CategoryIcon('Pizza', Icons.local_pizza,
                    imageUrl:
                    'https://media.istockphoto.com/id/182148711/photo/pizza-from-the-top-deluxe.jpg?s=612x612&w=0&k=20&c=uI6keT3AMInUhQAq21IBHki2krITOzgMAKU9oeXjQns='),
                CategoryIcon('Burger', Icons.fastfood,
                    imageUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP0HMuYpGWBZIGACw--0Mxku5WA9W5c-vG7g&s'),
                CategoryIcon('Rolls', Icons.ramen_dining,
                    imageUrl:
                    'https://w7.pngwing.com/pngs/917/998/png-transparent-plate-of-spring-rolls-spring-roll-indian-cuisine-vegetarian-cuisine-chaat-dosa-vegetable-food-recipe-cooking.png'),
                CategoryIcon('Chinese', Icons.rice_bowl,
                    imageUrl:
                    'https://static.vecteezy.com/system/resources/thumbnails/018/128/189/small_2x/schezwan-noodles-or-szechuan-vegetable-png.png'),
                CategoryIcon('Home Cooked', Icons.kitchen,
                    imageUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrZPUb11YWHgnsuIZyEQMS0aaRTsXM6BqrTw&s.png'),
                CategoryIcon('Chicken', Icons.dinner_dining,
                    imageUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjEIUD-_kuNHasATzAsNyRQzLPJnu2hI3X9g&s.png'),
                CategoryIcon('Chaat', Icons.local_dining,
                    imageUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDHrtt9J710-Y21QNWtkCe7HmfF0obaLTuWw&s.png'),
                CategoryIcon('Samosa', Icons.fastfood,
                    imageUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdRGNFbGVhOmYsXZ-GtnSIo7HLIyOup3w-zw&s'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Offers Screen'),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Account Screen'),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? imageUrl; // Optional parameter for network image

  CategoryIcon(this.label, this.icon, {this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageUrl != null
            ? Image.network(imageUrl!, height: 50, width: 50, fit: BoxFit.cover)
            : CircleAvatar(
          backgroundColor: Colors.red[100],
          child: Icon(icon, color: Colors.red),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
