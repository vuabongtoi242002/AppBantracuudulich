import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get current user
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  // Sign out the current user
  Future<void> SignOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      // Handle any errors that occur during sign out
      print('Error signing out: $e');
      // You might want to show a message to the user or log the error
    }
  }

  // Delete the current user
  Future<void> deleteUser() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      // Handle any errors that occur during user deletion
      print('Error deleting user: $e');
      // You might want to show a message to the user or log the error
    }
  }
}
