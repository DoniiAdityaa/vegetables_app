import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vegetables_app/config/service_locator.dart';
import 'package:vegetables_app/config/user_preference.dart';
import 'package:vegetables_app/feature/favorite/favorite_screen.dart';
import 'package:vegetables_app/feature/login/login_screen.dart';
import 'package:vegetables_app/feature/profile/edit_profile_screen.dart';
import 'package:vegetables_app/feature/profile/faq_screen.dart';
import 'package:vegetables_app/feature/profile/settings_screen.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Pengguna VegBox';
  String _userEmail = '';
  String _userPhone = '+62 812-3456-7890';
  String _userAddress =
      'Jl. Nakula I No. 5-11, Pendrikan Kidul, Semarang Tengah';
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    final userPref = serviceLocator.get<UserPreference>();

    if (user != null) {
      setState(() {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          _userName = user.displayName!;
        } else if (userPref.getUserName() != null &&
            userPref.getUserName()!.isNotEmpty) {
          _userName = userPref.getUserName()!;
        }

        if (user.email != null && user.email!.isNotEmpty) {
          _userEmail = user.email!;
        } else if (userPref.getUserEmail() != null &&
            userPref.getUserEmail()!.isNotEmpty) {
          _userEmail = userPref.getUserEmail()!;
        }

        _userPhotoUrl = user.photoURL;
      });
    }
  }

  String get _initials {
    if (_userName.trim().isEmpty) return 'VB';
    final parts = _userName.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          initialName: _userName,
          initialEmail: _userEmail,
          initialPhone: _userPhone,
          initialAddress: _userAddress,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _userName = result['name'] ?? _userName;
        _userEmail = result['email'] ?? _userEmail;
        _userPhone = result['phone'] ?? _userPhone;
        _userAddress = result['address'] ?? _userAddress;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) {
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
                  color: pastelRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: errorColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Keluar Akun?',
                style: sBold.copyWith(color: textNeutralPrimary, fontSize: 16),
              ),
            ],
          ),
          content: Text(
            'Apakah kamu yakin ingin keluar dari akun VegBox? Kamu perlu login kembali untuk berbelanja.',
            style: sRegular.copyWith(
              color: const Color(0xFF64748B),
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'Batal',
                style: sSemiBold.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);

                try {
                  await GoogleSignIn().signOut();
                } catch (_) {}
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (_) {}
                try {
                  await serviceLocator.get<UserPreference>().clearData();
                } catch (_) {}

                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Ya, Keluar',
                style: sSemiBold.copyWith(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER (Title)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Akun Saya',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. SCROLLABLE CONTENT
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 110.0),
                children: [
                  // A. CARD UTAMA PROFIL (Bisa di-tap untuk masuk ke Edit Profil)
                  _buildMainProfileCard(),

                  const SizedBox(height: 20),

                  // B. MENU OPTIONS (Edit Profile, FAQ, Settings)
                  Text(
                    'Pilihan Menu',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildMenuCardGroup(),

                  const SizedBox(height: 20),

                  // C. LOGOUT CARD BUTTON
                  _buildLogoutCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card Utama Profil Pengguna (Dapat di-tap untuk langsung ke halaman edit)
  Widget _buildMainProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _navigateToEditProfile,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Avatar Inisial Bulat / Foto Profil
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: pastelMint,
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 2),
                    image: _userPhotoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(_userPhotoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _userPhotoUrl == null
                      ? Center(
                          child: Text(
                            _initials,
                            style: xlBold.copyWith(
                              color: primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),

                // Info Nama, Email, dan Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sBold.copyWith(
                          color: textNeutralPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _userEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: xsRegular.copyWith(
                          color: const Color(0xFF64748B),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Chevron
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAF8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Grup Menu Card Rapi (Edit Profile, FAQ, Settings)
  Widget _buildMenuCardGroup() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Sayuran Favorit
          _buildMenuItemTile(
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFEF4444),
            iconBgColor: pastelRed,
            title: 'Sayuran Favorit',
            subtitle: 'Daftar produk sayur yang kamu sukai',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),

          // 2. FAQ (Pusat Bantuan)
          _buildMenuItemTile(
            icon: Icons.help_outline_rounded,
            iconColor: secondaryColor600,
            iconBgColor: pastelOrange,
            title: 'Pusat Bantuan & FAQ',
            subtitle: 'Pertanyaan umum seputar pesanan sayur',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FaqScreen()),
              );
            },
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),

          // 3. Settings (Pengaturan)
          _buildMenuItemTile(
            icon: Icons.settings_outlined,
            iconColor: const Color(0xFF2563EB),
            iconBgColor: pastelBlue,
            title: 'Pengaturan',
            subtitle: 'Notifikasi, keamanan, dan preferensi aplikasi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: sSemiBold.copyWith(
                        color: textNeutralPrimary,
                        fontSize: 13.5,
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
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tombol Keluar Akun
  Widget _buildLogoutCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECDD3), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _showLogoutDialog,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: errorColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keluar Akun',
                        style: sSemiBold.copyWith(
                          color: errorColor,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Keluar dari sesi belanja saat ini',
                        style: xsRegular.copyWith(
                          color: const Color(0xFFE11D48),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: errorColor,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
