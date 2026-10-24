import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vegetables_app/feature/detail/detail_screen.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_cubit.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_state.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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
                    'Favorit',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 42,
                  ), // Balance spacer agar judul tepat di tengah
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. FAVORITES LIST / EMPTY STATE
            Expanded(
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  final items = state.favorites;

                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: pastelRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite_border_rounded,
                                color: Color(0xFFEF4444),
                                size: 38,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Belum Ada Favorit',
                              style: sBold.copyWith(
                                color: textNeutralPrimary,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Simpan sayur segar pilihanmu dengan menekan ikon hati agar mudah dicari lagi.',
                              textAlign: TextAlign.center,
                              style: sRegular.copyWith(
                                color: const Color(0xFF94A3B8),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildCard(context, item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, VegetableModel item) {
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
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17),
                    ),
                    child: Container(
                      color: const Color(0xFFF8FAF8),
                      child: Image.network(
                        item.gambar,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 72,
                          height: 72,
                          color: const Color(0xFFF1F5F2),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: pastelMint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.kategori,
                        style: sSemiBold.copyWith(
                          color: primaryColor,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        context.read<FavoriteCubit>().toggleFavorite(item);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 16,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(item.harga)}',
                    style: sBold.copyWith(color: primaryColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
