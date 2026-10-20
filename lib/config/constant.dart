import 'env/env.dart';

/// App Config
const String appName = "Vegetables App";
const String appVersion = "1.0.0";

/// Network Config
const String baseUrl = Env.baseUrl;
const String baseApi = "$baseUrl/api";
const int timeOutDuration = 30;

/// Firebase Config
const String firebaseSecondaryApp = "secondary";

/// Image Config
const double imageMaxHeight = 720;
const double imageMaxWidth = 720;

/// UI Enums
enum SnackBarPosition { top, bottom }

enum DatePickerType { day, range }
