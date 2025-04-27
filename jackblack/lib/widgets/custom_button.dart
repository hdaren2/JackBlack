import 'package:flutter/material.dart';

/* This is a custom Minecraft-themed button widget. It takes two
parameters: a String for the button label and a Function
to call when the button is pressed.

You can use it like this:

CustomButton(text: "Start Game", onPressed: () {
  Navigator.pushReplacementNamed(context, "game");
}),

Remember to import it to use it!
import 'package:jackblack/widgets/custom_button.dart';

*/

class CustomButton extends StatelessWidget {
  const CustomButton({super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.fontSize = 23,
    this.shadowOffset = const Offset(3, 2.5)
  });

  final String text;
  final Function()? onPressed;
  final double? width;  
  final double fontSize;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade400,
                width: 3
              ),
              left: BorderSide(
                color: Colors.grey.shade400,
                width: 3
              ),
              bottom: BorderSide(
                color: Colors.grey.shade800,
                width: 3
              ),
              right: BorderSide(
                color: Colors.grey.shade800,
                width: 3
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade900,
                spreadRadius: 3,
              )
            ],
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: Colors.white, shadows: [Shadow(offset: shadowOffset, blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))])
          ),
        ),
      )
    );
  }
}