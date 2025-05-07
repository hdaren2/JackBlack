import 'package:flutter/material.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/shoe.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:jackblack/widgets/show_hands.dart';

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
  double initialBet = 0;
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

  void resetGame(){
    setState(() {
      player.hands.clear();
      curHandIndex = 0;
      isPlayerTurn = true;
      roundOver = false;
      dealer.clear();
      _gameResult = "";
    });
  }

  void dealFirstCards(){
    setState(() {
      // Deal two cards to player
      curHand.add(shoe.deal());
      curHand.add(shoe.deal());
      // Deal two cards to dealer
      dealer.add(shoe.deal());
      dealer.add(shoe.deal());
      // Check for immediate blackjack
      if (curHand.sum == 21) {
        curHand.handResult = "Blackjack! You win!";
        player.funds += (initialBet * 1.5);
        isPlayerTurn = false;
        roundOver = true;
      }
    });
  }

  void _startGame(){
    resetGame();
    player.addEmptyHand();
    dealFirstCards();
  }

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void checkHandVsDealer(Hand h){
    int playerScore = h.sum;
    int dealerScore = dealer.sum;
    setState(() {
      if(playerScore <= 21) {
        if (dealerScore > 21) {
          h.handResult = "Dealer busted with $dealerScore! You win!";
          player.funds += (2 * curHand.bet);
        } else if (playerScore > dealerScore) {
          h.handResult = "You win! $playerScore vs $dealerScore";
          player.funds += 2 * curHand.bet;
        } else if (playerScore < dealerScore) {
          h.handResult = "Dealer wins! $dealerScore vs $playerScore";
        } else if (playerScore == dealerScore) {
          h.handResult = "It's a tie! $playerScore vs $playerScore";
          player.funds += curHand.bet;
        }
      }
    });
  }

  void _checkResult() {
    setState(() {
      roundOver = true;
      for (Hand h in player.hands){
        checkHandVsDealer(h); 
      }
    });
  }

  void _hit() {
    setState(() {
      player.hit(curHand, shoe);
      int playerScore = curHand.sum;
      if (playerScore > 21) {
        curHand.handResult = "You busted with $playerScore! Dealer wins.";
        nextHand();
      } else if (playerScore == 21) {
        nextHand();
      }
    });
  }

  void _stand() {
    nextHand();
  }

  void _surrender() {
    player.surrender(curHand);
    nextHand();
  }

  // Fix functionality
  void _doubleDown() {
      if (curHand.sum <= 11 && curHand.length == 2) {
        setState(() {
          player.doubleDown(curHand);
          curHand.add(shoe.deal());
        });
        nextHand();
      }
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
      //max splitting twice into three hands, 
      //gets too unwiedly after that and most casinos do 4 hands so its close enough
      if (handLength == 2 && curHand.hand[0].value == curHand.hand[1].value && player.hands.length <= 3) {
        player.split(curHand);
      }
    });
  }

  void addToInitialBet(double amount) {
    setState(() {
      initialBet += amount;
      player.funds -= amount;
    });
  }

  void subFromInitialBet(double amount){
    setState(() {
      initialBet -= amount;
      player.funds += amount;
    });
  }

  void resetInitialBet() {
    setState(() {
      player.funds += initialBet;
      initialBet = 0;
      betMessage = "";
    });
  }

  void confirmInitialBet() {
    setState(() {
      if (initialBet == 0) {
        betMessage = "Bet must be more than 0.";
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            betMessage = "";
          });
        });
      }
      else if (initialBet > player.funds) {
        betMessage = "Insufficient funds.";
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            betMessage = "";
          });
        });
      }
      else {
        _startGame();
        curHand.bet = initialBet;
        initialBet = 0;
        betMessage = "";
        showBetPrompt = false;
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
            Text(
              "Make a bet to start:",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: Offset(3.9, 3.9),
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                for (var value in [1, 5, 10])
                CustomButton(
                  text: "\$$value",
                  onPressed: () {
                    addToInitialBet(value.toDouble());
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
                    addToInitialBet(value.toDouble());
                  }
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/Screenshot 2025-04-23 at 4.03.13 PM-1.png.png',
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "\$${player.funds}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Minecraft',
                        shadows: [
                          Shadow(
                            offset: Offset(2.4, 2.4),
                            blurRadius: 0,
                            color: Color.fromRGBO(63, 63, 63, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Text("Bet: \$$initialBet",
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
          Text(
            "Dealer",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Minecraft',
              shadows: [
                Shadow(
                  offset: Offset(2.4, 2.4),
                  blurRadius: 0,
                  color: Color.fromRGBO(63, 63, 63, 1),
                ),
              ],
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
                return Image.asset(
                  'assets/cards/CARDBACK.png',
                  width: cardWidth,
                  fit: BoxFit.cover,
                );
              } else {
                return PlayingCardWidget(
                  card: dealer.hand[index],
                  width: cardWidth,
                );
              }
            }),
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
            child: MultiHandCardRow(
              maxWidth: (MediaQuery.sizeOf(context).width - 12 * 2),
              Hands: player.hands.map((group) {
                return group.hand.map((card) {
                  return PlayingCardWidget(card: card);
                }).toList();
              }).toList(),
            ),
            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: curHand.hand.map((card) {
            //     //final cardCount = curHand.hand.length;
            //     final cardWidth = curHand.hand.length > 3 ? 85.0 : 120.0;
            //     return PlayingCardWidget(card: card, width: cardWidth);
            //   }).toList()
            // ),
          ),
          SizedBox(height: 10),
          // Text("Sum: ${curHand.sum}",
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //     fontFamily: 'Minecraft',
          //     shadows: [Shadow(offset: Offset(2.4, 2.4), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(player.hands.length * 2 - 1, (index) {
              if (index % 2 == 0) {
                return Flexible(
                  child: Text("Sum: ${player.hands[index ~/ 2].sum}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Minecraft',
                            shadows: [Shadow(offset: Offset(3, 2.7), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
                          ),
                        ),
                );
              } else {
                return SizedBox(width: 24);
              }
            })
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection() {
    if (showBetPrompt && !showQuitPrompt) {
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
                  resetInitialBet();
                }
              ),
              SizedBox(width: 20),
              CustomButton(
                text: "Confirm Bet",
                onPressed: () {
                  confirmInitialBet();
                }
              )
            ],
          ),
          SizedBox(height: 20),
          CustomButton(
            text: "Quit",
            onPressed: () {
              setState(() {
                showQuitPrompt = true;
              });
            },
          ),
        ],
      );
    }
    if (showQuitPrompt) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Leave game?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Minecraft',
              shadows: [
                Shadow(
                  offset: Offset(2.4, 2.4),
                  blurRadius: 0,
                  color: Color.fromRGBO(63, 63, 63, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "No",
                width: 78,
                onPressed: () {
                  setState(() {
                    showQuitPrompt = false;
                  });
                },
              ),
              SizedBox(width: 50),
              CustomButton(
                text: "Yes",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "title");
                },
              ),
            ],
          ),
        ],
      );
    }
    if (roundOver) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12),
              ... List.generate(player.hands.length * 2 - 1, (index) {
                if (index % 2 == 0) {
                  return Flexible(
                    child: Text(player.hands[index ~/ 2].handResult,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Minecraft',
                              shadows: [Shadow(offset: Offset(3, 2.7), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
                            ),
                          ),
                  );
                } else {
                  return SizedBox(width: 24);
                }
              }),
              SizedBox(width: 12),
            ]
          ),
          // Text(_gameResult,
          //   style: TextStyle(
          //     fontSize: 19,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //     fontFamily: 'Minecraft',
          //     shadows: [Shadow(offset: Offset(3, 2.7), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))]
          //   ),
          // ),
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
                },
              ),
              SizedBox(width: 50),
              CustomButton(
                text: "Play Again",
                onPressed: () {
                  setState(() {
                    showBetPrompt = true;
                    roundOver = false;
                  });
                },
              ),
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
              Row(
                children: [
                  Image.asset(
                    'assets/Screenshot 2025-04-23 at 4.03.13 PM-1.png.png',
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "\$${player.funds}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Minecraft',
                      shadows: [
                        Shadow(
                          offset: Offset(2.4, 2.4),
                          blurRadius: 0,
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(roundOver ? "" : "Bet: \$${curHand.bet}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Minecraft',
                  shadows: [
                    Shadow(
                      offset: Offset(2.4, 2.4),
                      blurRadius: 0,
                      color: Color.fromRGBO(63, 63, 63, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

