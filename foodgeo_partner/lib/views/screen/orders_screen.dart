import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  // Sample data
  final List<Map<String, dynamic>> orders = [
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },
    {
      'image': 'https://www.foodiesfeed.com/wp-content/uploads/2023/04/strawberry-milk-splash.jpg',
      'name': 'Product 2',
      'description': 'Description of Product 2',
      'price': 200,
      'status': 'Delivered',
    },
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },{
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0_qutklNLLG-gHtE1cjSCk9ES6IisARULGg&s',
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'price': 100,
      'status': 'Shipped',
    },
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 10, // Horizontal spacing between items
              mainAxisSpacing: 10, // Vertical spacing between items
              childAspectRatio: 0.65, // Aspect ratio of each item
            ),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(order['image']),
                        radius: 50, // Adjust size as needed
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        order['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(order['description']),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '₹${order['price']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        'Status: ${order['status']}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            ),
        );
    }
}