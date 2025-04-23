import 'package:jackblack/card.dart';
import 'package:jackblack/shoe.dart';
import 'package:jackblack/hand.dart';

class Player {
  final String name;
  double funds;
  List<Hand> hands = []; //multiple hands in case splitting
  //will add stats and way to keep track of them

  Player({
    required this.name,
    required this.funds
  });

  double bet(Hand h, double bet){
    funds -= bet;
    h.bet += bet;
    return bet;
  }

  void addEmptyHand(){
    Hand h = Hand();
    hands.add(h);
  }

  void stand(Hand h){
    h.isStanding = true;
  }

  void hit(Hand h, Shoe d){
    h.add(d.deal());
  }

  void surrender(Hand h){
    h.isSurrendered = true;
    // Get back half the bet?
    h.bet = 0;
  }

  void split(Hand h){
    // First two cards must have same value
    PlayingCard two = h.hand.removeLast();
    Hand second = Hand();
    bet(second, h.bet);
    second.add(two);
    hands.add(second);
  }

  void doubleDown(Hand h){
    // Must be on first two cards
    bet(h, h.bet);
  }

  void insurance(Hand h){
    // If dealer's upcard is ace
    double insurance = h.bet/2;
    funds -= insurance;
    h.insurance += insurance;
  }
}