import 'package:flutter/material.dart';
import 'package:jackblack/widgets/custom_button.dart';

class ContributorsPage extends StatelessWidget {
  const ContributorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Contributors",
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
            // List of contributors
            const Text(
              "Clevland Martin IV",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Thien-an Derek Vuong",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Jennifer Tran",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Gray Barrow",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Lynn Nguyen",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Hunter D'Arensbourg",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Demir Ekal",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Jessica Chan",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Gayoon Nam",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Maci McCord",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 15),
            const Text(
              "Rivers Dupaquier",
              style: TextStyle(
                fontSize: 24,
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
            const SizedBox(height: 40),
            CustomButton(
              text: "Back",
              width: 200,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
} 