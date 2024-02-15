import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // Fetch user data from Firestore
        DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

          String displayName = userData['displayName'];
          String email = userData['email'];
          print('User Data - Display Name: $displayName, Email: $email');
        } else {
          print('User not found in Firestore.');
        }
      } else {
        print('User is null after signing in.');
      }
    } catch (e, stackTrace) {
      print('Error signing in: $e');
      print('Stack trace: $stackTrace');
      throw e;
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email,
      String password,
      String name,
      String surname,
      String phoneNumber,
      ) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid,
        'email': email,
          'displayName': '$name $surname',
          'phoneNumber': phoneNumber,
        },
      );

      return userCredential;
    } catch (e) {
      // Log or handle the error
      print('Error signing up: $e');
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  bool isUserSignedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
