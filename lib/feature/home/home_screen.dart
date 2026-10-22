import 'package:flutter/material.dart';
import 'package:vegetables_app/feature/detail/detail_screen.dart';
import 'package:vegetables_app/feature/main_navigation/main_navigation.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Semua',
    'Sayur Daun',
    'Sayur Buah',
    'Sayur Umbi',
    'Organik',
    'Paket Masak',
    'Bumbu Dapur',
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Bayam Hijau Organik',
      'category': 'Sayur Daun',
      'tag': '100% Organik',
      'tagColor': primaryColor,
      'tagBg': pastelMint,
      'unit': '250 gram / ikat',
      'price': 4500,
      'originalPrice': 6000,
      'rating': 4.9,
      'sold': '120+ terjual',
      'imageUrl':
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Wortel Manis Brastagi',
      'category': 'Sayur Umbi',
      'tag': 'Panen Baru',
      'tagColor': secondaryColor600,
      'tagBg': pastelOrange,
      'unit': '500 gram / pack',
      'price': 8500,
      'originalPrice': 10000,
      'rating': 4.8,
      'sold': '85 terjual',
      'imageUrl':
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Tomat Cherry Hidroponik',
      'category': 'Sayur Buah',
      'tag': 'Segar',
      'tagColor': Color(0xFFDC2626),
      'tagBg': pastelRed,
      'unit': '250 gram / pack',
      'price': 12000,
      'originalPrice': null,
      'rating': 5.0,
      'sold': '60+ terjual',
      'imageUrl':
          'https://images.unsplash.com/photo-1546470427-0d4db154ceb7?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Brokoli Hijau Segar',
      'category': 'Sayur Daun',
      'tag': 'Bebas Pestisida',
      'tagColor': primaryColor,
      'tagBg': pastelMint,
      'unit': '1 bonggol (~400 gr)',
      'price': 14000,
      'originalPrice': 16500,
      'rating': 4.9,
      'sold': '94 terjual',
      'imageUrl':
          'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=500&auto=format&fit=crop&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. TOP HEADER (LOKASI & NOTIFIKASI/KERANJANG)
            _buildTopHeader(),

            // 2. MAIN SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // 2A. SEARCH BAR CAPSULE
                    _buildSearchBar(),

                    const SizedBox(height: 18),

                    // 2B. HERO BANNER PROMO / INFO PANEN
                    // _buildHeroBanner(),
                    const SizedBox(height: 24),

                    // 2C. KATEGORI PILIHAN (PASTEL TILES)
                    _buildCategorySection(),

                    const SizedBox(height: 24),

                    // 2D. SECTION PRODUK "PALING SEGAR HARI INI"
                    _buildProductSectionHeader(),

                    const SizedBox(height: 14),

                    // 2E. GRID PRODUK SAYUR
                    _buildProductGrid(),

                    const SizedBox(height: 24),

                    // 2F. BANNER PAKET MASAK HEMAT
                    // _buildRecipePackBanner(),
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Header: Lokasi Pengiriman & Akses Cepat
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          // Icon Pin Lokasi
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2EC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Teks Lokasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dikirim ke alamat',
                  style: xsRegular.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Jl. Pemuda No. 45, Semarang',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sBold.copyWith(
                          color: textNeutralPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: textNeutralPrimary,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tombol Notifikasi
          _buildCircleIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {
              MainNavigation.switchToTab(context, 1);
            },
            hasBadge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasBadge = false,
    int? badgeCount,
  }) {
    return Stack(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(21),
              onTap: onTap,
              child: Icon(icon, color: textNeutralPrimary, size: 20),
            ),
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 9,
            right: 10,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
          ),
        if (badgeCount != null)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              alignment: Alignment.center,
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 2A. Search Bar Pill Minimalis
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F2),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cari bayam, wortel, brokoli...',
                style: sRegular.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: textNeutralPrimary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 2B. Hero Promo Banner
  // ignore: unused_element
  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF037432), Color(0xFF04883B), Color(0xFF159E4E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.22),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Konten Teks & Tombol
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'PANEN SUBUH HARI INI',
                        style: sBold.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Segar Alami,\nLangsung dari Petani',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Diskon 20% tanpa batas minimum belanja',
                  style: sRegular.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Belanja Sekarang',
                        style: sSemiBold.copyWith(
                          color: primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: primaryColor,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 2C. Section Kategori Pilihan (Minimalist Text Pills ala Referensi)
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kategori Pilihan',
                style: sBold.copyWith(color: textNeutralPrimary, fontSize: 17),
              ),
              Text(
                'Lihat Semua',
                style: sSemiBold.copyWith(color: primaryColor, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final catName = _categories[index];
              final isSelected = _selectedCategoryIndex == index;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() => _selectedCategoryIndex = index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFD8F2E1)
                        : const Color(0x00D8F2E1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    catName,
                    style: (isSelected ? sSemiBold : sMedium).copyWith(
                      color: isSelected
                          ? textNeutralPrimary
                          : const Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 2D. Header Section Produk
  Widget _buildProductSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Paling Segar Hari Ini',
                style: sBold.copyWith(color: textNeutralPrimary, fontSize: 17),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: pastelOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Subuh',
                  style: sBold.copyWith(color: secondaryColor600, fontSize: 10),
                ),
              ),
            ],
          ),
          Text(
            'Lihat Semua',
            style: sSemiBold.copyWith(color: primaryColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategoryIndex == 0) return _products;
    final selectedCat = _categories[_selectedCategoryIndex];
    final filtered = _products
        .where((p) => p['category'] == selectedCat)
        .toList();
    return filtered.isNotEmpty ? filtered : _products;
  }

  /// 2E. Grid Produk Sayur 2 Kolom
  Widget _buildProductGrid() {
    final items = _filteredProducts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildProductCard(item);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    final imageUrl = item['imageUrl'] as String;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(product: item)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk & Badge
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAF8),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                    child: Hero(
                      tag: imageUrl,
                      flightShuttleBuilder:
                          (
                            flightContext,
                            animation,
                            flightDirection,
                            fromHeroContext,
                            toHeroContext,
                          ) {
                            final BorderRadiusTween borderRadiusTween =
                                BorderRadiusTween(
                                  begin: const BorderRadius.vertical(
                                    top: Radius.circular(17),
                                  ),
                                  end: const BorderRadius.vertical(
                                    bottom: Radius.circular(28),
                                  ),
                                );

                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            );

                            return AnimatedBuilder(
                              animation: curvedAnimation,
                              builder: (context, child) {
                                return ClipRRect(
                                  borderRadius:
                                      borderRadiusTween.evaluate(
                                        curvedAnimation,
                                      ) ??
                                      BorderRadius.zero,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(17),
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.eco_rounded,
                                color: primaryColor,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Badge Status (Organik / Panen Baru)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: item['tagBg'] as Color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['tag'] as String,
                        style: sSemiBold.copyWith(
                          color: item['tagColor'] as Color,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),

                  // Icon Favorite
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Deskripsi & Harga
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['unit'] as String,
                    style: xsRegular.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Baris Harga & Tombol Tambah (+)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item['originalPrice'] != null)
                            Text(
                              'Rp ${item['originalPrice']}',
                              style: xsRegular.copyWith(
                                color: const Color(0xFFCBD5E1),
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            'Rp ${item['price']}',
                            style: sBold.copyWith(
                              color: primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // Tombol Tambah Hijau Kapsul
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item['name']} ditambahkan ke keranjang',
                                    style: sMedium.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: primaryColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 2F. Banner Paket Masak Hemat
  // ignore: unused_element
  Widget _buildRecipePackBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2EC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD4ECD9), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.soup_kitchen_rounded,
                color: primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paket Masak Siap Saji',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sayur Asem, Sop & Capcay tinggal cemplung.',
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
              color: primaryColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
