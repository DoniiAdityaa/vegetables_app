import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegetables_app/feature/main_navigation/main_navigation.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 0 = Masuk, 1 = Daftar
  int activeTabIndex = 0;

  // Form State
  bool isPasswordVisible = false;
  bool rememberMe = true;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  /// 4A. Form Masuk
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPillTextField(
          label: 'Nomor HP atau Email',
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

            // Lupa Sandi (Warna Hijau Brand Primary yang Selaras)
            GestureDetector(
              onTap: () {
                // TODO: Flow Lupa Sandi
              },
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
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigation()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'Masuk',
              style: sSemiBold.copyWith(color: Colors.white, fontSize: 15),
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
          label: 'Nomor HP atau Email',
          hint: 'nama@email.com',
          controller: _identifierController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        _buildPillTextField(
          label: 'Kata Sandi',
          hint: 'Minimal 8 karakter',
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
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigation()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'Daftar Sekarang',
              style: sSemiBold.copyWith(color: Colors.white, fontSize: 15),
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
            onTap: () {
              // TODO: Google Sign-In
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSocialPill(
            label: 'Apple',
            svgPath: 'assets/svg/apple_logo.svg',
            onTap: () {
              // TODO: Apple Sign-In
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
              SvgPicture.asset(svgPath, width: 20, height: 20),
              const SizedBox(width: 10),
              Text(
                label,
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
