import 'package:jackblack/shoe.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';
import 'package:jackblack/card.dart';

class BlackJack {
  final Shoe shoe;
  List<Player> players;
  final DealerHand dealer;
  bool isDealerTurn = false;
  int curPlayerIndex = 0;
  int curHandIndex = 0;
  bool showBetPrompt = true;
  bool showQuitPrompt = false;
  double initialBet = 0;
  String betMessage = "";
  bool roundOver = false; //when all players and dealer are done
  String gameMessage = "";

  BlackJack({
    required this.players,
    int decks = 6,
  }) : 
    shoe = Shoe(decks),
    dealer = DealerHand();

  Player get curPlayer => players[curPlayerIndex];
  Hand get curHand => curPlayer.hands[curHandIndex];

  void nextPlayer(){
    //check if last player or automatic blackjack or surrender
    if (curPlayerIndex + 1 < players.length) {
      curPlayerIndex++;
      if (players[curPlayerIndex].isDone == true) {
        nextPlayer();
      } 
    } else {
      isDealerTurn = true;
      dealerPlay();
    }
  }

  void nextHand() {
      if (curHandIndex + 1 < curPlayer.hands.length) {
        curHandIndex++;
      } else {
        nextPlayer();
      }
  }

  void dealerPlay() {
    //check insurance
    //check if dealer has blackjack
    //if so, loop
    while (dealer.sum < 17) {
      dealer.add(shoe.deal());
    }
    checkResult();
  }

  void resetGame(){
      for(final player in players)
        player.hands.clear();
      curPlayerIndex = 0;
      curHandIndex = 0;
      isDealerTurn = false;
      roundOver = false;
      dealer.clear();
  }

  void checkInitialBlackjack(Player p){
    //only check this on the first hand, so can set isDone to true
    //not used to check for blackjack after splitting aces or 10s
    if(p.hands[0].length == 2 && p.hands[0].sum == 21){
      p.hands[0].handResult = "Blackjack! You win!";
      p.funds += (p.hands[0].bet * 2.5);
      p.isDone = true;
      nextPlayer();
    }
  }

  void dealFirstCards(){
      // Deal two cards to players and dealer
      for (final player in players) {
        player.addEmptyHand();
        player.hands[0].add(shoe.deal());
        player.hands[0].add(shoe.deal());
      }
      dealer.add(shoe.deal());
      dealer.add(shoe.deal());
      //check if anyone got blackjack
      for (final player in players) {
        checkInitialBlackjack(player);
      }
  }

  void startGame(){
    resetGame();
    dealFirstCards();
  }

  // @override
  // void initState() {
  //   startGame();
  // }

  void checkHandVsDealer(Player p, Hand h){
    //check if hand has insurance and pay if necessary
    if(h.insurance != 0){
      //see if dealer has blackjack
      if(dealer.hand[0].value == 11 && dealer.hand[1].value == 10) {
        //pay insurance
        p.funds += 2*h.insurance;
      }
    }
    //if theres already a hand message, dont need to check
    if(h.handResult != "") return;
    int playerScore = h.sum;
    int dealerScore = dealer.sum;
    if (dealerScore > 21) {
      h.handResult = "Dealer busted with $dealerScore! You win!";
      p.funds += 2 * h.bet;
    } else if (playerScore > dealerScore) {
      h.handResult = "You win! $playerScore vs $dealerScore";
      p.funds += 2 * h.bet;
    } else if (playerScore < dealerScore) {
      h.handResult = "Dealer wins! $dealerScore vs $playerScore";
    } else if (playerScore == dealerScore) {
      h.handResult = "It's a tie! $playerScore vs $playerScore";
      p.funds += h.bet;
    }
  }

  void checkResult() {
    roundOver = true;
    for (final player in players) {
      for (final hand in player.hands) {
          checkHandVsDealer(player, hand); 
      }
    }
  }

  void hit() {
    curPlayer.hit(curHand, shoe);
    int playerScore = curHand.sum;
    if (playerScore > 21) {
      curHand.handResult = "You busted with $playerScore! Dealer wins.";
      nextHand();
    } else if (playerScore == 21) {
      if(curHand.length == 2){
        curHand.handResult = "Blackjack from a split! Wow!";
        curPlayer.funds += curHand.bet * 2.5;
      }
      nextHand();
    }
  }

  void stand() {
    nextHand();
  }

  void surrender(Hand h) {
    curPlayer.surrender(h);
    nextHand();
  }

  void doubleDown() {
      if (curHand.sum <= 11 && curHand.length == 2) {
          curPlayer.doubleDown(curHand);
          curHand.add(shoe.deal());
        nextHand();
      }
  }

  void insurance() {
    //can only get insurance before any action, must be initial 2 card hand
    String dealerRank = dealer.hand[0].rank;
    if (dealerRank == "A" && curPlayer.hands.length == 1 && curHand.insurance == 0) {
      curPlayer.insurance(curHand);
    }
  }

  //TO DO
  //if a player wishes to quit
  //surrender all their hands, remove from player list
  void quit(Player p) {

  }

  void split() {
      int handLength = curPlayer.hands.length;
      //max splitting twice into three hands, 
      //gets too unwiedly after that and most casinos do 4 hands so its close enough
      if (handLength <= 2 && curHand.hand[0].value == curHand.hand[1].value && curPlayer.hands.length <= 3) {
        curPlayer.split(curHand);
      }
  }

  void addToInitialBet(Player p, double amount) {
      initialBet += amount;
      p.funds -= amount;
  }

  void subFromInitialBet(Player p, double amount){
      initialBet -= amount;
      p.funds += amount;
  }

  void resetInitialBet(Player p) {
      p.funds += initialBet;
      initialBet = 0;
      betMessage = "";
  }

  void confirmInitialBet(Player p) {
      if (initialBet == 0) {
        betMessage = "Bet must be more than 0.";
        Future.delayed(const Duration(seconds: 2), () {
            betMessage = "";
          });
      }
      else if (initialBet > p.funds) {
        betMessage = "Insufficient funds.";
        Future.delayed(const Duration(seconds: 2), () {
            betMessage = "";
        });
      }
      else {
        curHand.bet = initialBet;
        initialBet = 0;
        betMessage = "";
        curPlayerIndex++;
        //if all players bet, then showBetPrompt is false and reset stuff
        if(curPlayerIndex == players.length){
          curPlayerIndex = 0;
          showBetPrompt = false;
        }
      }
  }
}