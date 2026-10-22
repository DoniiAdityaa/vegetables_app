import 'package:flutter/material.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;
  int _selectedInfoTab =
      0; // 0: Manfaat & Nutrisi, 1: Tips Simpan, 2: Ide Masak

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final int price = (product['price'] as int?) ?? 0;
    final int? originalPrice = product['originalPrice'] as int?;
    final String name = (product['name'] as String?) ?? 'Sayuran Segar';
    final String unit = (product['unit'] as String?) ?? '250 gram / ikat';
    final String imageUrl = (product['imageUrl'] as String?) ?? '';
    final String tag = (product['tag'] as String?) ?? '100% Organik';
    final double rating = (product['rating'] as double?) ?? 4.9;
    final String sold = (product['sold'] as String?) ?? '100+ terjual';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. SCROLLABLE PRODUCT DETAILS
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1A. HERO IMAGE APP BAR
              SliverToBoxAdapter(
                child: _buildHeroImageSection(imageUrl: imageUrl, tag: tag),
              ),

              // 1B. PRODUCT INFO BODY
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Status Panen & Asal Petani
                      _buildFarmOriginBadge(),

                      const SizedBox(height: 12),

                      // Nama Produk & Favorite
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: sBold.copyWith(
                                    color: textNeutralPrimary,
                                    fontSize: 22,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  unit,
                                  style: sMedium.copyWith(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Tombol Favorite
                          GestureDetector(
                            onTap: () {
                              setState(() => _isFavorite = !_isFavorite);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _isFavorite
                                    ? pastelRed
                                    : const Color(0xFFF8FAF8),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isFavorite
                                      ? const Color(0xFFFCA5A5)
                                      : const Color(0xFFE2E8F0),
                                  width: 1.2,
                                ),
                              ),
                              child: Icon(
                                _isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: _isFavorite
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF94A3B8),
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Rating & Terjual
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: pastelYellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFF59E0B),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$rating',
                                  style: sBold.copyWith(
                                    color: const Color(0xFFB45309),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: sRegular.copyWith(
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            sold,
                            style: sMedium.copyWith(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: sRegular.copyWith(
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Stok Tersedia',
                            style: sSemiBold.copyWith(
                              color: primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Harga & Diskon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rp $price',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          if (originalPrice != null) ...[
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                'Rp $originalPrice',
                                style: sRegular.copyWith(
                                  color: const Color(0xFFCBD5E1),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: pastelRed,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-25%',
                                style: sBold.copyWith(
                                  color: const Color(0xFFDC2626),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 22),
                      const Divider(color: Color(0xFFF1F5F9), thickness: 1.2),
                      const SizedBox(height: 16),

                      // 4 QUICK SPEC CARDS (Pestisida, Masa Simpan, Suhu, Nutrisi)
                      _buildSpecGrid(),

                      const SizedBox(height: 24),

                      // TAB INFORMASI (Manfaat Nutrisi / Tips Simpan / Olahan)
                      _buildInfoTabs(),

                      const SizedBox(height: 14),

                      // ISI TAB KONTEN
                      _buildInfoTabContent(),

                      const SizedBox(height: 120), // Spasi untuk bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. FLOATING TOP NAV BAR (Back button & Share)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildFloatingTopBar(context),
          ),

          // 3. STICKY BOTTOM CHECKOUT / ADD-TO-CART BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActionBar(price, name),
          ),
        ],
      ),
    );
  }

  /// 1A. Hero Showcase Image (Full Immersive Edge-to-Edge)
  Widget _buildHeroImageSection({
    required String imageUrl,
    required String tag,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 380,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Foto Produk Sayuran Full Bleed dengan Seamless Hero Animation
          Hero(
            tag: imageUrl,
            flightShuttleBuilder:
                (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) {
                  final BorderRadiusTween borderRadiusTween = BorderRadiusTween(
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
                            borderRadiusTween.evaluate(curvedAnimation) ??
                            BorderRadius.zero,
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      );
                    },
                  );
                },
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF1F5F2),
                    child: const Center(
                      child: Icon(
                        Icons.eco_rounded,
                        size: 90,
                        color: primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Gradient Overlay Atas (agar Status Bar & Tombol Navigasi kontras jelas)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // Tag Status Badge (Pojok Kiri Bawah Foto)
          Positioned(
            bottom: 18,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: primaryColor,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tag,
                    style: sSemiBold.copyWith(
                      color: primaryColor,
                      fontSize: 11,
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

  /// Floating Top Bar (Back & Share)
  Widget _buildFloatingTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Kembali Reusable
            const AppBackButton(isFrosted: true),

            // Tombol Share
            _buildCircleNavBtn(
              icon: Icons.share_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tautan produk disalin',
                      style: sMedium.copyWith(color: Colors.white),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleNavBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(21),
          onTap: onTap,
          child: Icon(icon, color: textNeutralPrimary, size: 18),
        ),
      ),
    );
  }

  /// Badge Asal Petani & Kesegaran
  Widget _buildFarmOriginBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.nature_people_rounded,
            color: primaryColor,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            'Panen Subuh Tadi • Petani Lokal Ambarawa',
            style: sMedium.copyWith(color: primaryColor, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// 4 Spec Cards Minimalis
  Widget _buildSpecGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildSpecCard(
            title: 'Bebas Kimia',
            value: 'Pestisida 0%',
            icon: Icons.eco_outlined,
            color: primaryColor,
            bg: pastelMint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSpecCard(
            title: 'Masa Simpan',
            value: '4 - 6 Hari',
            icon: Icons.ac_unit_rounded,
            color: secondaryColor600,
            bg: pastelOrange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSpecCard(
            title: 'Kandungan',
            value: 'Vit A & Zat Besi',
            icon: Icons.bolt_rounded,
            color: const Color(0xFF7C3AED),
            bg: pastelPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: xsRegular.copyWith(
              color: const Color(0xFF94A3B8),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: sBold.copyWith(color: textNeutralPrimary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Tabs Keterangan Informasi
  Widget _buildInfoTabs() {
    final tabs = ['Manfaat', 'Tips Simpan', 'Ide Masakan'];

    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = _selectedInfoTab == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedInfoTab = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFD8F2E1) : Color(0x00D8F2E1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? textNeutralPrimary
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Isi Konten Tab
  Widget _buildInfoTabContent() {
    if (_selectedInfoTab == 0) {
      return Text(
        'Dipanen saat fajar untuk mengunci kelembapan alami dan kandungan gizi tertinggi. Kaya akan antioksidan, zat besi pencegah anemia, serta vitamin C untuk menjaga imunitas tubuh harian.',
        style: sRegular.copyWith(
          color: const Color(0xFF64748B),
          fontSize: 13,
          height: 1.55,
        ),
      );
    } else if (_selectedInfoTab == 1) {
      return Text(
        'Jangan dicuci sebelum disimpan di lemari es. Bungkus akar/batang dengan tisu kering lalu masukkan ke dalam kotak kedap udara untuk menjaga kerenyahannya hingga 5-7 hari.',
        style: sRegular.copyWith(
          color: const Color(0xFF64748B),
          fontSize: 13,
          height: 1.55,
        ),
      );
    } else {
      return Text(
        'Sangat lezat diolah menjadi Sayur Bening Temu Kunci, Tumis Bawang Putih Crispy, Omelet Sayur Sehat, atau bahan campuran *Green Smoothie Detox*.',
        style: sRegular.copyWith(
          color: const Color(0xFF64748B),
          fontSize: 13,
          height: 1.55,
        ),
      );
    }
  }

  /// 3. Sticky Bottom Action Bar (Quantity + Button)
  Widget _buildBottomActionBar(int unitPrice, String productName) {
    final int subtotal = unitPrice * _quantity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quantity Stepper (- 1 +)
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_rounded, size: 18),
                    color: _quantity > 1
                        ? textNeutralPrimary
                        : const Color(0xFFCBD5E1),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                  ),
                  Text(
                    '$_quantity',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 15,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    color: primaryColor,
                    onPressed: () {
                      setState(() => _quantity++);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Tombol Tambah ke Keranjang
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$_quantity x $productName (Rp $subtotal) masuk keranjang',
                          style: sMedium.copyWith(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+ Keranjang (Rp $subtotal)',
                        style: sSemiBold.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
