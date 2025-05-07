import 'package:flutter/material.dart';
import 'package:jackblack/titlepage.dart';
import 'package:jackblack/users/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/* 

This is the authentication process. Theoretically, the app should be directed
here when the app first starts. Here, we check if the user has already made an 
account and played before (aka has a session) and sends them to the appropriate
page to either start playing (TitlePage or wherever we want to send them) or 
to create an account (RegisterPage).

*/
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen for any AuthStateChange (e.g., user signed in, signed out, etc.)
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // ...and send user to appropriate page accordingly
      builder: (context, snapshot) {
        // Loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
           return const Scaffold(
            // Show a loading symbol so the screen doesn't freeze while waiting to connect
            body: Center(child: CircularProgressIndicator())
          );
        }

        // If snapshot has data, set session to the current session, else set to null
        final session = snapshot.hasData ? snapshot.data!.session : null;


        // NOTE: This could run into an issue with the session expiring and the
        // user is sent to RegisterPage() even though they've played before? I'm not 100% sure.

        // If there is an existing session..
        if (session != null) {
          // ..send user to play
          return TitlePage();
        // otherwise..
        } else {
          // ..send user to setup an account
          return RegisterPage();
        }
      }
    );
  }
}