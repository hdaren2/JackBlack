import 'shoe.dart';

class DealerHand {
  final List<Card> hand = [];
  bool isStanding = false;
  bool isBusted = false;

  int sum() {
    int sum = 0;
    int aceCount = 0;

    for (Card c in hand) {
      if(c.rank=='A')
        aceCount++;
      sum += c.value;
    }
    while (sum > 21 && aceCount > 0) {
      sum -= 10;
      aceCount--;
    }
    return sum;
  }

  void add(Card c){
    hand.add(c);
  }

  void clear(){
    hand.clear();

  }

  String toString(){
    String cards = "";
    for(Card c in hand){
      cards += "${c.rank} ${c.suit}";
    }
    return cards;
  }
}

class Hand extends DealerHand {
  bool isSurrendered = false;
  double bet = 0.0;
  double insurance = 0.0;
}