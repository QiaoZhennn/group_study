import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
final storageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
      clientId: kIsWeb ? dotenv.env['GOOGLE_SIGN_IN_WEB_CLIENT_ID'] : null);
});
