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

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fontSize = 23,
    this.shadowOffset = const Offset(3, 2.5),
    this.width,
    this.height,
  });

  final String text;
  final Function()? onPressed;
  final double fontSize;
  final Offset shadowOffset;
  final double? width;
  final double? height;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Swap border colors for sunken effect
    final topLeftColor =
        _isPressed ? Colors.grey.shade800 : Colors.grey.shade400;
    final bottomRightColor =
        _isPressed ? Colors.grey.shade400 : Colors.grey.shade800;
    // Shift content for sunken effect
    final offset = _isPressed ? Offset(2, 2) : Offset(0, 0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 60),
          width: widget.width,
          height: widget.height,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            border: Border(
              top: BorderSide(color: topLeftColor, width: 3),
              left: BorderSide(color: topLeftColor, width: 3),
              bottom: BorderSide(color: bottomRightColor, width: 3),
              right: BorderSide(color: bottomRightColor, width: 3),
            ),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade900, spreadRadius: 3),
            ],
          ),
          child: Transform.translate(
            offset: offset,
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: widget.shadowOffset,
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
