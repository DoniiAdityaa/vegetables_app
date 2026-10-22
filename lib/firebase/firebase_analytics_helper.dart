import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsHelper {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  FirebaseAnalytics get analytics => _analytics;
  FirebaseCrashlytics get crashlytics => _crashlytics;

  /// Set User ID across Analytics and Crashlytics
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      await _crashlytics.setUserIdentifier(userId ?? '');
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper setUserId error: $e");
    }
  }

  /// Set User Property
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      if (value != null) {
        await _crashlytics.setCustomKey(name, value);
      }
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper setUserProperty error: $e");
    }
  }

  /// Log User Login
  Future<void> logLogin({required String loginMethod}) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
      await _crashlytics.log("User logged in via $loginMethod");
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper logLogin error: $e");
    }
  }

  /// Log User Sign Up / Registration
  Future<void> logSignUp({required String signUpMethod}) async {
    try {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
      await _crashlytics.log("User signed up via $signUpMethod");
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper logSignUp error: $e");
    }
  }

  /// Log Screen View
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
      await _crashlytics.log("Viewed screen: $screenName");
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper logScreenView error: $e");
    }
  }

  /// Log Product Search
  Future<void> logSearch(String searchTerm) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper logSearch error: $e");
    }
  }

  /// Log Add To Cart
  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required double price,
    int quantity = 1,
  }) async {
    try {
      await _analytics.logAddToCart(
        currency: 'IDR',
        value: price * quantity,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            price: price,
            quantity: quantity,
          ),
        ],
      );
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper logAddToCart error: $e");
    }
  }

  /// Log Custom Event
  Future<void> logEvent(
    String name, [
    Map<String, Object>? parameters,
  ]) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper logEvent error: $e");
    }
  }

  /// Record Error to Crashlytics
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper recordError error: $e");
    }
  }

  /// Add Breadcrumb log to Crashlytics
  Future<void> recordLog(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e) {
      debugPrint("FirebaseAnalyticsHelper recordLog error: $e");
    }
  }
}
