import 'package:flutter/material.dart';
import 'package:jackblack/gameplay_instructions.dart';
import 'package:jackblack/modepage.dart';
import 'package:jackblack/users/auth_service.dart';
import 'package:jackblack/users/register_page.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:jackblack/Contributorspage.dart';

class TitlePage extends StatefulWidget {
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  final String? userName = AuthService().getUsername();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              "Welcome, $userName!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: Offset(3, 3),
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Jack",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Minecraft',
                    shadows: [
                      Shadow(
                        offset: Offset(5, 5),
                        blurRadius: 0,
                        color: Color.fromRGBO(63, 63, 63, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: "Start Game",
                  width: 200, // Set a fixed width
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const ModePage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          final fadeAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          );
                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "How to Play",
                  width: 200, // Set the same fixed width
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const GameplayInstructions(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          final fadeAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          );
                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Credits",
                  width: 200,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const ContributorsPage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          final fadeAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          );
                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Log Out",
                  fontSize: 23,
                  width: 200,
                  onPressed: () {
                    AuthService().logOut();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
