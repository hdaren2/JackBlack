import 'package:flutter/material.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:jackblack/widgets/show_hands.dart';
import 'package:jackblack/blackjack.dart';

class SinglePlayer extends StatefulWidget {
  const SinglePlayer({super.key});

  @override
  State<SinglePlayer> createState() => _SinglePlayerState();
}

class _SinglePlayerState extends State<SinglePlayer> {
  final BlackJack _game = BlackJack(players: [Player(name: "p1", funds: 1000)]);

  Player get player => _game.players[0];
  Hand get curHand => player.hands[_game.curHandIndex];

  void startGame(){
    _game.startGame();
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void hit() {
    setState(() {
      _game.hit();
    });
  }

  void stand() {
    setState(() {
    _game.stand();      
    });
  }

  void surrender() {
    setState(() {
    _game.surrender(curHand);
    });
  }

  void doubleDown() {
    setState(() {
      _game.doubleDown();
    });
  }

  void insurance() {
    setState(() {
      _game.insurance();
    });
  }

  void split() {
    setState(() {
      _game.split();
    });
  }

  void addToInitialBet(double amount) {
    setState(() {
      _game.addToInitialBet(player, amount);
    });
  }

  void subFromInitialBet(double amount){
    setState(() {
      _game.subFromInitialBet(player, amount);
    });
  }

  void resetInitialBet() {
    setState(() {
      _game.resetInitialBet(player);
    });
  }

  void confirmInitialBet() {
    setState(() {
      _game.confirmInitialBet(player);
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
    if (_game.showBetPrompt) {
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
                    
                    Text(
                      "\$Funds: ${player.funds}",
                      style: TextStyle(
                        fontSize: 20,
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
                    SizedBox(width: 5),
                    Image.asset(
                      'assets/Screenshot 2025-04-23 at 4.03.13 PM-1.png.png',
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Text("Bet: \$${_game.initialBet}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Minecraft',
                  shadows: [Shadow(offset: Offset(2.9,3.1), blurRadius: 0, color: Color.fromRGBO(63,63,63,1))]
                ),
                
                ),
                SizedBox(width: 5),
                Image.asset(
                      'assets/Screenshot 2025-04-23 at 4.03.13 PM-1.png.png',
                      width: 25,
                      height: 25,
                    ),
              ],
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Dealer",
          style: TextStyle(
            fontSize: 14,
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
        (!_game.isDealerTurn) ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlayingCardWidget(
                card: _game.dealer.hand[0],
              ),
              SizedBox(width: 8.0),
              Image.asset(
                'assets/cards/CARDBACK.png',
                width: 120.0,
                fit: BoxFit.cover,
              ),
            ],
          )
        :
          CardRow(
            maxWidth: (MediaQuery.sizeOf(context).width - 12 * 2),
            cards:  _game.dealer.hand.map((card) {
              return PlayingCardWidget(card: card);
            }).toList(),
            cardSpacing: 8.0,
            cardWidth: 120.0,
          ),
        SizedBox(height: 25),
        //players hands
        Text("Player",  style: TextStyle(
            fontSize: 14,
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

          child: IntrinsicWidth(
            child: MultiHandCardRow(
              maxWidth: (MediaQuery.sizeOf(context).width - 12 * 2),
              Hands: player.hands.map((group) {
                return group.hand.map((card) {
                  return PlayingCardWidget(card: card);
                }).toList();
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 12),
            ...List.generate(player.hands.length * 2 - 1, (index) {
              if (index % 2 == 0) {
                return Expanded(
                  child: Text("Sum: ${player.hands[index ~/ 2].sum}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
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
            SizedBox(width: 12)
          ]
        ),
      ],
    );
  }

  Widget _buildButtonSection() {
    if (_game.showBetPrompt && !_game.showQuitPrompt) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_game.betMessage,
            style: TextStyle(
              fontSize: 18,
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
                _game.showQuitPrompt = true;
              });
            },
          ),
        ],
      );
    }
    if (_game.showQuitPrompt) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Leave game?",
            style: TextStyle(
              fontSize: 28,
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
                    _game.showQuitPrompt = false;
                  });
                },
              ),
              SizedBox(width: 50),
              CustomButton(
                text: "Yes",
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ],
      );
    }
    if (_game.roundOver) {
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
                        fontSize: 24,
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Quit",
                onPressed: () {
                  setState(() {
                    _game.showQuitPrompt = true;
                  });
                },
              ),
              SizedBox(width: 50),
              CustomButton(
                text: "Play Again",
                onPressed: () {
                  setState(() {
                    _game.showBetPrompt = true;
                    _game.roundOver = false;
                    _game.startGame();
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
                hit();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Stand",
              onPressed: () {
                stand();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Double Down",
              onPressed: () {
                doubleDown();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Insurance",
              onPressed: () {
                insurance();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Split",
              onPressed: () {
                split();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Surrender",
              onPressed: () {
                surrender();
              },
              fontSize: 16,
              shadowOffset: Offset(2, 2),
            ),
            CustomButton(
              text: "Quit Game",
              onPressed: () {
                setState(() {
                  _game.showQuitPrompt = true;
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
    if (_game.showBetPrompt) {
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
                  Text(
                    "\$Funds: ${player.funds}",
                    style: TextStyle(
                      fontSize: 20,
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
              Text(curHand.insurance == 0 ? "" : "Insurance: \$${curHand.insurance}",
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
              SizedBox(width: 5),
              Image.asset(
                'assets/Screenshot 2025-04-23 at 4.03.13 PM-1.png.png',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        Row(
          children: [
            Text(_game.roundOver ? "" : "Bet: ${curHand.bet}",
              style: TextStyle(
                fontSize: 20,
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
            SizedBox(width: 5),
            Image.asset(
              'assets/Screenshot 2025-04-23 at 4.03.13 PM-1.png.png',
              width: 25,
              height: 25,
            ),
          ],
        ),
      ],
    );
  }
}