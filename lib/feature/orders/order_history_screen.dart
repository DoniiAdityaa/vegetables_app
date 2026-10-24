import 'package:flutter/material.dart';
import 'package:vegetables_app/feature/main_navigation/main_navigation.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = [
    'Semua',
    'Dalam Proses',
    'Selesai',
    'Dibatalkan',
  ];

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'VG-9204',
      'date': 'Hari ini, 08:30 WIB',
      'status': 'Dalam Proses',
      'statusLabel': 'Sedang Dikirim',
      'statusIcon': Icons.local_shipping_rounded,
      'statusColor': primaryColor,
      'statusBg': pastelMint,
      'mainProduct': 'Wortel Berastagi Segar',
      'extraProducts': '+ 2 sayuran lainnya',
      'imageUrl':
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?q=80&w=600&auto=format&fit=crop',
      'totalItems': 3,
      'totalPrice': 38500,
      'courierName': 'Pak Joko (Driver VegBox)',
      'eta': '~15-20 menit lagi',
      'step': 3, // 1: Dipetik, 2: Dikemas, 3: Diantar
    },
    {
      'id': 'VG-8910',
      'date': 'Kemarin, 09:15 WIB',
      'status': 'Selesai',
      'statusLabel': 'Selesai',
      'statusIcon': Icons.check_circle_rounded,
      'statusColor': primaryColor,
      'statusBg': pastelMint,
      'mainProduct': 'Bayam Hijau Organik',
      'extraProducts': '+ 1 sayuran lainnya',
      'imageUrl':
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?q=80&w=600&auto=format&fit=crop',
      'totalItems': 2,
      'totalPrice': 24000,
      'receivedBy': 'Diterima oleh Doni',
    },
    {
      'id': 'VG-8755',
      'date': '16 Okt 2026, 14:20 WIB',
      'status': 'Selesai',
      'statusLabel': 'Selesai',
      'statusIcon': Icons.check_circle_rounded,
      'statusColor': primaryColor,
      'statusBg': pastelMint,
      'mainProduct': 'Brokoli Hijau Super',
      'extraProducts': '+ 3 sayuran lainnya',
      'imageUrl':
          'https://images.unsplash.com/photo-1584270354949-c26b0d5b4a0c?q=80&w=600&auto=format&fit=crop',
      'totalItems': 4,
      'totalPrice': 54000,
      'receivedBy': 'Diterima oleh Doni',
    },
    {
      'id': 'VG-8412',
      'date': '10 Okt 2026, 11:00 WIB',
      'status': 'Dibatalkan',
      'statusLabel': 'Dibatalkan',
      'statusIcon': Icons.cancel_rounded,
      'statusColor': errorColor,
      'statusBg': pastelRed,
      'mainProduct': 'Alpukat Mentega Super',
      'extraProducts': '',
      'imageUrl':
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=600&auto=format&fit=crop',
      'totalItems': 1,
      'totalPrice': 35000,
      'cancelReason': 'Stok panen subuh habis dari petani',
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilterIndex == 0) return _orders;
    final selectedFilter = _filters[_selectedFilterIndex];
    return _orders.where((o) => o['status'] == selectedFilter).toList();
  }

  void _showTrackingModal(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grabber Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pelacakan Pengiriman',
                        style: sBold.copyWith(
                          color: textNeutralPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'No. Pesanan: #${order['id']}',
                        style: xsRegular.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: pastelMint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order['eta'] as String,
                      style: sSemiBold.copyWith(
                        color: primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Courier Info Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAF8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delivery_dining_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['courierName'] as String,
                            style: sBold.copyWith(
                              color: textNeutralPrimary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kurir resmi VegBox Express',
                            style: xsRegular.copyWith(
                              color: const Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.phone_in_talk_rounded,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Menghubungi ${order['courierName']}...',
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
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tracking Timeline Steps
              _buildTimelineStep(
                title: 'Pesanan Dipetik Langsung',
                subtitle: 'Sayuran segar selesai dipanen dari kebun mitra',
                time: '06:15 WIB',
                isDone: true,
              ),
              _buildTimelineStep(
                title: 'Quality Check & Pengemasan',
                subtitle: 'Dikemas higienis dengan ice pack di Hub VegBox',
                time: '07:30 WIB',
                isDone: true,
              ),
              _buildTimelineStep(
                title: 'Kurir Sedang Menuju Lokasimu',
                subtitle: 'Dalam perjalanan membawa pesanan segar',
                time: '08:30 WIB',
                isDone: true,
                isCurrent: true,
              ),
              _buildTimelineStep(
                title: 'Pesanan Sampai di Rumahmu',
                subtitle: 'Estimasi tiba dalam ~15 menit',
                time: '08:50 WIB',
                isDone: false,
                isLast: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required String time,
    required bool isDone,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDone ? primaryColor : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: const Color(0xFFD4ECD9), width: 4)
                    : null,
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? primaryColor : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: sBold.copyWith(
                      color: isDone
                          ? textNeutralPrimary
                          : const Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    time,
                    style: xsRegular.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: xsRegular.copyWith(
                  color: const Color(0xFF64748B),
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredOrders;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER (Back button auto-adapt + Title)
            _buildHeader(),

            const SizedBox(height: 12),

            // 2. STATUS FILTER PILLS
            _buildFilterPills(),

            const SizedBox(height: 16),

            // 3. ORDERS LIST / EMPTY STATE
            Expanded(
              child: list.isEmpty ? _buildEmptyState() : _buildOrderList(list),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Header
  Widget _buildHeader() {
    final canPop = Navigator.canPop(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canPop) ...[
            const AppBackButton(),
            Text(
              'Pesanan Saya',
              style: sBold.copyWith(color: textNeutralPrimary, fontSize: 18),
            ),
            const SizedBox(width: 42), // Balance spacer
          ] else ...[
            Text(
              'Pesanan Saya',
              style: sBold.copyWith(color: textNeutralPrimary, fontSize: 22),
            ),
          ],
        ],
      ),
    );
  }

  /// 2. Status Filter Pills (Konsisten dengan Kategori Home & Notifikasi)
  Widget _buildFilterPills() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final title = _filters[index];
          final isSelected = _selectedFilterIndex == index;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() => _selectedFilterIndex = index);
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
                title,
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
    );
  }

  /// 3. Orders List
  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 110.0),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        final bool isInProgress = order['status'] == 'Dalam Proses';
        final bool isCancelled = order['status'] == 'Dibatalkan';

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card: Date, Invoice & Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${order['id']}',
                          style: sBold.copyWith(
                            color: textNeutralPrimary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order['date'] as String,
                          style: xsRegular.copyWith(
                            color: const Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: order['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          order['statusIcon'] as IconData,
                          size: 14,
                          color: order['statusColor'] as Color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order['statusLabel'] as String,
                          style: sSemiBold.copyWith(
                            color: order['statusColor'] as Color,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: Color(0xFFF1F5F9), thickness: 1, height: 1),
              const SizedBox(height: 12),

              // Product Info Row
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      order['imageUrl'] as String,
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 58,
                        height: 58,
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['mainProduct'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: sBold.copyWith(
                            color: textNeutralPrimary,
                            fontSize: 13.5,
                          ),
                        ),
                        if ((order['extraProducts'] as String).isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            order['extraProducts'] as String,
                            style: xsRegular.copyWith(
                              color: const Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          'Total: Rp ${order['totalPrice']}',
                          style: sBold.copyWith(
                            color: primaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Progress Bar Khusus Sedang Dikirim
              if (isInProgress) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: pastelMint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Estimasi tiba: ${order['eta']}',
                          style: sMedium.copyWith(
                            color: primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Keterangan Dibatalkan
              if (isCancelled && order['cancelReason'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Alasan: ${order['cancelReason']}',
                    style: xsRegular.copyWith(
                      color: const Color(0xFFE11D48),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Bottom Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isInProgress) ...[
                    ElevatedButton.icon(
                      onPressed: () => _showTrackingModal(order),
                      icon: const Icon(Icons.navigation_rounded, size: 16),
                      label: Text(
                        'Lacak Kurir',
                        style: sSemiBold.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ] else if (!isCancelled) ...[
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Form ulasan untuk pesanan #${order['id']} segera dibuka!',
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
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textNeutralPrimary,
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Beri Ulasan',
                        style: sMedium.copyWith(
                          fontSize: 12,
                          color: textNeutralPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${order['mainProduct']} dimasukkan ke keranjang belanja!',
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Beli Lagi',
                        style: sSemiBold.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] else ...[
                    OutlinedButton(
                      onPressed: () {
                        MainNavigation.switchToTab(context, 0);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Belanja Sayur Lain',
                        style: sSemiBold.copyWith(
                          fontSize: 12,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 4. Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F2),
              borderRadius: BorderRadius.circular(38),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFF94A3B8),
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Pesanan',
            style: sBold.copyWith(color: textNeutralPrimary, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Pesanan sayuran segar harianmu akan tercatat di sini.',
              textAlign: TextAlign.center,
              style: sRegular.copyWith(
                color: const Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              MainNavigation.switchToTab(context, 0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Mulai Belanja',
              style: sSemiBold.copyWith(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
