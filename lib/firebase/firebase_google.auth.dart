import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/constant.dart';

class FirebaseGoogleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _recordError(dynamic error, [StackTrace? stackTrace, String? reason]) {
    try {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
      );
    } catch (e) {
      debugPrint("Error recording to Crashlytics: $e");
    }
  }

  Future<void> signInWithGoogle({
    required Function(
      String uid,
      String email,
      String firstName,
      String lastName,
    )
    onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint("Pre-signin signout note: $e");
      }

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();

      if (googleSignInAccount == null) {
        onError("");
        _recordError(
          "tidak memilih email",
          StackTrace.current,
          "User cancelled Google Sign In",
        );
        return;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user?.uid == null) {
        onError('User id is empty');
        _recordError("empty user id", StackTrace.current);
        return;
      }

      final displayName = userCredential.user?.displayName ?? "";
      final nameParts = displayName.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : "";

      onSuccess(
        userCredential.user!.uid,
        googleSignInAccount.email,
        firstName,
        lastName,
      );
    } catch (error, stackTrace) {
      if (error is FirebaseAuthException) {
        _recordError(error.message ?? "", stackTrace);
      }
      debugPrint(error.toString());
      onError(error.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint("Error signing out Google: $e");
    }
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint("Error signing out FirebaseAuth: $e");
    }
  }

  Future<GoogleSignInAccount?> getGoogleAccount() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        null;
      }

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();

      return googleSignInAccount;
    } catch (error, stackTrace) {
      if (error is FirebaseAuthException) {
        _recordError(error.message ?? "", stackTrace);
      }
      return null;
    }
  }

  Future<void> linkWithGoogle({
    required Function(String email) onSuccess,
    required Function(String message) onError,
    required GoogleSignInAccount account,
  }) async {
    try {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final userCredential = await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential);
        if (userCredential != null) {
          onSuccess(account.email);
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        _recordError(e.message ?? "", stackTrace);
        switch (e.code) {
          case "provider-already-linked":
            {
              await FirebaseAuth.instance.currentUser?.unlink("google.com");
              linkWithGoogle(
                onSuccess: onSuccess,
                onError: onError,
                account: account,
              );
            }
            return;
          case "invalid-credential":
            onError("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            try {
              final secondaryApp = await Firebase.initializeApp(
                name: firebaseSecondaryApp,
                options: Firebase.app().options,
              );
              final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
              final GoogleSignInAuthentication googleSignInAuthentication =
                  await account.authentication;
              GoogleAuthProvider.credential(
                accessToken: googleSignInAuthentication.accessToken,
                idToken: googleSignInAuthentication.idToken,
              );
              await secondaryAuth.currentUser?.delete();
              linkWithGoogle(
                onSuccess: onSuccess,
                onError: onError,
                account: account,
              );
            } catch (e) {
              onError(e.toString());
            }

            break;
          // See the API reference for the full list of error codes.
          default:
            onError("Unknown error.");
        }
      }
    } catch (error, stackTrace) {
      if (error is FirebaseAuthException) {
        _recordError(error.message ?? "", stackTrace);
      }
      onError(error.toString());
    }
  }
}
