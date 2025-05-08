import 'package:flutter/material.dart';
import 'package:jackblack/titlepage.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Function to register user with their desired username
  void signUp() async {
    // Attempt to sign up and set user metadata field 'username' to the
    // user's desired username
    try {
      await Supabase.instance.client.auth.signUp(
        email: email.text,
        password: password.text,
        data: {'username': userName.text},
      );

      // If successfully signed in, go to TitlePage or ModePage to start playing
      // Maybe add like a snackbar or dialog box to indicate that user successfully
      // setup their username? Something like "Welcome <username>!"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TitlePage()),
      );
    }
    // If unable to sign in/sign up for any reason
    catch (e) {
      // Technically should add a snackbar or some dialog box to tell
      // user that they couldn't sign in, but for now just print it
      // to the console for debugging purposes.
      print("Error: $e");
    }
  }

  void signUpAnonymous() async {
    // Attempt to sign up and set user metadata field 'username' to the
    // user's desired username
    try {
      await Supabase.instance.client.auth.signInAnonymously(
        data: {'username': anonName.text},
      );

      // If successfully signed in, go to TitlePage or ModePage to start playing
      // Maybe add like a snackbar or dialog box to indicate that user successfully
      // setup their username? Something like "Welcome <username>!"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TitlePage()),
      );
    }
    // If unable to sign in/sign up for any reason
    catch (e) {
      // Technically should add a snackbar or some dialog box to tell
      // user that they couldn't sign in, but for now just print it
      // to the console for debugging purposes.
      print("Error: $e");
    }
  }

  // UI Stuff for frontend
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign In or Create an Account to Save Your Money!"),
            Text("Email"),
            TextField(controller: email),
            Text("Password"),
            TextField(controller: password),
            Text("Username"),
            TextField(controller: userName),
            SizedBox(height: 15),
            CustomButton(
              text: "Done",
              onPressed: () {
                signUp();
              },
            ),
            Text("Or Continue as Guest"),
            Text("Username"),
            TextField(controller: anonName),
            SizedBox(height: 15),
            CustomButton(
              text: "Done",
              onPressed: () {
                signUpAnonymous();
              },
            ),
          ],
        ),
      ),
    );
  }
}
