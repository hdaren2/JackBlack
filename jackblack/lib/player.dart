
class Card {
  String rank;
  String suit;

  Card({required this.rank, required this.suit});

  int get value {
    if (rank == 'A') return 11;
    if (['K', 'Q', 'J'].contains(rank)) return 10;
    return int.tryParse(rank) ?? 0;
  }
}

class Player {
  final String name;
  double funds;
  List<Card> hand = [];
  //will add stats and way to keep track of them

  bool isStanding = false;
  bool isBusted = false;

  double currentBet = 0.0;

  Player({required this.name, required this.funds});

  int handSum() {
    int sum = 0;
    int aceCount = 0;

    for (Card c in hand) {
        sum += c.value;
    }
    //accounts for aces
    while (sum > 21 && aceCount > 0) {
      sum -= 10;
      aceCount--;
    }
    return sum;
  }

  void handAdd(Card c){
    hand.add(c);
  }
}