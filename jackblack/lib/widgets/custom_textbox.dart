import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    super.key,
    required this.controller,
    this.hintText = '',
    this.fontSize = 18,
    this.width,
    this.height,
    this.hidden = false,
  });

  final TextEditingController controller;
  final String hintText;
  final double fontSize;
  final double? width;
  final double? height;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        border: Border(
          top: BorderSide(color: Colors.grey.shade400, width: 3),
          left: BorderSide(color: Colors.grey.shade400, width: 3),
          bottom: BorderSide(color: Colors.grey.shade900, width: 3),
          right: BorderSide(color: Colors.grey.shade900, width: 3),
        ),
        boxShadow: [BoxShadow(color: Colors.grey.shade900, spreadRadius: 3)],
      ),
      child: TextField(
        obscureText: hidden,
        controller: controller,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontFamily: 'Minecraft',
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 0,
              color: Color.fromRGBO(63, 63, 63, 1),
            ),
          ],
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.grey.shade400,
            fontFamily: 'Minecraft',
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
        ),
        cursorColor: Colors.white,
      ),
    );
  }
}
