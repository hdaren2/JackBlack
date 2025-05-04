import 'package:jackblack/card.dart';

class DealerHand {
  final List<PlayingCard> hand = [];
  bool isStanding = false;
  bool isBusted = false;

  int get sum {
    int sum = 0;
    int aceCount = 0;

    for (PlayingCard c in hand) {
      // Update PlayingCard class to have value to simplify this loop
      /*if (c.rank == 'A') {
        aceCount++;
      }*/
      //sum += c.value;
      var rank = c.rank;
      if (rank == 'A')
        aceCount++;
      sum += c.value;
    }
    while (sum > 21 && aceCount > 0) {
      sum -= 10;
      aceCount--;
    }
    return sum;
  }

  int get length {
    return hand.length;
  }

  void add(PlayingCard c){
    hand.add(c);
  }

  void clear(){
    hand.clear();

  }

  String toString(){
    String cards = "";
    for(PlayingCard c in hand){
      cards += "${c.rank} ${c.suit}";
    }
    return cards;
  }
}

class Hand extends DealerHand {
  bool isSurrendered = false;
  double bet = 0.0;
  double insurance = 0.0;
  String handResult = "";
}