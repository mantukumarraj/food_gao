
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: Padding(

        padding: EdgeInsets.all(16.20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Bank',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Account holders Name',
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'IFSC Code',
                    ),
                  ),
                ),
                SizedBox(width: 10), // Add some spacing between the text fields
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Branch Code',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
