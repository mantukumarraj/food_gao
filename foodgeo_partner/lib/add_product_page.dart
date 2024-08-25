import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_model.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final productName = _controller.text;
                if (productName.isNotEmpty) {
                  context.read<ProductModel>().addProduct(productName);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 20),
            Consumer<ProductModel>(
              builder: (context, productModel, child) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: productModel.products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(productModel.products[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
