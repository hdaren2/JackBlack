import 'package:supabase_flutter/supabase_flutter.dart';

/*

This contains auxiliary functions to use to retrieve any data
from the current user.

Add a function to add the user to a table/room here? If that's possible

*/

class AuthService {
  // Get reference to database
  final supabase = Supabase.instance.client;

  // Function to get current user's username
  // First, need to create an instance/object of AuthService like this:
  // final authService = AuthService();
  //
  // Use like this:
  // Text(authService.getUsername().toString())
  //

  //Sign In with email and password
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //Sign Up with email and password
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
    String userName
  ) async {
    return await supabase.auth.signUp(email: email, password: password, data: {'username': userName});
  }

  //Sign Up Anonymously
  Future<AuthResponse> signUpAnonymous(String username) async {
    return await supabase.auth.signInAnonymously(data: {'username': username});
  }

  //Sign Out
  Future<void> logOut() async {
    return await supabase.auth.signOut();
  }

  //Get user email
  String? getEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String? getUsername() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    final metadata = user?.userMetadata;
    return metadata?['username'];
  }

  String? getUUID() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }
}
