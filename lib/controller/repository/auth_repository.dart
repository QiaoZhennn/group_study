import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user_model.dart';
import '../../features/common/utils.dart';
import '../provider/firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(firestoreProvider), ref.read(authProvider),
      ref.read(googleSignInProvider));
});

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firestore, this._auth, this._googleSignIn);

  CollectionReference get _users => _firestore.collection('user_model');

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      DateTime now = DateTime.now();
      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: userCredential.user!.email ?? "",
          createdAt: now.toUtc(),
          timeZoneOffset: now.timeZoneOffset.inHours,
          lcAccountName: "",
          lcSubmissions: [],
          lcPenalties: [],
          lcBalance: 0.0,
          joinedGroups: [],
          createdGroups: []);
      print('auth_repository signUpWithEmail');
      await _users.doc(userModel.id).set(userModel.toMap());
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(Failure('The account already exists for that email.'));
      }
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel userModel = await getUserDataById(userCredential.user!.uid);
      // userModel = UserModel(
      //     id: userCredential.user!.uid,
      //     name: userCredential.user?.displayName ?? "email",
      //     email: userCredential.user!.email ?? "",
      //     lcAccountName: "",
      //     lcSubmissions: [],
      //     lcPenalties: [],
      //     lcBalance: 0.0,
      //     joinedGroups: [],
      //     createdGroups: []);
      print('auth_repository signInWithEmail');
      // await _users.doc(userModel.id).set(userModel.toMap());
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(Failure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return left(Failure('Wrong password provided for that user.'));
      }
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        print('auth_repository signInWithGoogle signInWithPopup');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) throw Exception("Not logged in");
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        print('auth_repository signInWithGoogle signInWithCredential');
        userCredential = await _auth.signInWithCredential(credential);
      }

      UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        DateTime now = DateTime.now();
        userModel = UserModel(
            id: userCredential.user!.uid,
            name: userCredential.user?.displayName ?? "",
            email: userCredential.user!.email ?? "",
            createdAt: now.toUtc(),
            timeZoneOffset: now.timeZoneOffset.inHours,
            lcAccountName: "",
            lcSubmissions: [],
            lcPenalties: [],
            lcBalance: 0.0,
            joinedGroups: [],
            createdGroups: []);
        print('auth_repository signInWithGoogle');
        await _users.doc(userModel.id).set(userModel.toMap());
      } else {
        print('auth_repository signInWithGoogle getUserData');
        userModel = await getUserDataById(userCredential.user!.uid);
      }
      return right(userModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('auth_repository sendPasswordResetEmail');
      return right('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(Failure('No user found for that email.'));
      }
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUserDataById(String id) async {
    try {
      print('auth_repository getUserDataById');
      final user = await _users.doc(id).get();
      return UserModel.fromMap(user.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Stream<UserModel> getUserData(String id) {
  //   print('auth_repository getUserData');
  //   return _users.doc(id).snapshots().map((event) {
  //     return UserModel.fromMap(event.data() as Map<String, dynamic>);
  //   });
  // }

  void logOut() async {
    print('auth_repository logOut');
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
