import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentifikasi_controller.dart';

class RegisterView extends GetView<AuthentifikasiController> {
  const RegisterView({Key? key}) : super(key: key);

  final Color primaryBlue = const Color(0xFF004AAD);

  @override
  Widget build(BuildContext context) {
    // Trik agar controller ditemukan jika navigasi langsung (tanpa binding route khusus)
    // Jika error "controller not found", gunakan Get.find<AuthentifikasiController>()
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER (Versi pendek tersambung AppBar)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.elliptical(250, 50),
                      bottomRight: Radius.elliptical(250, 50),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.restaurant_menu, size: 30, color: primaryBlue),
                         Text("LUNCHIFY", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: primaryBlue))
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // FORM REGISTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  _buildInputGroup("Full Name", controller.fullNameC),
                  _buildInputGroup("Email", controller.emailC),
                  _buildInputGroup("Class", controller.classC),
                  _buildInputGroup("Section", controller.sectionC),
                  _buildInputGroup("Roll No.", controller.rollNoC),
                  
                  const SizedBox(height: 20),

                  // Button Add to Contact
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logika Register di sini
                        print("Data: ${controller.fullNameC.text}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Add to contact",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Input Box Biru
  Widget _buildInputGroup(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter Something...",
            hintStyle: TextStyle(color: Colors.indigo[100]),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Color(0xFF5C93D6)), // Biru muda sesuai gambar
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: primaryBlue, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}