import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dashboard/features/auth/domain/entities/app_user.dart';
import 'package:financial_dashboard/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // attemp sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // fetch user document from firestore
      final userDoc =
          await firebaseFirestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();

      // create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc['name'],
      );

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // attemp sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // save data to firebase
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      // get current logged in user from firebase
      final firebaseUser = firebaseAuth.currentUser;

      // user does not exist or no login
      if (firebaseUser == null) {
        return null;
      }

      // fetch user document from firestore
      final userDoc =
          await firebaseFirestore
              .collection("users")
              .doc(firebaseUser.uid)
              .get();

      // user exists
      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        name: userDoc['name'],
      );
    } catch (e) {
      return null;
    }
  }
}
