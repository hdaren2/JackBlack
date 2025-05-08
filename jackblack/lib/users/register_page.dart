import 'package:flutter/material.dart';
import 'package:jackblack/titlepage.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:jackblack/widgets/custom_textbox.dart";

/* 

This is the page that should show for first-time users (basically if there's no previous
user data).

When the user hits the "Done" button to submit their desired username, they're actually 
signing in anonymously. This is a Supabase feature which creates something like a local
account that doesn't require an email or password to sign in. 
(Technically, the user can make their anonymous account a permanent account if they
wish, but this isn't implemented as of right now.)

*/

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Get reference to database
  final supabase = Supabase.instance.client;

  // Text controller to get what the user entered in the text field
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  final anonName = TextEditingController();

  // State to track which form to show
  // null = show choice, 'signIn' = show sign in form, 'guest' = show guest form
  String? _selectedOption;

  // Track if email is taken
  bool _emailTaken = false;

  // Track if there was a caught error in signUp
  bool _signUpError = false;

  // Function to register user with their desired username
  void signUp() async {
    // Validate fields
    final snackBarTextStyle = TextStyle(
      fontFamily: 'Minecraft',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 16,
    );
    if (email.text.isEmpty || password.text.isEmpty || userName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.', style: snackBarTextStyle),
          backgroundColor: Colors.grey.shade900,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      await Supabase.instance.client.auth.signUp(
        email: email.text,
        password: password.text,
        data: {'username': userName.text},
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TitlePage()),
      );
    } catch (e) {
      setState(() {
        _signUpError = true;
      });
      _showSignUpErrorSnackbar();
      print("Error: $e");
    }
  }

  void signUpAnonymous() async {
    // Validate field
    final snackBarTextStyle = TextStyle(
      fontFamily: 'Minecraft',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 16,
    );
    if (anonName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a username.', style: snackBarTextStyle),
          backgroundColor: Colors.grey.shade900,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      await Supabase.instance.client.auth.signInAnonymously(
        data: {'username': anonName.text},
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TitlePage()),
      );
    } catch (e) {
      setState(() {
        _signUpError = true;
      });
      _showSignUpErrorSnackbar();
      print("Error: $e");
    }
  }

  // UI Stuff for frontend
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      body: Center(
        child:
            _selectedOption == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Jack Black Blackjack",
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
                    SizedBox(height: 36),
                    Text(
                      "Save Your Money with an Account!",
                      style: TextStyle(
                        fontSize: 22,
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
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: "Sign In/Create Account",
                      fontSize: 18,
                      onPressed: () {
                        setState(() {
                          _selectedOption = 'signIn';
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    CustomButton(
                      text: "Continue as Guest",
                      fontSize: 18,
                      onPressed: () {
                        setState(() {
                          _selectedOption = 'guest';
                        });
                      },
                    ),
                  ],
                )
                : _selectedOption == 'signIn'
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In or Create an Account to Save Your Money!",
                      style: TextStyle(
                        fontSize: 22,
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
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CustomTextBox(
                      controller: email,
                      hintText: "Email",
                      fontSize: 18,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(height: 10),
                    CustomTextBox(
                      controller: password,
                      hintText: "Password",
                      fontSize: 18,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(height: 10),
                    CustomTextBox(
                      controller: userName,
                      hintText: "Username",
                      fontSize: 18,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      text: "Let's Gamble!",
                      fontSize: 18,
                      onPressed: () {
                        signUp();
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: "Back",
                      fontSize: 16,
                      onPressed: () {
                        setState(() {
                          _selectedOption = null;
                        });
                      },
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue as Guest",
                      style: TextStyle(
                        fontSize: 22,
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
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CustomTextBox(
                      controller: anonName,
                      hintText: "Username",
                      fontSize: 18,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      text: "Let's Gamble!",
                      fontSize: 18,
                      onPressed: () {
                        signUpAnonymous();
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: "Back",
                      fontSize: 16,
                      onPressed: () {
                        setState(() {
                          _selectedOption = null;
                        });
                      },
                    ),
                  ],
                ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant RegisterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _showSignUpErrorSnackbar();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showSignUpErrorSnackbar();
  }

  void _showSignUpErrorSnackbar() {
    if (_signUpError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email Taken or Invalid/Password Must be 6+ Characters',
              style: TextStyle(
                fontFamily: 'Minecraft',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.grey.shade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _signUpError = false;
        });
      });
    }
  }
}
