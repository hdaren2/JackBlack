import 'package:flutter/material.dart';
import 'package:jackblack/card.dart';

class AnimatedCardWidget extends StatefulWidget {
  final PlayingCard card;
  final double width;
  final Duration animationDuration;
  final Duration delay;
  final bool isFaceUp;
  final bool skipInitialAnimation;

  const AnimatedCardWidget({
    Key? key,
    required this.card,
    this.width = 120,
    this.animationDuration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.isFaceUp = true,
    this.skipInitialAnimation = false,
  }) : super(key: key);

  @override
  State<AnimatedCardWidget> createState() => _AnimatedCardWidgetState();
}

class _AnimatedCardWidgetState extends State<AnimatedCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    if (widget.skipInitialAnimation) {
      _isVisible = true;
      _controller.value = 1.0;
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() => _isVisible = true);
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: widget.animationDuration,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.isFaceUp
                ? PlayingCardWidget(card: widget.card, width: widget.width)
                : Image.asset(
                    'assets/cards/CARDBACK.png',
                    width: widget.width,
                    fit: BoxFit.cover,
                  ),
          );
        },
      ),
    );
  }
} 