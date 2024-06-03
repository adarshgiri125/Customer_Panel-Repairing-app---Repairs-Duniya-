// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContainerButton extends StatelessWidget {
  final Color color;
  final Function() onTap;
  final String text;
  FontWeight? fontWeight;
  final Color textColor;

  ContainerButton({
    super.key,
    required this.color,
    required this.text,
    required this.onTap,
    this.fontWeight,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        // width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
