import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

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
    RestaurantScreen(),
    AddProductScreen(),
    OffersScreen(),

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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
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
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant, color: Colors.red), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add, color: Colors.red), label: 'AddProduct'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer, color: Colors.red), label: 'Offers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet, color: Colors.red), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
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

class RestaurantScreen extends StatelessWidget {
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
            height: 300, // Adjust this height based on your design
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CategoryIcon('Pizza', Icons.local_pizza, imageUrl: 'https://media.istockphoto.com/id/182148711/photo/pizza-from-the-top-deluxe.jpg?s=612x612&w=0&k=20&c=uI6keT3AMInUhQAq21IBHki2krITOzgMAKU9oeXjQns='),
                CategoryIcon('Burger', Icons.fastfood, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP0HMuYpGWBZIGACw--0Mxku5WA9W5c-vG7g&s'),
                CategoryIcon('Rolls', Icons.ramen_dining, imageUrl: 'https://w7.pngwing.com/pngs/917/998/png-transparent-plate-of-spring-rolls-spring-roll-indian-cuisine-vegetarian-cuisine-chaat-dosa-vegetable-food-recipe-cooking.png'),
                CategoryIcon('Chinese', Icons.rice_bowl, imageUrl: 'https://static.vecteezy.com/system/resources/thumbnails/018/128/189/small_2x/schezwan-noodles-or-szechuan-vegetable-png.png'),
                CategoryIcon('Home Cooked', Icons.kitchen, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrZPUb11YWHgnsuIZyEQMS0aaRTsXM6BqrTw&s.png'),
                CategoryIcon('Chicken', Icons.dinner_dining, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjEIUD-_kuNHasATzAsNyRQzLPJnu2hI3X9g&s.png'),
                CategoryIcon('Chaat', Icons.local_dining, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDHrtt9J710-Y21QNWtkCe7HmfF0obaLTuWw&s.png'),
                CategoryIcon('Samosa', Icons.fastfood,imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdRGNFbGVhOmYsXZ-GtnSIo7HLIyOup3w-zw&s')
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