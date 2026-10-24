import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vegetables_app/config/service_locator.dart';
import 'package:vegetables_app/feature/cart/cubit/cart_cubit.dart';
import 'package:vegetables_app/feature/detail/cubit/vegetable_detail_cubit.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_cubit.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_state.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_detail_model.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class DetailScreen extends StatelessWidget {
  final VegetableModel vegetable;

  const DetailScreen({super.key, required this.vegetable});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VegetableDetailCubit>(
      create: (context) =>
          serviceLocator.get<VegetableDetailCubit>()..getDetail(vegetable.id),
      child: _DetailView(vegetable: vegetable),
    );
  }
}

class _DetailView extends StatefulWidget {
  final VegetableModel vegetable;

  const _DetailView({required this.vegetable});

  @override
  State<_DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  int _quantity = 1;
  int _selectedInfoTab = 0; // 0: Manfaat, 1: Tips Simpan, 2: Deskripsi

  @override
  Widget build(BuildContext context) {
    final item = widget.vegetable;
    final int price = item.harga;
    final String name = item.nama;
    final String imageUrl = item.gambar;
    final String tag = item.kategori;

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

                      // Status Panen & Asal Petani (Dinamis dari API)
                      BlocBuilder<VegetableDetailCubit, VegetableDetailState>(
                        builder: (context, state) {
                          String asal = 'Petani Lokal';
                          if (state is VegetableDetailLoaded &&
                              state.detail.asal != null) {
                            asal = state.detail.asal!;
                          }
                          return _buildFarmOriginBadge(asal);
                        },
                      ),

                      const SizedBox(height: 12),

                      // Nama Produk
                      Column(
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
                            item.kategori,
                            style: sMedium.copyWith(
                              color: const Color(0xFF94A3B8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Rating Statis
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
                              '4.9',
                              style: sBold.copyWith(
                                color: const Color(0xFFB45309),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Harga
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(price)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 22),
                      const Divider(color: Color(0xFFF1F5F9), thickness: 1.2),
                      const SizedBox(height: 16),

                      // 4 QUICK SPEC CARDS (Nutrisi dari API)
                      BlocBuilder<VegetableDetailCubit, VegetableDetailState>(
                        builder: (context, state) {
                          NutrisiModel? nutrisi;
                          if (state is VegetableDetailLoaded) {
                            nutrisi = state.detail.nutrisi;
                          }
                          return _buildSpecGrid(nutrisi);
                        },
                      ),

                      const SizedBox(height: 24),

                      // TAB INFORMASI (Manfaat Nutrisi / Tips Simpan / Olahan)
                      _buildInfoTabs(),

                      const SizedBox(height: 14),

                      // ISI TAB KONTEN (Dinamis dari API)
                      BlocBuilder<VegetableDetailCubit, VegetableDetailState>(
                        builder: (context, state) {
                          if (state is VegetableDetailLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          VegetableDetailModel? detail;
                          if (state is VegetableDetailLoaded) {
                            detail = state.detail;
                          }
                          return _buildInfoTabContent(detail);
                        },
                      ),

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
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: const Color(0xFFF1F5F2),
                                child: const Center(
                                  child: Icon(
                                    Icons.eco_rounded,
                                    size: 50,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                        ),
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

  /// Floating Top Bar (Back & Favorite)
  Widget _buildFloatingTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Kembali Reusable
            const AppBackButton(isFrosted: true),

            // Tombol Favorit (Love Icon)
            BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, favState) {
                final isFav = context.read<FavoriteCubit>().isFavorite(
                  widget.vegetable.id,
                );

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
                      onTap: () {
                        context.read<FavoriteCubit>().toggleFavorite(
                          widget.vegetable,
                        );
                      },
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFav
                            ? const Color(0xFFEF4444)
                            : textNeutralPrimary,
                        size: 20,
                      ),
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

  /// Badge Asal Petani & Kesegaran
  Widget _buildFarmOriginBadge(String asal) {
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
            'Panen Segar • $asal',
            style: sMedium.copyWith(color: primaryColor, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// 4 Spec Cards Nutrisi dari API
  Widget _buildSpecGrid(NutrisiModel? nutrisi) {
    return Row(
      children: [
        Expanded(
          child: _buildSpecCard(
            title: 'Kalori',
            value:
                nutrisi?.kalori?.replaceAll('/ 100g', '').trim() ?? '23 kcal',
            icon: Icons.local_fire_department_outlined,
            color: const Color(0xFFEA580C),
            bg: pastelOrange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSpecCard(
            title: 'Protein',
            value: nutrisi?.protein ?? '2.9g',
            icon: Icons.fitness_center_rounded,
            color: primaryColor,
            bg: pastelMint,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSpecCard(
            title: 'Serat',
            value: nutrisi?.serat ?? '2.2g',
            icon: Icons.grass_rounded,
            color: const Color(0xFF0284C7),
            bg: const Color(0xFFE0F2FE),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSpecCard(
            title: 'Karbohidrat',
            value: nutrisi?.karbohidrat ?? '3.6g',
            icon: Icons.grain_rounded,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sBold.copyWith(color: textNeutralPrimary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Tabs Keterangan Informasi
  Widget _buildInfoTabs() {
    final tabs = ['Manfaat', 'Tips Simpan', 'Deskripsi'];

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
                color: isSelected
                    ? const Color(0xFFD8F2E1)
                    : const Color(0x00D8F2E1),
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

  /// Isi Konten Tab Dinamis dari API
  Widget _buildInfoTabContent(VegetableDetailModel? detail) {
    if (_selectedInfoTab == 0) {
      final manfaatList = detail?.manfaat;
      if (manfaatList != null && manfaatList.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: manfaatList.map((m) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: pastelMint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: primaryColor,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      m,
                      style: sRegular.copyWith(
                        color: const Color(0xFF64748B),
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }
      return Text(
        detail?.deskripsi ?? widget.vegetable.deskripsi,
        style: sRegular.copyWith(
          color: const Color(0xFF64748B),
          fontSize: 13,
          height: 1.55,
        ),
      );
    } else if (_selectedInfoTab == 1) {
      final tips = detail?.tipsPenyimpanan;
      return Text(
        tips ??
            'Simpan dalam wadah kedap udara beralas tisu di lemari es untuk menjaga kerenyahannya.',
        style: sRegular.copyWith(
          color: const Color(0xFF64748B),
          fontSize: 13,
          height: 1.55,
        ),
      );
    } else {
      return Text(
        detail?.deskripsi ?? widget.vegetable.deskripsi,
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
                    context.read<CartCubit>().addItem(
                      widget.vegetable,
                      quantity: _quantity,
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

                    Navigator.pop(context);
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
