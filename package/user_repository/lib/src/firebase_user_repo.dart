import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      log('User signed in: ${userCredential.user!.uid}', name: 'Firetool');
      print('User signed in: ${userCredential.user!.uid}');
      return userCredential;
    } catch (e) {
      log("Error during sign in: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);
      myUser = myUser.copyWith(userId: user.user!.uid);
      await setUserData(myUser); // Save the user data to Firestore
      return myUser;
    } catch (e) {
      log("Error during sign up: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log("Error setting user data: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log("Error during logout: ${e.toString()}");
      rethrow;
    }
  }

  // New method to get the Firebase ID token
  Future<String?> getIdToken() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } catch (e) {
      log("Error getting ID token: ${e.toString()}");
      return null;
    }
  }

  // Optional: Method to get the current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Optional: Method to check if a user is signed in
  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
