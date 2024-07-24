import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/widget/Account_Screen.dart';
import 'package:foodgeo_partner/views/widget/Order_Screen.dart';
import 'package:foodgeo_partner/views/widget/Product_Add_Screen.dart';
import 'package:foodgeo_partner/views/widget/Profile_Screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Home Page with 20 items
    ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(Icons.star),
            title: Text('Item ${index + 1}'),
            subtitle: Text('Description for item ${index + 1}'),
          ),
        );
      },
    ),
    ProductAddScreen(),
    OrderScreen(),
    ProfileScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Home Screen'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Search action
              },
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Product Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
