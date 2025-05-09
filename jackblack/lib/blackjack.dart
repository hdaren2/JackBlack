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

  void addPlayerObject(Player p){
      players.add(p);
  }

  void removePlayerObject(Player p){
      players.remove(p);
  }

  //defaults to 1000 money
  void addPlayer(String id, {funds = 1000}){
      players.add(Player(name: id, funds: funds));
  }

  void removePlayer(String id) {
      int playerIndex = players.indexWhere((player) => player.name == id);
      
      if (playerIndex != -1) {
        if (playerIndex <= curPlayerIndex) {
          curPlayerIndex = curPlayerIndex > 0 
              ? curPlayerIndex - 1 
              : 0;
        }
        
        players.removeAt(playerIndex);
        
        if (players.isEmpty) {
          curPlayerIndex = 0;
        } else {
          curPlayerIndex = curPlayerIndex.clamp(0, players.length - 1);
        }
      }
  }

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
      p.amountWon += (p.hands[0].bet * 2.5);
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
  }

  void startGame(){
    resetGame();
    dealFirstCards();
  }
  

  void checkHandVsDealer(Player p, Hand h){
    //check if hand has insurance and pay if necessary
    if(h.insurance != 0){
      //see if dealer has blackjack
      if(dealer.hand[0].value == 11 && dealer.hand[1].value == 10) {
        //pay insurance
        p.funds += 2*h.insurance;
        p.amountWon = 2*h.insurance;
      }
    }
    //if theres already a hand message, dont need to check
    if(h.handResult != "") return;
    int playerScore = h.sum;
    int dealerScore = dealer.sum;
    if (dealerScore > 21) {
      h.handResult = "Dealer busted with $dealerScore! You win!";
      p.funds += 2 * h.bet;
      p.amountWon += 2 * h.bet;
    } else if (playerScore > dealerScore) {
      h.handResult = "You win! $playerScore vs $dealerScore";
      p.funds += 2 * h.bet;
      p.amountWon += 2 * h.bet;
    } else if (playerScore < dealerScore) {
      h.handResult = "Dealer wins! $dealerScore vs $playerScore";
    } else if (playerScore == dealerScore) {
      h.handResult = "It's a tie! $playerScore vs $playerScore";
      p.funds += h.bet;
      p.amountWon += h.bet;
    }
  }

  void checkResult() {
    roundOver = true;
    for (final player in players) {
      for (final hand in player.hands) {
          checkHandVsDealer(player, hand); 
      }
      player.gameEndMessage = "You ${player.amountWon > 0 ? "won" : "lost"} \$${player.amountWon.abs()}";
      player.amountWon = 0;
    }
    
  }

  void hit() {
    if(curHand.length <= 12)
      curPlayer.hit(curHand, shoe);
    int playerScore = curHand.sum;
    if (playerScore > 21) {
      curHand.handResult = "You busted with $playerScore! Dealer wins.";
      nextHand();
    } else if (playerScore == 21) {
      curHand.isStanding = true;
      if(curHand.length == 2){
        curHand.handResult = "Blackjack from a split! Wow!";
        curPlayer.funds += curHand.bet * 2.5;
        curPlayer.amountWon += curHand.bet * 2.5;
      }
      nextHand();
    }
  }

  void stand() {
    curHand.isStanding = true;
    nextHand();
  }

  void surrender(Hand h) {
    curPlayer.surrender(h);
    curPlayer.amountWon += h.bet/2;
    nextHand();
  }

  void doubleDown() {
      if (curHand.sum <= 11 && curHand.length == 2) {
          curPlayer.doubleDown(curHand);
          curHand.add(shoe.deal());
          curPlayer.amountWon -= curHand.bet;
        nextHand();
      }
  }

  void insurance() {
    //can only get insurance before any action, must be initial 2 card hand
    String dealerRank = dealer.hand[0].rank;
    if (dealerRank == "A" && curPlayer.hands.length == 1 && curHand.insurance == 0) {
      curPlayer.insurance(curHand);
      curPlayer.amountWon -= curHand.bet/2;
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
        curPlayer.amountWon -= curHand.bet;
      }
  }

  void addToInitialBet(Player p, double amount) {
      if (p.funds >= amount) {
          initialBet += amount;
          p.funds -= amount;
          p.amountWon -= amount;
          betMessage = "";  // Clear any previous error message
      } else {
          betMessage = "Insufficient funds.";
          Future.delayed(const Duration(seconds: 2), () {
              betMessage = "";
          });
      }
  }

  void subFromInitialBet(Player p, double amount){
      if (amount <= initialBet) {  // Make sure we don't subtract more than what's bet
          initialBet -= amount;
          p.funds += amount;
          p.amountWon += amount;
          betMessage = "";  // Clear any previous error message
      }
  }

  void resetInitialBet(Player p) {
      p.funds += initialBet;
      p.amountWon += initialBet;
      initialBet = 0;
      betMessage = "";
  }

  void confirmInitialBet(Player p) {
      if (initialBet == 0) {
          betMessage = "Bet must be more than 0.";
          Future.delayed(const Duration(seconds: 2), () {
              betMessage = "";
          });
          return;
      }
      
      // No need to check funds here since we already check in addToInitialBet
      curHand.bet = initialBet;
      //check if anyone got blackjack
      for (final player in players) {
          checkInitialBlackjack(player);
      }
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