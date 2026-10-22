import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegetables_app/feature/home/home_screen.dart';
import 'package:vegetables_app/feature/notification/notification_screen.dart';
import 'package:vegetables_app/feature/orders/order_history_screen.dart';
import 'package:vegetables_app/feature/profile/profile_screen.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  /// Helper untuk berpindah tab dari screen anak (misalnya dari Home Screen)
  static void switchToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationState>();
    if (state != null) {
      state.setTab(index);
    } else {
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
      } else if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
        );
      } else if (index == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    }
  }

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void setTab(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() => _currentIndex = index);
    }
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    NotificationScreen(),
    _BasketPlaceholderPage(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. CONTENT PAGES DENGAN INDEXEDSTACK (State tidak reload saat ganti tab)
          IndexedStack(index: _currentIndex, children: _pages),

          // 2. FLOATING WHITE PILL NAVIGATION BAR
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  /// Floating White Capsule Navigation Bar
  Widget _buildFloatingNavBar() {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Slot 1: Beranda (Home SVG)
          _buildNavItem(index: 0, svgPath: 'assets/svg/home.svg'),

          // Slot 2: Notifikasi (Bell Icon)
          _buildNavItem(
            index: 1,
            iconData: Icons.notifications_none_rounded,
            activeIconData: Icons.notifications_rounded,
          ),

          // Slot 3 (Center Action): Keranjang Belanja (Basket SVG)
          _buildCenterActionItem(index: 2),

          // Slot 4: Pesanan / Riwayat (Document SVG)
          _buildNavItem(index: 3, svgPath: 'assets/svg/document.svg'),

          // Slot 5: Akun / Profil (Profile SVG)
          _buildNavItem(index: 4, svgPath: 'assets/svg/profile.svg'),
        ],
      ),
    );
  }

  /// Standard Nav Item (Gaya sebelumnya: Icon-only dengan animated dot indicator)
  Widget _buildNavItem({
    required int index,
    String? svgPath,
    IconData? iconData,
    IconData? activeIconData,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? primaryColor : const Color(0xFF94A3B8);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: svgPath != null
                  ? SvgPicture.asset(
                      svgPath,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    )
                  : Icon(
                      isSelected ? (activeIconData ?? iconData) : iconData,
                      size: 22,
                      color: color,
                    ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 4 : 0,
              height: isSelected ? 4 : 0,
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Center Hero Action Button (Lingkaran Hijau Botani dengan Basket SVG)
  Widget _buildCenterActionItem({required int index}) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: isSelected ? 0.45 : 0.28),
              blurRadius: isSelected ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/basket.svg',
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// PLACEHOLDER PAGES (Untuk Pesanan, Keranjang, Kategori, dan Profil)
/// ============================================================================

class _BasketPlaceholderPage extends StatelessWidget {
  const _BasketPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Keranjang Belanja',
          style: sBold.copyWith(color: textNeutralPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2EC),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/basket.svg',
                  width: 38,
                  height: 38,
                  colorFilter: const ColorFilter.mode(
                    primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Keranjang Masih Kosong', style: sBold.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              'Pilih sayur segar favoritmu di Beranda.',
              style: sRegular.copyWith(color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _CategoryPlaceholderPage extends StatelessWidget {
  const _CategoryPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Kategori Sayuran',
          style: sBold.copyWith(color: textNeutralPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E6),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/category.svg',
                  width: 32,
                  height: 32,
                  colorFilter: const ColorFilter.mode(
                    secondaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Semua Kategori', style: sBold.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              'Sayur Daun, Buah, Umbi, dan Paket Masak.',
              style: sRegular.copyWith(color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}

