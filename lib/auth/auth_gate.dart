import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vegetables_app/config/service_locator.dart';
import 'package:vegetables_app/config/user_preference.dart';
import 'package:vegetables_app/feature/login/login_screen.dart';
import 'package:vegetables_app/feature/main_navigation/main_navigation.dart';
import 'package:vegetables_app/firebase/firebase_analytics_helper.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with TickerProviderStateMixin {
  static const int _sessionExpiryDays = 7;

  // Animation Controllers
  late final AnimationController _logoController;
  late final AnimationController _fadeController;
  late final AnimationController _blobController;
  late final AnimationController _dotsController;

  // Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _fadeIn;
  late final Animation<double> _blobRotate;

  @override
  void initState() {
    super.initState();

    // Logo scale-in bounce
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Text & dots fade in
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    // Background blob slow rotation
    _blobController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    _blobRotate = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_blobController);

    // Bouncing dots animation loop
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    // Sequence: logo → fade text → auth check
    _logoController.forward().then((_) {
      _fadeController.forward();
    });

    _handleAuthCheck();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _blobController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  Future<void> _handleAuthCheck() async {
    // Delay estetis splash screen agar transisi mulus
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    // 1. Jika belum pernah login sama sekali
    if (user == null) {
      _navigateToLogin();
      return;
    }

    // 2. Jika ada user, periksa masa berlaku sesi (Session Expiry)
    final userPref = serviceLocator.get<UserPreference>();
    final lastLogin = userPref.getLastLoginTime();
    final now = DateTime.now();

    bool isExpired = false;
    if (lastLogin != null) {
      final difference = now.difference(lastLogin);
      if (difference.inDays >= _sessionExpiryDays) {
        isExpired = true;
      }
    }

    // 3. Sesi Kadaluarsa (Session Timeout >= 7 Hari)
    if (isExpired) {
      serviceLocator.get<FirebaseAnalyticsHelper>().recordLog(
        "User session expired after $_sessionExpiryDays days.",
      );

      // Auto sign-out demi keamanan
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
      await userPref.clearData();

      if (!mounted) return;
      _navigateToLogin(
        expiredMessage:
            "Sesi login Anda telah berakhir ($_sessionExpiryDays hari). Silakan masuk kembali.",
      );
      return;
    }

    // 4. Sesi Masih Valid: Perbarui waktu login terakhir & rekam ke analytics
    await userPref.setLastLoginTime(now);
    await serviceLocator.get<FirebaseAnalyticsHelper>().setUserId(user.uid);

    if (!mounted) return;
    _navigateToHome();
  }

  void _navigateToLogin({String? expiredMessage}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LoginScreen(sessionExpiredMessage: expiredMessage),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigation(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          // ── Decorative Background Blobs ──────────────────────────────
          AnimatedBuilder(
            animation: _blobRotate,
            builder: (context, _) {
              return Stack(
                children: [
                  // Top-right blob
                  Positioned(
                    top: -60,
                    right: -60,
                    child: Transform.rotate(
                      angle: _blobRotate.value * 0.3,
                      child: _buildBlob(
                        220,
                        primaryColor.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  // Bottom-left blob
                  Positioned(
                    bottom: -80,
                    left: -70,
                    child: Transform.rotate(
                      angle: -_blobRotate.value * 0.2,
                      child: _buildBlob(
                        260,
                        secondaryColor.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Center-left small accent
                  Positioned(
                    top: size.height * 0.38,
                    left: -30,
                    child: Transform.rotate(
                      angle: _blobRotate.value * 0.5,
                      child: _buildBlob(
                        120,
                        primaryColor200.withValues(alpha: 0.18),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Main Content ─────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo with bounce animation
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: _buildLogo(),
                  ),
                ),

                const SizedBox(height: 24),

                // Brand Name + Tagline
                FadeTransition(
                  opacity: _fadeIn,
                  child: Column(
                    children: [
                      Text(
                        'VegBox',
                        style: xlBold.copyWith(
                          color: primaryColor,
                          fontSize: 34,
                          letterSpacing: -1.0,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sayur Segar · Langsung Dari Petani',
                        style: xsRegular.copyWith(
                          color: textDarkSecondary,
                          fontSize: 13,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 52),

                // Bouncing Dots Loader
                FadeTransition(
                  opacity: _fadeIn,
                  child: _buildBouncingDots(),
                ),

                const Spacer(flex: 4),

                // Footer
                FadeTransition(
                  opacity: _fadeIn,
                  child: _buildFooter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────────────

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                primaryColor.withValues(alpha: 0.12),
                primaryColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        // Main icon container
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: pastelMint,
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.25),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.eco_rounded, size: 44, color: primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildBouncingDots() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            // Animasi bounce stagger menggunakan gelombang sin
            final double progress =
                (_dotsController.value * 2 * math.pi) - (i * 0.9);
            final double bounce = math.sin(progress);
            final double offsetY = bounce > 0 ? -bounce * 10.0 : 0.0;
            final Color dotColor = i == 1 ? secondaryColor : primaryColor;
            final double dotSize = i == 1 ? 9.0 : 7.0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.translate(
                offset: Offset(0, offsetY),
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildBlob(double size, Color color) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BlobPainter(color: color),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Blob Canvas Painter
// ─────────────────────────────────────────────────────────────────────────────

class _BlobPainter extends CustomPainter {
  final Color color;
  _BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Organic blob shape using cubic beziers
    path.moveTo(w * 0.5, 0);
    path.cubicTo(w * 0.85, 0, w, h * 0.2, w, h * 0.5);
    path.cubicTo(w, h * 0.8, w * 0.75, h, w * 0.5, h);
    path.cubicTo(w * 0.2, h, 0, h * 0.78, 0, h * 0.5);
    path.cubicTo(0, h * 0.22, w * 0.15, 0, w * 0.5, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.color != color;
}
