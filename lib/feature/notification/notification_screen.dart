import 'package:flutter/material.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = [
    'Semua',
    'Pesanan',
    'Promo & Panen',
    'Info Sistem',
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Pesanan Sedang Dikirim',
      'message':
          'Paket sayur organik #VG-8921 sedang dalam perjalanan ke alamatmu bersama kurir.',
      'time': '10 menit lalu',
      'group': 'Hari Ini',
      'category': 'Pesanan',
      'icon': Icons.local_shipping_outlined,
      'iconColor': primaryColor,
      'bgColor': pastelMint,
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'Panen Subuh Tiba! Diskon 20%',
      'message':
          'Sayuran bayam, brokoli, dan wortel baru saja dipanen subuh ini langsung dari petani Ambarawa.',
      'time': '06.30 WIB',
      'group': 'Hari Ini',
      'category': 'Promo & Panen',
      'icon': Icons.eco_outlined,
      'iconColor': primaryColor,
      'bgColor': pastelMint,
      'isRead': false,
    },
    {
      'id': '3',
      'title': 'Voucher Gratis Ongkir Aktif',
      'message':
          'Klaim voucher potongan ongkos kirim hingga Rp 15.000 untuk belanja kebutuhan sayur harianmu.',
      'time': 'Kemarin, 14.15',
      'group': 'Kemarin',
      'category': 'Promo & Panen',
      'icon': Icons.discount_outlined,
      'iconColor': secondaryColor600,
      'bgColor': pastelOrange,
      'isRead': true,
    },
    {
      'id': '4',
      'title': 'Pesanan Selesai #VG-8910',
      'message':
          'Terima kasih telah berbelanja di VegBox! Jangan lupa beri ulasan kesegaran sayuranmu.',
      'time': 'Kemarin, 09.00',
      'group': 'Kemarin',
      'category': 'Pesanan',
      'icon': Icons.check_circle_outline_rounded,
      'iconColor': primaryColor,
      'bgColor': pastelMint,
      'isRead': true,
    },
    {
      'id': '5',
      'title': 'Akun Berhasil Diverifikasi',
      'message':
          'Nomor HP dan email kamu telah aktif untuk keamanan transaksi belanja yang lebih baik.',
      'time': '18 Okt 2026',
      'group': 'Terdahulu',
      'category': 'Info Sistem',
      'icon': Icons.security_rounded,
      'iconColor': Color(0xFF2563EB),
      'bgColor': pastelBlue,
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilterIndex == 0) return _notifications;
    final selectedFilter = _filters[_selectedFilterIndex];
    return _notifications
        .where((n) => n['category'] == selectedFilter)
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Semua notifikasi ditandai telah dibaca',
          style: sMedium.copyWith(color: Colors.white),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredNotifications;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER (Back Button + Title + Tandai Dibaca)
            _buildHeader(),

            const SizedBox(height: 12),

            // 2. CATEGORY PILL FILTER
            _buildFilterPills(),

            const SizedBox(height: 16),

            // 3. NOTIFICATION LIST / EMPTY STATE
            Expanded(
              child: list.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(list),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Header (Menyesuaikan otomatis jika dibuka via push atau sebagai Tab Bottom Bar)
  Widget _buildHeader() {
    final canPop = Navigator.canPop(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Jika dibuka via Navigator.push, tampilkan AppBackButton
          if (canPop) ...[
            const AppBackButton(),
            Text(
              'Notifikasi',
              style: sBold.copyWith(color: textNeutralPrimary, fontSize: 18),
            ),
          ] else ...[
            // Jika berada di Bottom Bar tab, judul tampil rapi di kiri
            Text(
              'Notifikasi',
              style: sBold.copyWith(color: textNeutralPrimary, fontSize: 22),
            ),
          ],

          // Tombol Lingkaran Tandai Dibaca (Circle Button simetris)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.done_all_rounded,
                size: 20,
                color: primaryColor,
              ),
              onPressed: _markAllAsRead,
              tooltip: 'Tandai semua dibaca',
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Category Filter Pills (Konsisten dengan Kategori Home)
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

  /// 3. Notification List grouped with dividers
  Widget _buildNotificationList(List<Map<String, dynamic>> items) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 110.0),
      itemCount: items.length,
      separatorBuilder: (_, _) =>
          const Divider(color: Color(0xFFF1F5F9), thickness: 1, height: 24),
      itemBuilder: (context, index) {
        final item = items[index];
        final bool isRead = (item['isRead'] as bool?) ?? true;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!isRead) {
              setState(() {
                item['isRead'] = true;
              });
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon berlatar pastel
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['iconColor'] as Color,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Konten Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: sBold.copyWith(
                              color: textNeutralPrimary,
                              fontSize: 13.5,
                              height: 1.3,
                            ),
                          ),
                        ),
                        // Unread Dot
                        if (!isRead)
                          Container(
                            margin: const EdgeInsets.only(top: 4, left: 8),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['message'] as String,
                      style: sRegular.copyWith(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['time'] as String,
                      style: xsRegular.copyWith(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 4. Clean Empty State
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
              Icons.notifications_off_outlined,
              color: Color(0xFF94A3B8),
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Notifikasi',
            style: sBold.copyWith(color: textNeutralPrimary, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Update pengiriman pesanan dan panen sayur segar harian akan muncul di sini.',
              textAlign: TextAlign.center,
              style: sRegular.copyWith(
                color: const Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
