import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotif = true;
  bool _promoPanenNotif = true;
  bool _orderStatusNotif = true;
  bool _isDarkMode = false;
  String _selectedLanguage = 'ID'; // 'ID' or 'EN'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER (Back Button + Title)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppBackButton(),
                  Text(
                    'Pengaturan',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 42), // Balance spacer
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. SETTINGS LIST
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 32.0),
                children: [
                  // Section 1: Notifikasi
                  _buildSectionHeader('Notifikasi'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          title: 'Push Notifikasi',
                          subtitle: 'Terima pembaruan aplikasi langsung',
                          value: _pushNotif,
                          onChanged: (val) => setState(() => _pushNotif = val),
                        ),
                        const Divider(
                          color: Color(0xFFF1F5F9),
                          height: 1,
                          thickness: 1,
                        ),
                        _buildSwitchTile(
                          title: 'Info Panen Subuh & Promo',
                          subtitle: 'Kabar sayur segar dipetik pagi hari',
                          value: _promoPanenNotif,
                          onChanged: (val) =>
                              setState(() => _promoPanenNotif = val),
                        ),
                        const Divider(
                          color: Color(0xFFF1F5F9),
                          height: 1,
                          thickness: 1,
                        ),
                        _buildSwitchTile(
                          title: 'Status Pengiriman Pesanan',
                          subtitle: 'Lacak proses kemas dan kurir berjalan',
                          value: _orderStatusNotif,
                          onChanged: (val) =>
                              setState(() => _orderStatusNotif = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section 2: Preferensi Sistem (Bahasa & Dark Mode)
                  _buildSectionHeader('Preferensi & Tampilan'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Bahasa Aplikasi dengan Switcher ID & ENG
                        _buildLanguageTile(),
                        const Divider(
                          color: Color(0xFFF1F5F9),
                          height: 1,
                          thickness: 1,
                        ),
                        // Mode Gelap (Dark Mode)
                        _buildDarkModeTile(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: sBold.copyWith(color: textNeutralPrimary, fontSize: 13.5),
      ),
    );
  }

  Widget _buildLanguageTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bahasa Aplikasi',
                  style: sSemiBold.copyWith(
                    color: textNeutralPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedLanguage == 'ID'
                      ? 'Bahasa Indonesia aktif'
                      : 'English language active',
                  style: xsRegular.copyWith(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Switcher ID & ENG
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedLanguage = _selectedLanguage == 'ID' ? 'EN' : 'ID';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _selectedLanguage == 'ID'
                        ? 'Bahasa diubah ke Bahasa Indonesia'
                        : 'Language switched to English',
                    style: sMedium.copyWith(color: Colors.white),
                  ),
                  backgroundColor: primaryColor,
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Container(
              width: 82,
              height: 34,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment: _selectedLanguage == 'ID'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 36,
                      height: 28,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.28),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'ID',
                            style: xsSemiBold.copyWith(
                              color: _selectedLanguage == 'ID'
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'ENG',
                            style: xsSemiBold.copyWith(
                              color: _selectedLanguage == 'EN'
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode Gelap (Dark Mode)',
                  style: sSemiBold.copyWith(
                    color: textNeutralPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isDarkMode ? 'Tema malam aktif' : 'Tema terang aktif',
                  style: xsRegular.copyWith(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Custom Dark Mode Switcher with Moon & Sun SVG Icons
          GestureDetector(
            onTap: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isDarkMode
                        ? 'Mode Gelap diaktifkan'
                        : 'Mode Terang diaktifkan',
                    style: sMedium.copyWith(color: Colors.white),
                  ),
                  backgroundColor: primaryColor,
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOut,
              width: 76,
              height: 34,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: _isDarkMode
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: _isDarkMode
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Muted background track icons
                  Row(
                    children: [
                      // Moon on the left
                      Expanded(
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/moon.svg',
                            width: 15,
                            height: 15,
                            colorFilter: ColorFilter.mode(
                              _isDarkMode
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      // Sun on the right
                      Expanded(
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/sun.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              _isDarkMode
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Animated sliding circular thumb with active icon
                  AnimatedAlign(
                    alignment: _isDarkMode
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _isDarkMode
                              ? SvgPicture.asset(
                                  'assets/svg/moon.svg',
                                  key: const ValueKey('moon_active'),
                                  width: 15,
                                  height: 15,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'assets/svg/sun.svg',
                                  key: const ValueKey('sun_active'),
                                  width: 16,
                                  height: 16,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: sSemiBold.copyWith(
                    color: textNeutralPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: xsRegular.copyWith(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
