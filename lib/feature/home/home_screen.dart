import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vegetables_app/config/constant.dart';
import 'package:vegetables_app/feature/cart/cubit/cart_cubit.dart';
import 'package:vegetables_app/feature/detail/detail_screen.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_cubit.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_state.dart';
import 'package:vegetables_app/feature/favorite/favorite_screen.dart';
import 'package:vegetables_app/feature/home/cubit/category_cubit.dart';
import 'package:vegetables_app/feature/home/cubit/vegetable_cubit.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  String _selectedCategoryName = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchVegetables({String? search, String? category}) {
    final cat = category ?? _selectedCategoryName;
    final query = (search ?? _searchController.text).trim();

    context.read<VegetableCubit>().getVegetables(
      kategori: (cat == 'Semua') ? null : cat,
      cari: query.isNotEmpty ? query : null,
    );
  }

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
              child: RefreshIndicator(
                color: primaryColor,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  context.read<CategoryCubit>().getCategories();
                  _fetchVegetables();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // 2A. SEARCH BAR CAPSULE
                      _buildSearchBar(),

                      const SizedBox(height: 18),

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
                  ],
                ),
              ],
            ),
          ),

          // Tombol Favorit
          BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, favState) {
              return _buildCircleIconButton(
                icon: Icons.favorite_border_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteScreen(),
                    ),
                  );
                },
                badgeCount: favState.favorites.isNotEmpty
                    ? favState.favorites.length
                    : null,
              );
            },
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
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                style: sMedium.copyWith(
                  color: textNeutralPrimary,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari bayam, tomat, wortel...',
                  hintStyle: sRegular.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  filled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (val) => _fetchVegetables(search: val),
                onChanged: (val) {
                  if (val.isEmpty) {
                    _fetchVegetables(search: '');
                  }
                  setState(() {});
                },
              ),
            ),
            // if (_searchController.text.isNotEmpty)
            //   GestureDetector(
            //     behavior: HitTestBehavior.opaque,
            //     onTap: () {
            //       _searchController.clear();
            //       setState(() {});
            //       _fetchVegetables(search: '');
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 6),
            //       child: Icon(
            //         Icons.close_rounded,
            //         color: Color(0xFF94A3B8),
            //         size: 18,
            //       ),
            //     ),
            //   ),
            // Container(
            //   width: 30,
            //   height: 30,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Material(
            //     color: Colors.transparent,
            //     child: InkWell(
            //       borderRadius: BorderRadius.circular(15),
            //       onTap: () => _fetchVegetables(),
            //       child: const Icon(
            //         Icons.tune_rounded,
            //         color: textNeutralPrimary,
            //         size: 16,
            //       ),
            //     ),
            //   ),
            // ),
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
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 38,
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              List<String> categories = vegetableCategories;
              if (state is CategoryLoaded) {
                categories = state.categories;
              } else if (state is CategoryError) {
                categories = state.fallbackCategories;
              }

              if (_selectedCategoryIndex >= categories.length) {
                _selectedCategoryIndex = 0;
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final catName = categories[index];
                  final isSelected = _selectedCategoryIndex == index;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                        _selectedCategoryName = catName;
                      });
                      _fetchVegetables(category: catName);
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
            ],
          ),
        ],
      ),
    );
  }

  /// 2E. Grid Produk Sayur 2 Kolom dengan BLoC
  Widget _buildProductGrid() {
    return BlocBuilder<VegetableCubit, VegetableState>(
      builder: (context, state) {
        if (state is VegetableLoading) {
          return _buildShimmerLoading();
        } else if (state is VegetableError) {
          return _buildErrorState(state.message);
        } else if (state is VegetableLoaded) {
          final items = state.vegetables;
          if (items.isEmpty) {
            return _buildEmptyState();
          }

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

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F2),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 16,
                            width: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2E8F0),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: pastelMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Sayuran tidak ditemukan',
              style: sBold.copyWith(color: textNeutralPrimary, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'Coba cari dengan kata kunci lain atau pilih kategori berbeda.',
              textAlign: TextAlign.center,
              style: xsRegular.copyWith(color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: pastelRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: Color(0xFFDC2626),
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Gagal Memuat Sayuran',
              style: sBold.copyWith(color: textNeutralPrimary, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: xsRegular.copyWith(color: const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _fetchVegetables(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(VegetableModel item) {
    final imageUrl = item.gambar;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(vegetable: item),
          ),
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
                fit: StackFit.expand,
                children: [
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
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: const Color(0xFFF1F5F2),
                                        child: const Center(
                                          child: Icon(
                                            Icons.eco_rounded,
                                            color: primaryColor,
                                            size: 36,
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
                        top: Radius.circular(17),
                      ),
                      child: Container(
                        color: const Color(0xFFF8FAF8),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: const Color(0xFFF1F5F2),
                                child: const Center(
                                  child: Icon(
                                    Icons.eco_rounded,
                                    color: primaryColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),

                  // Icon Favorite
                  Positioned(
                    top: 6,
                    right: 6,
                    child: BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, favState) {
                        final isFav = context.read<FavoriteCubit>().isFavorite(
                          item.id,
                        );

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            context.read<FavoriteCubit>().toggleFavorite(item);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isFav
                                  ? const Color(0xFFFEE2E2)
                                  : Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 16,
                              color: isFav
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        );
                      },
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
                    item.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.deskripsi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(item.harga)}',
                        style: sBold.copyWith(
                          color: primaryColor,
                          fontSize: 14,
                        ),
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
                              context.read<CartCubit>().addItem(
                                item,
                                quantity: 1,
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item.nama} ditambahkan ke keranjang',
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
