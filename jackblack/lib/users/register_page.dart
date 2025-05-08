import 'package:flutter/material.dart';
import 'package:jackblack/titlepage.dart';
import 'package:jackblack/users/auth_service.dart';
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

  //Get Auth Service
  final authService = AuthService();

  // Text controller to get what the user entered in the text field
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  final anonName = TextEditingController();

  // State to track which form to show
  // null = show choice, 'signIn' = show sign in form, 'guest' = show guest form
  String? _selectedOption;

  // Track if there was a caught error in signUp
  bool _signUpError = false;

  // Track if user is in sign up mode
  bool _showSignUpScreen = false;

  // Track if 'Here!' button is pressed
  bool _herePressed = false;

  //Login With Email Password
  void logIn() async {
    final emailTxt = email.text;
    final passwordTxt = password.text;

    // Validate fields
    final snackBarTextStyle = TextStyle(
      fontFamily: 'Minecraft',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 16,
    );
    if (emailTxt.isEmpty || passwordTxt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Fill in All Fields.', style: snackBarTextStyle),
          backgroundColor: Colors.grey.shade900,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Attempt Login
    try {
      await authService.signInWithEmailPassword(emailTxt, passwordTxt);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const TitlePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    }
    // Catch Error
    catch (e) {
      String msg = "";
      if (e.toString().contains("400")) {
        msg = "Invalid Login Credentials";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$msg", style: snackBarTextStyle),
            backgroundColor: Colors.grey.shade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Function to register user with their desired username
  void signUp() async {
    final emailTxt = email.text;
    final passwordTxt = password.text;
    final userNameTxt = userName.text;

    // Validate fields
    final snackBarTextStyle = TextStyle(
      fontFamily: 'Minecraft',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 16,
    );
    if (emailTxt.isEmpty || passwordTxt.isEmpty || userNameTxt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.', style: snackBarTextStyle),
          backgroundColor: Colors.grey.shade900,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    //Attempt Login
    try {
      await authService.signUpWithEmailPassword(
        emailTxt,
        passwordTxt,
        userNameTxt,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TitlePage()),
      );
    } catch (e) {
      String msg = "";
      if (e.toString().contains("register")) {
        msg = "User Already Registered";
      }

      if (e.toString().contains("6 characters")) {
        msg = "Password Must Contain More Than 6 Characters";
      }

      if (e.toString().contains("format")) {
        msg = "Invalid Email Format (example@web.com)";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$msg", style: snackBarTextStyle),
            backgroundColor: Colors.grey.shade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void signUpAnonymous() async {
    final anonNameTxt = anonName.text;

    // Validate field
    final snackBarTextStyle = TextStyle(
      fontFamily: 'Minecraft',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 16,
    );
    if (anonNameTxt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter a Username', style: snackBarTextStyle),
          backgroundColor: Colors.grey.shade900,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      await authService.signUpAnonymous(anonNameTxt);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TitlePage()),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  // Function to register user with their desired username
  void signIn() async {
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
      Supabase.instance.client.auth.signInWithPassword(
        email: email.text,
        password: password.text,
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
                      "Use an account to save your progress.",
                      style: TextStyle(
                        fontSize: 16,
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
                      text: "Log In/Create Account",
                      fontSize: 18,
                      onPressed: () {
                        setState(() {
                          _selectedOption = 'signIn';
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      text: "Play as Guest",
                      fontSize: 18,
                      width: 283,
                      onPressed: () {
                        setState(() {
                          _selectedOption = 'guest';
                        });
                      },
                    ),
                  ],
                )
                : _selectedOption == 'signIn'
                ? (_showSignUpScreen
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create an Account",
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
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        CustomTextBox(
                          controller: email,
                          hintText: "Email",
                          fontSize: 18,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        SizedBox(height: 15),
                        CustomTextBox(
                          controller: userName,
                          hintText: "Username",
                          fontSize: 18,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        SizedBox(height: 15),
                        CustomTextBox(
                          controller: password,
                          hintText: "Password",
                          fontSize: 18,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        SizedBox(height: 30),
                        CustomButton(
                          text: "Create Account",
                          fontSize: 18,
                          onPressed: () {
                            signUp();
                          },
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: "Back",
                          fontSize: 18,
                          width: 200,
                          onPressed: () {
                            setState(() {
                              _showSignUpScreen = false;
                            });
                          },
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log In",
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
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        CustomTextBox(
                          controller: email,
                          hintText: "Email",
                          fontSize: 18,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        SizedBox(height: 15),
                        CustomTextBox(
                          controller: password,
                          hintText: "Password",
                          fontSize: 18,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        SizedBox(height: 15),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Minecraft',
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 0,
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                ),
                              ],
                            ),
                            children: [
                              TextSpan(text: 'New user? '),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      _herePressed = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _herePressed = false;
                                      _showSignUpScreen = true;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _herePressed = false;
                                    });
                                  },
                                  child: Text(
                                    'Create account',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _herePressed
                                              ? Colors.orange
                                              : Colors.yellow,
                                      fontFamily: 'Minecraft',
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 0,
                                          color: Color.fromRGBO(63, 63, 63, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        CustomButton(
                          text: "Log In",
                          fontSize: 18,
                          width: 110,
                          onPressed: () {
                            logIn();
                          },
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: "Back",
                          fontSize: 18,
                          width: 110,
                          onPressed: () {
                            setState(() {
                              _selectedOption = null;
                            });
                          },
                        ),
                      ],
                    ))
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Play as Guest",
                      style: TextStyle(
                        fontSize: 40,
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
                    SizedBox(height: 30),
                    CustomButton(
                      text: "Let's Gamble!",
                      fontSize: 18,
                      onPressed: () {
                        signUpAnonymous();
                      },
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      text: "Back",
                      fontSize: 18,
                      width: 165,
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
