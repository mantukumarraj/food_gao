import 'package:flutter/material.dart';

import '../Screen/login_screen.dart';

class AppbarScreen extends StatefulWidget {
  final Color? background;
  final String? titleText;
  final dynamic ? body;

  AppbarScreen({super.key,required this.background ,required this.titleText,required this.body});

  @override
  State<AppbarScreen> createState() => _AppbarScreenState();
}

class _AppbarScreenState extends State<AppbarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
            backgroundColor: widget.background,
            title: Text(widget.titleText ?? '')
            ,
            leading: IconButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }, icon: Icon(Icons.arrow_back))
        ),
        body:widget.body
    );
  }
}
