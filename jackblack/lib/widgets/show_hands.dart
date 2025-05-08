import 'package:flutter/material.dart';

class MultiHandCardRow extends StatelessWidget {
  final List<List<Widget>> Hands;
  final double cardWidth; 
  final double cardSpacing;
  final double handSpacing;
  final double maxWidth;

  const MultiHandCardRow({
    Key? key,
    required this.Hands,
    this.cardWidth = 120.0,
    this.cardSpacing = 8.0, 
    this.handSpacing = 24.0, 
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Hands.isEmpty) return Container();
    
    double totalHandsSpacing = (Hands.length - 1) * handSpacing;
    double availableWidthPerHand = (maxWidth - totalHandsSpacing) / Hands.length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(Hands.length * 2 - 1, (index) {
        if (index % 2 == 0) {
          final groupIndex = index ~/ 2;
          return CardRow(
            cards: Hands[groupIndex],
            cardWidth: cardWidth,
            cardSpacing: cardSpacing,
            maxWidth: availableWidthPerHand,
          );
        } else {
          return SizedBox(width: handSpacing);
        }
      }),
    );
  }
}

class CardRow extends StatelessWidget {
  final List<Widget> cards;
  final double cardWidth;
  final double cardSpacing;
  final double maxWidth;

  const CardRow({
    Key? key,
    required this.cards,
    required this.cardWidth,
    required this.cardSpacing,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return Container();
    
    final cardCount = cards.length;
    
    double totalWidthWithSpacing = (cardCount * cardWidth) + ((cardCount - 1) * cardSpacing);
    
    if (totalWidthWithSpacing <= maxWidth) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(cards.length * 2 - 1, (index) {
          if (index % 2 == 0) {
            return cards[index ~/ 2];
          } else {
            return SizedBox(width: cardSpacing);
          }
        }),
      );
    } 
    else {
      double extraWidth = totalWidthWithSpacing - maxWidth;
      double cardOverlapAmount = extraWidth / (cardCount - 1);
      double visibleCardPortion = cardWidth - cardOverlapAmount;
      
      double totalOverlapWidth = cardWidth + (cardCount - 1) * visibleCardPortion;

      double cardHeight = cardWidth * 1.51282;
      
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: totalOverlapWidth,
              height: cardHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: List.generate(
                  cardCount,
                  (index) => Positioned(
                    left: index * visibleCardPortion,
                    child: cards[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}