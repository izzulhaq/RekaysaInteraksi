import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rekomendasi_controller.dart';

class RekomendasiView extends GetView<RekomendasiController> {
  const RekomendasiView({Key? key}) : super(key: key);

  // Warna sesuai desain
  final Color primaryBlue = const Color(0xFF004AAD);
  final Color lightPurpleBg = const Color(0xFFEEEBF5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              
              // Text Deskripsi
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Seperti bertanya pada teman/\nwarga lokal",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Search Bar Dummy (Title)
              _buildSearchBarTitle(),
              
              const SizedBox(height: 20),

              // Form Container dengan Border Biru
              _buildFormContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      color: primaryBlue,
      child: Row(
        children: [
          // Logo Circle (Dummy Icon)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.restaurant_menu, color: primaryBlue, size: 24),
          ),
          const SizedBox(width: 15),
          // Text Title
          const Expanded(
            child: Text(
              "REKOMENDASI INSTAN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBarTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: lightPurpleBg,
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      child: Row(
        children: const [
          Icon(Icons.menu, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Beri Satu Rekomendasi Terbaik",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryBlue, width: 1.5), // Border biru tipis
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel("Lagi di daerah mana?"),
          const SizedBox(height: 8),
          _buildTextField(controller.locationC),
          
          const SizedBox(height: 20),
          
          _buildInputLabel("Budget?"),
          const SizedBox(height: 8),
          _buildTextField(controller.budgetC),
          
          const SizedBox(height: 10), // Spasi bawah tambahan
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildTextField(TextEditingController textCtrl) {
    return TextField(
      controller: textCtrl,
      decoration: InputDecoration(
        filled: true,
        fillColor: lightPurpleBg, // Background ungu muda
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // Hilangkan border default input
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }
}