import 'package:flutter/material.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'q': 'Bagaimana cara memastikan sayuran tetap segar saat tiba?',
      'a':
          'Semua sayuran kami dipanen subuh hari langsung dari petani mitra di Bandungan dan Ambarawa. Selama pengantaran, sayur dikemas higienis dalam box berpendingin dengan ice pack khusus.',
    },
    {
      'q': 'Berapa lama estimasi pengiriman pesanan?',
      'a':
          'Untuk pengiriman reguler hari yang sama (Same Day), pesanan diantar dalam waktu 15 - 45 menit tergantung jarak dari Hub VegBox terdekat ke lokasimu.',
    },
    {
      'q': 'Bagaimana jika sayuran yang diterima layu atau rusak?',
      'a':
          'VegBox memberikan Garansi Kesegaran 100%. Cukup kirimkan foto sayuran yang kurang segar lewat menu Pesanan Saya, dan kami akan langsung mengganti produk baru atau mengembalikan dana secara instan.',
    },
    {
      'q': 'Apakah sayuran berlabel organik benar-benar bebas kimia?',
      'a':
          'Betul. Sayuran bertanda 100% Organik dibudidayakan secara alami dengan pupuk kompos nabati tanpa pestisida sintetis dan telah melalui uji residu ketat.',
    },
    {
      'q': 'Metode pembayaran apa saja yang tersedia?',
      'a':
          'Kami menerima QRIS (GoPay, OVO, DANA, ShopeePay), Transfer Virtual Account (BCA, Mandiri, BRI, BNI), dan pembayaran tunai saat barang sampai (COD).',
    },
    {
      'q': 'Kapan waktu terbaik untuk melakukan pemesanan sayur?',
      'a':
          'Kami menyarankan memesan antara pukul 06.00 - 10.00 WIB untuk mendapatkan varian sayur daun dan rempah yang baru saja selesai dipanen dari kebun.',
    },
  ];

  String _searchQuery = '';

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.trim().isEmpty) return _faqs;
    final query = _searchQuery.toLowerCase();
    return _faqs.where((f) {
      return (f['q']?.toLowerCase().contains(query) ?? false) ||
          (f['a']?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filteredFaqs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER (Back Button + Title)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppBackButton(),
                  Text(
                    'Pusat Bantuan & FAQ',
                    style:
                        sBold.copyWith(color: textNeutralPrimary, fontSize: 18),
                  ),
                  const SizedBox(width: 42), // Balance spacer
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. SEARCH FAQ INPUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAF8),
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: sRegular.copyWith(
                          color: textNeutralPrimary,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari pertanyaan atau bantuan...',
                          hintStyle: sRegular.copyWith(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _searchQuery = ''),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // 3. FAQ ACCORDION LIST
            Expanded(
              child: faqs.isEmpty
                  ? Center(
                      child: Text(
                        'Pertanyaan tidak ditemukan',
                        style:
                            sRegular.copyWith(color: const Color(0xFF94A3B8)),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 32.0),
                      itemCount: faqs.length + 1, // +1 for CS card
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == faqs.length) {
                          // CS Banner at the bottom
                          return _buildCsBanner();
                        }

                        final item = faqs[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                16,
                              ),
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: pastelOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.help_outline_rounded,
                                  color: secondaryColor600,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                item['q'] ?? '',
                                style: sBold.copyWith(
                                  color: textNeutralPrimary,
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                              children: [
                                Text(
                                  item['a'] ?? '',
                                  style: sRegular.copyWith(
                                    color: const Color(0xFF64748B),
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCsBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pastelMint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4ECD9)),
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
              Icons.headset_mic_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masih butuh bantuan?',
                  style: sBold.copyWith(
                    color: textNeutralPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tim customer care VegBox siap membantu 24/7.',
                  style: xsRegular.copyWith(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Menghubungkan ke WhatsApp Customer Care VegBox...',
                    style: sMedium.copyWith(color: Colors.white),
                  ),
                  backgroundColor: primaryColor,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Chat CS',
              style: sSemiBold.copyWith(color: Colors.white, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }
}
