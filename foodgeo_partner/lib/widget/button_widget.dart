import 'package:flutter/material.dart';

class DesignButton extends StatefulWidget {
  DesignButton(
      {super.key,
        required this.onTap,
        required this.width,
        required this.color,
        required this.ButtonText,
        required this.contect});

  final void Function() onTap;
  final double width;
  final Color color;
  final String ButtonText;
  final BuildContext contect;

  @override
  State<DesignButton> createState() => _DesignButtonState();
}

class _DesignButtonState extends State<DesignButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onTap,
        child: Container(
            width: widget.width,
            color: widget.color,
            height: MediaQuery.of(context).size.height / 14,

            child:
            Center(
                child: Text(widget.ButtonText,
                    style:
                    TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 25,))))
    );
  }
}
