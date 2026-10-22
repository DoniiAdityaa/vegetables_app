import 'package:flutter/material.dart';
import 'package:vegetables_app/ui/app_back_button.dart';
import 'package:vegetables_app/ui/color.dart';
import 'package:vegetables_app/ui/typography.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialAddress;

  const EditProfileScreen({
    super.key,
    this.initialName = 'Doni Aditya Pratama',
    this.initialEmail = 'doniaditya004@gmail.com',
    this.initialPhone = '+62 812-3456-7890',
    this.initialAddress =
        'Jl. Nakula I No. 5-11, Pendrikan Kidul, Semarang Tengah',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profil berhasil diperbarui!',
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

      Navigator.pop(context, {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      });
    }
  }

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
                    'Edit Profil',
                    style: sBold.copyWith(
                      color: textNeutralPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 42), // Balance spacer
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. SCROLLABLE FORM
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // Avatar with edit badge
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: pastelMint,
                                border: Border.all(
                                  color: primaryColor,
                                  width: 2.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'DA',
                                  style: lBold.copyWith(
                                    color: primaryColor,
                                    fontSize: 32,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Ketuk ikon kamera untuk ganti foto',
                        style: xsRegular.copyWith(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Input Nama Lengkap
                      _buildInputField(
                        label: 'Nama Lengkap',
                        controller: _nameController,
                        icon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Input Email
                      _buildInputField(
                        label: 'Alamat Email',
                        controller: _emailController,
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!val.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Input Nomor Telepon
                      _buildInputField(
                        label: 'Nomor WhatsApp / HP',
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nomor telepon tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Input Alamat
                      _buildInputField(
                        label: 'Alamat Pengiriman Utama',
                        controller: _addressController,
                        icon: Icons.location_on_outlined,
                        maxLines: 2,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 36),

                      // Tombol Simpan Perubahan
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Simpan Perubahan',
                            style: sSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: sSemiBold.copyWith(color: textNeutralPrimary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: sRegular.copyWith(color: textNeutralPrimary, fontSize: 13.5),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAF8),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: errorColor),
            ),
          ),
        ),
      ],
    );
  }
}
