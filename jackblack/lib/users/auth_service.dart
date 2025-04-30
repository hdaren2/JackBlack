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
  String? getUsername() {
    final user = supabase.auth.currentUser;
    final metadata = user?.userMetadata;
    return metadata?['username'];
  }

  String? getUUID() {
    final user = supabase.auth.currentUser;
    return user?.id;
  }
}