import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegetables_app/config/service_locator.dart';
import 'package:vegetables_app/config/user_preference.dart';
import 'package:vegetables_app/feature/main_navigation/main_navigation.dart';
import 'package:vegetables_app/firebase/firebase_analytics_helper.dart';
import 'package:vegetables_app/firebase/firebase_email_auth.dart';
import 'package:vegetables_app/firebase/firebase_google.auth.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class LoginScreen extends StatefulWidget {
  final String? sessionExpiredMessage;
  const LoginScreen({super.key, this.sessionExpiredMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 0 = Masuk, 1 = Daftar
  int activeTabIndex = 0;

  // Form State
  bool isPasswordVisible = false;
  bool rememberMe = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sessionExpiredMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.sessionExpiredMessage!,
                    style: xsMedium.copyWith(
                      color: Colors.white,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFE11D48),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoginTab = activeTabIndex == 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // 1. NAMA APLIKASI (VegBox)
              _buildAppLogo(),

              const SizedBox(height: 20),

              // 2. JUDUL & SUBTITLE DINAMIS DENGAN ANIMASI HALUS
              _buildHeaderTitle(isLoginTab),

              const SizedBox(height: 28),

              // 3. PILL SWITCHER DENGAN INDIKATOR SLIDING HALUS [ Masuk | Daftar ]
              _buildPillSwitcher(isLoginTab),

              const SizedBox(height: 26),

              // 4. FORM FIELDS (LOGIN / REGISTER DENGAN ANIMASI HALUS)
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 320),
                firstCurve: Curves.easeInOutCubic,
                secondCurve: Curves.easeInOutCubic,
                sizeCurve: Curves.easeInOutCubic,
                crossFadeState: isLoginTab
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _buildLoginForm(),
                secondChild: _buildRegisterForm(),
              ),

              const SizedBox(height: 26),

              // 5. PEMBATAS "ATAU"
              _buildOrDivider(),

              const SizedBox(height: 22),

              // 6. TOMBOL SOCIAL LOGIN (GOOGLE & APPLE DENGAN SVG)
              _buildSocialButtons(),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. App Name Wordmark Logo
  Widget _buildAppLogo() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'VegBox',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textNeutralPrimary,
              letterSpacing: -0.5,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8, left: 3),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Header Title & Subtitle Dinamis dengan Smooth Slide + Fade
  Widget _buildHeaderTitle(bool isLoginTab) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.12),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        // key: ValueKey<bool>(isLoginTab),
        child: Center(
          child: Column(
            children: [
              Text(
                isLoginTab ? 'Masuk' : 'Daftar Akun',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textNeutralPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  isLoginTab
                      ? 'Masuk untuk mengelola dan memesan sayur segar harianmu.'
                      : 'Buat akun untuk mulai menikmati kemudahan belanja sayuran segar.',
                  textAlign: TextAlign.center,
                  style: sRegular.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 3. Pill Switcher [ Masuk | Daftar ] dengan Sliding Capsule Indicator
  Widget _buildPillSwitcher(bool isLoginTab) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final halfWidth = (constraints.maxWidth - 8) / 2;

        return Container(
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2EC),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              // Sliding Active Pill Capsule
              AnimatedAlign(
                alignment: isLoginTab
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                child: Container(
                  width: halfWidth,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Labels (Masuk & Daftar)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!isLoginTab) setState(() => activeTabIndex = 0);
                      },
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: sSemiBold.copyWith(
                            fontFamily: 'Poppins',
                            color: isLoginTab
                                ? Colors.white
                                : const Color(0xFF475569),
                            fontSize: 14,
                          ),
                          child: const Text('Masuk'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isLoginTab) setState(() => activeTabIndex = 1);
                      },
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: sSemiBold.copyWith(
                            fontFamily: 'Poppins',
                            color: !isLoginTab
                                ? Colors.white
                                : const Color(0xFF475569),
                            fontSize: 14,
                          ),
                          child: const Text('Daftar'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Feedback Toast / Floating SnackBar
  void _showFeedbackSnackBar({required String message, bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: xsMedium.copyWith(color: Colors.white, fontSize: 12.5),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFE11D48) : primaryColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Flow Masuk dengan Email & Password
  Future<void> _handleEmailLogin() async {
    FocusScope.of(context).unfocus();
    final email = _identifierController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showFeedbackSnackBar(
        message: 'Email dan kata sandi wajib diisi.',
        isError: true,
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showFeedbackSnackBar(
        message: 'Format email tidak valid (contoh: nama@email.com).',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    final emailAuth = serviceLocator.get<FirebaseEmailAuth>();
    final userPref = serviceLocator.get<UserPreference>();
    final analytics = serviceLocator.get<FirebaseAnalyticsHelper>();

    await emailAuth.signInWithEmail(
      email: email,
      password: password,
      onSuccess: (user) async {
        await analytics.setUserId(user.uid);
        await analytics.logLogin(loginMethod: 'email_password');

        await userPref.setUserId(user.uid);
        await userPref.setUserEmail(user.email ?? email);
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          await userPref.setUserName(user.displayName!);
        }
        await userPref.setLastLoginTime(DateTime.now());

        if (!mounted) return;
        setState(() => _isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      },
      onError: (message) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showFeedbackSnackBar(message: message, isError: true);
      },
    );
  }

  /// Flow Daftar Akun Baru dengan Email & Password
  Future<void> _handleEmailRegister() async {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    final email = _identifierController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      _showFeedbackSnackBar(
        message: 'Nama lengkap wajib diisi.',
        isError: true,
      );
      return;
    }

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _showFeedbackSnackBar(
        message: 'Masukkan alamat email yang valid.',
        isError: true,
      );
      return;
    }

    if (password.length < 6) {
      _showFeedbackSnackBar(
        message: 'Kata sandi minimal 6 karakter.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    final emailAuth = serviceLocator.get<FirebaseEmailAuth>();
    final userPref = serviceLocator.get<UserPreference>();
    final analytics = serviceLocator.get<FirebaseAnalyticsHelper>();

    await emailAuth.signUpWithEmail(
      name: name,
      email: email,
      password: password,
      onSuccess: (user) async {
        await analytics.setUserId(user.uid);
        await analytics.logSignUp(signUpMethod: 'email_password');

        await userPref.setUserId(user.uid);
        await userPref.setUserEmail(user.email ?? email);
        await userPref.setUserName(name);
        await userPref.setLastLoginTime(DateTime.now());

        if (!mounted) return;
        setState(() => _isLoading = false);

        _showFeedbackSnackBar(
          message: 'Pendaftaran berhasil! Selamat datang di VegBox.',
          isError: false,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      },
      onError: (message) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showFeedbackSnackBar(message: message, isError: true);
      },
    );
  }

  /// Flow Masuk dengan Akun Google
  Future<void> _handleGoogleSignIn() async {
    FocusScope.of(context).unfocus();
    setState(() => _isGoogleLoading = true);

    final googleAuth = serviceLocator.get<FirebaseGoogleAuth>();
    final userPref = serviceLocator.get<UserPreference>();
    final analytics = serviceLocator.get<FirebaseAnalyticsHelper>();

    await googleAuth.signInWithGoogle(
      onSuccess: (uid, email, firstName, lastName) async {
        final fullName = '$firstName $lastName'.trim();

        await analytics.setUserId(uid);
        await analytics.logLogin(loginMethod: 'google');

        await userPref.setUserId(uid);
        await userPref.setUserEmail(email);
        await userPref.setUserName(
          fullName.isNotEmpty ? fullName : 'Pengguna VegBox',
        );
        await userPref.setLastLoginTime(DateTime.now());

        if (!mounted) return;
        setState(() => _isGoogleLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      },
      onError: (message) {
        if (!mounted) return;
        setState(() => _isGoogleLoading = false);
        if (message.isNotEmpty) {
          _showFeedbackSnackBar(message: message, isError: true);
        }
      },
    );
  }

  /// Dialog Lupa Kata Sandi
  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController(
      text: _identifierController.text.trim(),
    );
    bool isSending = false;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: pastelMint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Atur Ulang Sandi',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan email akun Anda. Kami akan mengirimkan tautan untuk mengatur ulang kata sandi.',
                    style: sRegular.copyWith(
                      color: const Color(0xFF64748B),
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: resetEmailController,
                    keyboardType: TextInputType.emailAddress,
                    style: sMedium.copyWith(color: textNeutralPrimary),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAF8),
                      hintText: 'nama@email.com',
                      hintStyle: sRegular.copyWith(
                        color: const Color(0xFF94A3B8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              actions: [
                TextButton(
                  onPressed: isSending ? null : () => Navigator.pop(dialogCtx),
                  child: Text(
                    'Batal',
                    style: sSemiBold.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final email = resetEmailController.text.trim();
                          if (email.isEmpty || !email.contains('@')) {
                            _showFeedbackSnackBar(
                              message: 'Masukkan email yang valid.',
                              isError: true,
                            );
                            return;
                          }

                          setDialogState(() => isSending = true);

                          final emailAuth = serviceLocator
                              .get<FirebaseEmailAuth>();
                          await emailAuth.sendPasswordReset(
                            email: email,
                            onSuccess: () {
                              if (!mounted) return;
                              Navigator.pop(dialogCtx);
                              _showFeedbackSnackBar(
                                message:
                                    'Tautan reset sandi telah dikirim ke $email. Silakan periksa kotak masuk/spam.',
                                isError: false,
                              );
                            },
                            onError: (err) {
                              setDialogState(() => isSending = false);
                              _showFeedbackSnackBar(
                                message: err,
                                isError: true,
                              );
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Kirim Link',
                          style: sSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 4A. Form Masuk
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPillTextField(
          label: 'Email',
          hint: 'nama@email.com',
          controller: _identifierController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        _buildPillTextField(
          label: 'Kata Sandi',
          hint: 'Masukkan kata sandi',
          controller: _passwordController,
          isPassword: true,
          isPasswordVisible: isPasswordVisible,
          onTogglePassword: () {
            setState(() => isPasswordVisible = !isPasswordVisible);
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Checkbox Ingat Saya (Circle)
            GestureDetector(
              onTap: () => setState(() => rememberMe = !rememberMe),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rememberMe ? primaryColor : Colors.white,
                      border: Border.all(
                        color: rememberMe
                            ? primaryColor
                            : const Color(0xFFCBD5E1),
                        width: 1.5,
                      ),
                    ),
                    child: rememberMe
                        ? const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ingat saya',
                    style: xsRegular.copyWith(color: const Color(0xFF475569)),
                  ),
                ],
              ),
            ),

            // Lupa Sandi
            GestureDetector(
              onTap: _showForgotPasswordDialog,
              child: Text(
                'Lupa sandi?',
                style: xsSemiBold.copyWith(color: primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailLogin,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.2,
                    ),
                  )
                : Text(
                    'Masuk',
                    style: sSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// 4B. Form Daftar
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPillTextField(
          label: 'Nama Lengkap',
          hint: 'Masukkan nama lengkap',
          controller: _nameController,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 18),
        _buildPillTextField(
          label: 'Email',
          hint: 'nama@email.com',
          controller: _identifierController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        _buildPillTextField(
          label: 'Kata Sandi',
          hint: 'Minimal 6 karakter',
          controller: _passwordController,
          isPassword: true,
          isPasswordVisible: isPasswordVisible,
          onTogglePassword: () {
            setState(() => isPasswordVisible = !isPasswordVisible);
          },
        ),
        const SizedBox(height: 26),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailRegister,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.2,
                    ),
                  )
                : Text(
                    'Daftar Sekarang',
                    style: sSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// Reusable Pill TextField
  Widget _buildPillTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: sSemiBold.copyWith(color: textNeutralPrimary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          style: sMedium.copyWith(color: textNeutralPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: sRegular.copyWith(color: const Color(0xFF94A3B8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            suffixIcon: isPassword
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      onPressed: onTogglePassword,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  /// 5. Pembatas ATAU
  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFE2E8F0), thickness: 0.8),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'ATAU',
            style: xsMedium.copyWith(
              color: const Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFE2E8F0), thickness: 0.8),
        ),
      ],
    );
  }

  /// 6. Tombol Social Login
  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialPill(
            label: 'Google',
            svgPath: 'assets/svg/google_logo.svg',
            isLoading: _isGoogleLoading,
            onTap: _isGoogleLoading ? () {} : _handleGoogleSignIn,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSocialPill(
            label: 'Apple',
            svgPath: 'assets/svg/apple_logo.svg',
            isLoading: false,
            onTap: () {
              _showFeedbackSnackBar(
                message:
                    'Masuk dengan Apple ID segera hadir di pembaruan berikutnya.',
                isError: false,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialPill({
    required String label,
    required String svgPath,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2EC),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 2,
                  ),
                )
              else
                SvgPicture.asset(svgPath, width: 20, height: 20),
              const SizedBox(width: 10),
              Text(
                isLoading ? 'Memuat...' : label,
                style: sSemiBold.copyWith(
                  color: textNeutralPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
