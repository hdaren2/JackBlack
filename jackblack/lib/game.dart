import 'package:flutter/material.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/shoe.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';
import 'package:jackblack/widgets/custom_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Shoe shoe = Shoe(6);
  final Player player = Player(name: "Player", funds: 1000.0);
  final DealerHand dealer = DealerHand();
  bool isPlayerTurn = true;
  int curHandIndex = 0;
  bool showBetPrompt = true;
  bool showQuitPrompt = false;
  String _gameResult = "";
  double bet = 0;
  double funds = 1000;
  String betMessage = "";
  bool roundOver = false;

  Hand get curHand => player.hands[curHandIndex];

  void nextHand() {
    setState(() {
      if (curHandIndex + 1 < player.hands.length) {
        curHandIndex++;
      } else {
        isPlayerTurn = false;
        _dealerPlay();
      }
    });
  }

  void _dealerPlay() {
    setState(() {
      while (dealer.sum < 17) {
        dealer.add(shoe.deal());
      }
      _checkResult();
    });
  }

  void _startGame() {
    setState(() {
      // Reset everything
      player.hands.clear();
      curHandIndex = 0;
      isPlayerTurn = true;
      roundOver = false;
      dealer.clear();
      _gameResult = "";
      // Add a new empty hand to start with
      player.addEmptyHand();
      curHand.bet = bet;
      bet = 0;
      // Deal two cards to player
      curHand.add(shoe.deal());
      curHand.add(shoe.deal());
      // Deal two cards to dealer
      dealer.add(shoe.deal());
      dealer.add(shoe.deal());
      // Check for immediate blackjack
      if (curHand.sum == 21) {
        _gameResult = "Blackjack! You win.";
        player.funds += (curHand.bet * 3 / 2);
        isPlayerTurn = false;
        roundOver = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _checkResult() {
    setState(() {
      int playerScore = curHand.sum;
      int dealerScore = dealer.sum;

      if (playerScore > 21 && dealerScore > 21) {
        _gameResult = "You both bust! $playerScore vs $dealerScore";
      } else if (playerScore > 21) {
        _gameResult = "You busted with $playerScore! Dealer wins.";
      } else if (dealerScore > 21) {
        _gameResult = "Dealer busted with $dealerScore! You win!";
        player.funds += 2 * curHand.bet;
      } else if (playerScore > dealerScore) {
        _gameResult = "You win! $playerScore vs $dealerScore";
        player.funds += 2 * curHand.bet;
      } else if (playerScore < dealerScore) {
        _gameResult = "Dealer wins! $dealerScore vs $playerScore";
      } else {
        _gameResult = "It's a tie! $playerScore vs $playerScore";
        player.funds += curHand.bet;
      }
      roundOver = true;
    });
  }

  void _hit() {
    setState(() {
      player.hit(curHand, shoe);
      int playerScore = curHand.sum;
      if (playerScore > 21) {
        _gameResult = "You busted with $playerScore! Dealer wins.";
        nextHand();
      }
    });
  }

  void _stand() {
    nextHand();
  }

  void _surrender() {
    // Discard bet and hand
    nextHand();
  }

  // Fix functionality
  void _doubleDown() {
    setState(() {
      if (curHand.sum <= 11) player.doubleDown(curHand);
    });
    // Check sum
    nextHand();
  }

  void _insurance() {
    setState(() {
      int dealerLength = dealer.hand.length;
      if (dealerLength == 1) {
        String dealerSuit = dealer.hand[0].suit;
        if (dealerSuit == "A") {
          player.insurance(curHand);
        }
      }
    });
  }

  void _split() {
    setState(() {
      int handLength = curHand.hand.length;
      if (handLength == 2) {
        int c1 = curHand.hand[0].value;
        int c2 = curHand.hand[1].value;
        if (c1 == c2) {
          player.split(curHand);
          //_gameMessage = "You split the hand, play your first hand first";
        }
      }
    });
  }

  void _addToBet(double amount) {
    setState(() {
      bet += amount;
      funds -= bet;
    });
  }

  void _resetBet() {
    setState(() {
      bet = 0;
      betMessage = "";
    });
  }

  void _confirmBet() {
    setState(() {
      if (bet == 0) {
        betMessage = "Bet must be more than 0.";
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            betMessage = "";
          });
        });
      }
      else if (bet > player.funds) {
        betMessage = "Insufficient funds.";
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            betMessage = "";
          });
        });
      }
      else {
        player.bet(curHand, bet);
        betMessage = "";
        showBetPrompt = false;
        _startGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: _buildStatsSection(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.68,
                child: _buildGameSection(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: _buildButtonSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameSection() {
    if (showBetPrompt) {
      // Temporary bet display
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Make a bet to start:"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                for (var value in [1, 5, 10])
                CustomButton(
                  text: "\$$value",
                  onPressed: () {
                    _addToBet(value.toDouble());
                  }
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                for (var value in [25, 50, 100])
                CustomButton(
                  text: "\$$value",
                  onPressed: () {
                    _addToBet(value.toDouble());
                  }
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Funds: \$${player.funds}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Minecraft',
                  shadows: [Shadow(offset: Offset(2.9,3.1), blurRadius: 0,color: Color.fromRGBO(63, 63, 63, 1))]
                ),
                ),
                SizedBox(width: 20),
                Text("Bet: \$$bet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Minecraft',
                  shadows: [Shadow(offset: Offset(2.9,3.1), blurRadius: 0, color: Color.fromRGBO(63,63,63,1))]
                ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Dealer", style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Minecraft',
            shadows: [Shadow(offset:Offset(2.4, 2.4), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
          ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(dealer.hand.length, (index) {
              //final cardCount = dealer.hand.length;
              final cardWidth = dealer.hand.length > 3 ? 85.0 : 120.0;
              if (isPlayerTurn && index == 1) {
                return Image.asset('assets/cards/CARDBACK.png', width: cardWidth, fit: BoxFit.cover);
              }
              else {
                return PlayingCardWidget(card: dealer.hand[index], width: cardWidth);
              }
            })
          ),
          SizedBox(height: 25),
          Text("Player",  style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Minecraft',
            shadows: [Shadow(offset:Offset(2.4, 2.4), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
          ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromRGBO(23, 107, 61, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: curHand.hand.map((card) {
                //final cardCount = curHand.hand.length;
                final cardWidth = curHand.hand.length > 3 ? 85.0 : 120.0;
                return PlayingCardWidget(card: card, width: cardWidth);
              }).toList()
            ),
          ),
          SizedBox(height: 10),
          Text("Sum: ${curHand.sum}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Minecraft',
              shadows: [Shadow(offset: Offset(2.4, 2.4), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection() {
    if (showBetPrompt) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(betMessage),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Reset Bet",
                onPressed: () {
                  _resetBet();
                }
              ),
              SizedBox(width: 20),
              CustomButton(
                text: "Confirm Bet",
                onPressed: () {
                  _confirmBet();
                }
              )
            ],
          )
        ],
      );
    }
    if (showQuitPrompt) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Leave game?"),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "No",
                onPressed: () {
                  setState(() {
                    showQuitPrompt = false;
                  });
                }
              ),
              SizedBox(width: 50),
              CustomButton(
                text: "Yes",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "title");
                }
              )
            ],
          ),
        ],
      );
    }
    if (roundOver) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_gameResult),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Quit",
                onPressed: () {
                  setState(() {
                    showQuitPrompt = true;
                  });
                }
              ),
              SizedBox(width: 50),
              CustomButton(
                text: "Play Again",
                onPressed: () {
                  setState(() {
                    showBetPrompt = true;
                    roundOver = false;
                  });
                }
              )
            ],
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [
            CustomButton(
              text: "Hit",
              onPressed: () {
                _hit();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Stand",
              onPressed: () {
                _stand();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Double Down",
              onPressed: () {
                _doubleDown();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Insurance",
              onPressed: () {
                _insurance();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Split",
              onPressed: () {
                _split();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Surrender",
              onPressed: () {
                _surrender();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Quit Game",
              onPressed: () {
                setState(() {
                  showQuitPrompt = true;
                });
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    if (showBetPrompt) {
      return Column();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Funds: ${player.funds}"),
              Text("Bet: ${curHand.bet}")
            ],
          ),
        ),
      ],
    );
  }
}
