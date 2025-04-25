import 'package:flutter/material.dart';

/* This is a custom Minecraft-themed button widget. It takes two
parameters: a String for the button label and a Function
to call when the button is pressed.

You can use it like this:

CustomButton(text: "Start Game", onTap: () {
  Navigator.pushReplacementNamed(context, "game");
}),

Remember to import it to use it!
import 'package:jackblack/widgets/custom_button.dart';

*/

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, this.onTap});

  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          style: TextStyle(fontSize: 23)
        ),
      ),
    );
  }
}