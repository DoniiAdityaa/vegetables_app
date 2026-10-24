import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vegetables_app/feature/cart/cubit/cart_cubit.dart';
import 'package:vegetables_app/feature/cart/cubit/cart_state.dart';
import 'package:vegetables_app/feature/cart/model/cart_item_model.dart';
import 'package:vegetables_app/feature/detail/detail_screen.dart';
import 'package:vegetables_app/feature/main_navigation/main_navigation.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Keranjang Belanja',
          style: sBold.copyWith(color: textNeutralPrimary, fontSize: 17),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.items.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _showClearDialog(context),
                child: Text(
                  'Kosongkan',
                  style: sMedium.copyWith(color: const Color(0xFFEF4444)),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 200),
                physics: const BouncingScrollPhysics(),
                children: [
                  // List Item Keranjang
                  ...state.items.map((item) => _buildCartCard(context, item)),

                  const SizedBox(height: 16),

                  // Ringkasan Pembayaran
                  _buildSummaryCard(state),
                ],
              ),

              // Sticky Bottom Checkout Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 90, // Tepat di atas Floating NavBar MainNavigation
                child: _buildCheckoutBar(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF2EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket_outlined,
                color: primaryColor,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Keranjang Masih Kosong',
              style: sBold.copyWith(color: textNeutralPrimary, fontSize: 17),
            ),
            const SizedBox(height: 6),
            Text(
              'Yuk, temukan sayur segar pilihanmu dan tambahkan ke keranjang.',
              textAlign: TextAlign.center,
              style: sRegular.copyWith(
                color: const Color(0xFF94A3B8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                MainNavigation.switchToTab(context, 0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Mulai Belanja',
                style: sSemiBold.copyWith(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartCard(BuildContext context, CartItemModel item) {
    final veg = item.vegetable;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Foto Sayuran
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(vegetable: veg),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                veg.gambar,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72,
                  height: 72,
                  color: const Color(0xFFF1F5F2),
                  child: const Icon(Icons.eco_rounded, color: primaryColor),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Detail Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  veg.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sBold.copyWith(
                    color: textNeutralPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  veg.kategori,
                  style: xsRegular.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Rp ${NumberFormat('#,###', 'id_ID').format(veg.harga)}',
                  style: sBold.copyWith(color: primaryColor, fontSize: 13),
                ),
              ],
            ),
          ),

          // Stepper Kuantiti
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: const Icon(Icons.remove_rounded, size: 16),
                  color: textNeutralPrimary,
                  onPressed: () {
                    context.read<CartCubit>().updateQuantity(
                      veg.id,
                      item.quantity - 1,
                    );
                  },
                ),
                Text(
                  '${item.quantity}',
                  style: sBold.copyWith(
                    color: textNeutralPrimary,
                    fontSize: 13,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  color: primaryColor,
                  onPressed: () {
                    context.read<CartCubit>().updateQuantity(
                      veg.id,
                      item.quantity + 1,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Belanja',
            style: sBold.copyWith(color: textNeutralPrimary, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Produk (${state.totalItems} item)',
                style: sRegular.copyWith(
                  color: const Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
              Text(
                'Rp ${NumberFormat('#,###', 'id_ID').format(state.totalPrice)}',
                style: sMedium.copyWith(
                  color: textNeutralPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ongkos Kirim',
                style: sRegular.copyWith(
                  color: const Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
              Text(
                'GRATIS',
                style: sBold.copyWith(color: primaryColor, fontSize: 12),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Color(0xFFE2E8F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: sBold.copyWith(color: textNeutralPrimary, fontSize: 13),
              ),
              Text(
                'Rp ${NumberFormat('#,###', 'id_ID').format(state.totalPrice)}',
                style: sBold.copyWith(color: primaryColor, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartState state) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Tagihan',
                  style: xsRegular.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
                Text(
                  'Rp ${NumberFormat('#,###', 'id_ID').format(state.totalPrice)}',
                  style: sBold.copyWith(color: primaryColor, fontSize: 16),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _handleCheckout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Checkout',
              style: sBold.copyWith(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: pastelMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text('Pesanan Berhasil!', style: sBold.copyWith(fontSize: 16)),
          ],
        ),
        content: Text(
          'Terima kasih! Pesanan sayuran segar kamu sedang disiapkan oleh petani dan kurir kami.',
          style: sRegular.copyWith(
            color: const Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<CartCubit>().clearCart();
              MainNavigation.switchToTab(
                context,
                3,
              ); // Pindah ke riwayat pesanan
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Lihat Pesanan'),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Kosongkan Keranjang?',
          style: sBold.copyWith(fontSize: 16),
        ),
        content: Text(
          'Semua produk dalam keranjang belanja akan dihapus.',
          style: sRegular.copyWith(
            color: const Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Batal',
              style: sMedium.copyWith(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<CartCubit>().clearCart();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Kosongkan'),
          ),
        ],
      ),
    );
  }
}
