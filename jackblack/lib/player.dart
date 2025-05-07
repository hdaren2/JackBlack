import 'shoe.dart';
import 'hand.dart';

class Player {
  final String name;
  double funds;
  List<Hand> hands = []; //multiple hands in case splitting
  //will add stats and way to keep track of them


  Player({required this.name, required this.funds}) ;

  void stand(Hand h){
    h.isStanding = true;
  }

  void hit(Hand h, Shoe d){
    h.add(d.dealCard());
  }

  void surrender(Hand h){
    h.isSurrendered = true;
    h.bet = 0;
  }

  void split(Hand h){
    //first two cards must have same value
    Card two = h.hand.removeLast();
    Hand second = Hand();
    second.add(two);
    hands.add(second);
  }

  void doubleDown(Hand h){
    //must be on first two cards
    funds-=h.bet;
    h.bet+=h.bet;
  }

  void insurance(Hand h){
    //if dealers upcard is ace
    double insurance = h.bet/2;
    funds-=insurance;
    h.insurance+=insurance;
  }

}