import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'main_provider.dart';

final authServiceProvider = Provider<AuthBase>((ref) {
  return AuthService();
});

final authStateChangeProvider = StreamProvider<auth.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.idTokenChanges();
});

abstract class AuthBase {
  auth.User? get currentUser;
  Stream<auth.User?> authStateChanges();
  Stream<auth.User?> idTokenChanges();
  Future<auth.User?> signInAnonymously();
  Future<auth.User?> signInWithEmailWithPassword(String email, String password);
  Future<auth.User?> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<auth.User?> signInWithGoogle();
  Future<auth.User?> signInWithFacebook();
  Future<auth.User?> signInWithApple();
  Future<auth.User?> signInWithKakao();

  Future<void> signOut();
}

class AuthService implements AuthBase {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> authStateChanges() => _auth.authStateChanges();

  @override
  Stream<auth.User?> idTokenChanges() => _auth.idTokenChanges();

  @override
  auth.User? get currentUser => _auth.currentUser;

  // Firebase user
  auth.User? _user;

  auth.User? getUser() {
    return _user;
  }

  void setUser(auth.User value) {
    _user = value;
  }

  ///////// Sign In Anonymously
  @override
  Future<auth.User?> signInAnonymously() async {
    logger.d('signInAnonymously triggered in auth');
    final userCredential = await auth.FirebaseAuth.instance.signInAnonymously();
    final user = userCredential.user;

    final currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);
    setUser(user!);

    return user;
  }

  ///////// Sign In With Email and Password
  @override
  Future<auth.User?> signInWithEmailWithPassword(
    String email,
    String password,
  ) async {
    logger.d('signInWithEmailWithPassword triggered in auth');

    var userCredential =
        await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    final currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);
    setUser(user!);

    return user;
  }

  ///////// Create User With Email And Password
  @override
  Future<auth.User?> createUserWithEmailAndPassword(
      String email, String password) async {
    logger.d('createUserWithEmailAndPassword triggered in auth');

    var userCredential =
        await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    final currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);
    setUser(user!);

    return user;
  }

  /// SIGN IN WITH GOOGLE
  @override
  Future<auth.User?> signInWithGoogle() async {
    logger.d('signInWithGoogle triggered in auth');

    // Trigger Authentication flow
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final googleAuth = await googleSignInAccount.authentication;
      if (googleAuth.idToken != null) {
        final auth.OAuthCredential credential =
            auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user;

        final currentUser = _auth.currentUser;
        assert(user!.uid == currentUser!.uid);
        setUser(user!);

        return user;
      } else {
        throw auth.FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw auth.FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  // Sign In with Facebook
  @override
  Future<auth.User?> signInWithFacebook() async {
    logger.d('signInWithFacebook auth triggered in auth');

    final facebookLogin = await FacebookAuth.instance.login();
    if (facebookLogin.status == LoginStatus.success) {
      final credential = auth.FacebookAuthProvider.credential(
        facebookLogin.accessToken!.token,
      );

      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;

      final currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      setUser(user!);

      return user;
    } else if (facebookLogin.status == LoginStatus.cancelled) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
        message: 'Sign in aborted by user',
      );
    } else if (facebookLogin.status == LoginStatus.failed) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
        message: 'Sign in Failed',
      );
    } else {
      throw auth.FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
        message: 'Sign in Failed',
      );
    }
  }

  // Sign In With Apple
  @override
  Future<auth.User?> signInWithApple() async {
    logger.d('signInWithApple triggered in auth');

    //Trigger the authentication flow
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.healtine.playerh',
          redirectUri: Uri.parse(
            'https://player-h.firebaseapp.com/__/auth/handler',
          ),
        ),
      );

      // Create a new credential
      final oAuthProvider = auth.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        accessToken: result.authorizationCode,
        idToken: result.identityToken,
      );

      // Using credential to get the user
      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;

      final currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      setUser(user!);

      return user;
    } on auth.FirebaseAuthException catch (e) {
      logger.d(e);
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
    }
  }

  @override
  Future<auth.User?> signInWithKakao() async {
    logger.d('signInwithKakao triggered in auth');

    try {
      final accessToken = await _getToken();
      final authResult = await _auth.signInWithCustomToken(
        await _verifyToken(accessToken),
      );

      final user = authResult.user;

      final currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      setUser(user!);

      return user;
    } on KakaoAuthException catch (e) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
      // some error happened during the course of user login... deal with it.
    } on KakaoClientException catch (e) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
      //
    } catch (e) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
      //
    }
  }

  Future<String> _getToken() async {
    debugPrint('get token function triggered');
    final installed = await isKakaoTalkInstalled();
    final authCode = installed
        ? await AuthCodeClient.instance.requestWithTalk()
        : await AuthCodeClient.instance.request();
    final token = await AuthApi.instance.issueAccessToken(authCode);

    await AccessTokenStore.instance.toStore(token);
    return token.accessToken;
  }

  Future<String> _verifyToken(String kakaoToken) async {
    debugPrint('_verifyToken function triggered in auth');

    try {
      FirebaseFunctions functions = FirebaseFunctions.instance;
      HttpsCallable callable = functions.httpsCallable('verifyKakaoToken');

      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'token': kakaoToken,
        },
      );

      if (result.data['error'] != null) {
        return Future.error(result.data['error']);
      } else {
        return result.data['token'];
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // Sign Out
  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final facebookLogin = FacebookAuth.instance;
    await facebookLogin.logOut();

    await _auth.signOut();
  }
}
