import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentifikasi_controller.dart';
import 'register_view.dart';

class AuthentifikasiView extends GetView<AuthentifikasiController> {
  const AuthentifikasiView({Key? key}) : super(key: key);

  // Tema Warna Deep Navy agar konsisten
  final Color primaryColor = const Color(0xFF1A237E);
  final Color accentColor = const Color(0xFF5C6BC0);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER (Overlapping style)
            _buildHeader(),
            
            const SizedBox(height: 60),

            // FORM LOGIN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- EMAIL FIELD ---
                    _buildLabel("Email Address"),
                    TextField(
                      controller: controller.loginEmailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        suffixIcon: Icon(Icons.email_outlined, color: primaryColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),

                    // --- PASSWORD FIELD ---
                    _buildLabel("Password"),
                    Obx(() => TextField(
                      controller: controller.loginPassC,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: "••••••••••••",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value 
                              ? Icons.visibility_off_outlined 
                              : Icons.visibility_outlined,
                            color: primaryColor,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                    )),

                    const SizedBox(height: 40),

                    // --- LOGIN BUTTON ---
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value 
                            ? null 
                            : () => controller.loginUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          shadowColor: primaryColor.withOpacity(0.4),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    )),
                    
                    const SizedBox(height: 25),
                    
                    // --- FOOTER LINK ---
                    Center(
                      child: Column(
                        children: [
                          // TOMBOL FORGOT PASSWORD (SUDAH DIPERBAIKI)
                          // TextButton(
                          //   onPressed: () => _showForgotPasswordModal(context),
                          //   child: Text(
                          //     "Forgot Password?", 
                          //     style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          //   ),
                          // ),
                          
                          const SizedBox(height: 5),
                          
                          GestureDetector(
                            onTap: () => Get.to(() => const RegisterView()),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: "Register",
                                    style: TextStyle(
                                      color: primaryColor, 
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- FUNGSI MODAL FORGOT PASSWORD ---
  void _showForgotPasswordModal(BuildContext context) {
    // Controller lokal untuk input email di modal
    // Kita isi default-nya dengan apa yang sudah diketik di login (jika ada)
    TextEditingController resetEmailC = TextEditingController(text: controller.loginEmailC.text);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar tinggi menyesuaikan konten
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gagang kecil
            Center(
              child: Container(
                width: 40, height: 4, 
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))
              ),
            ),
            const SizedBox(height: 20),
            
            Text("Reset Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 10),
            Text("Masukkan email terdaftar Anda. Kami akan mengirimkan link untuk mereset password.", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            
            const SizedBox(height: 20),
            
            // Input Email
            TextField(
              controller: resetEmailC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: primaryColor),
                hintText: "Email Address",
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.resetPassword(resetEmailC.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("KIRIM LINK RESET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20), // Spasi bawah keyboard
          ],
        ),
      ),
      isScrollControlled: true, // Agar modal naik jika keyboard muncul
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        color: primaryColor.withOpacity(0.7),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, const Color(0xFF3949AB)],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Lunchify",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Login to continue using Lunchify",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        
        // --- LOGO (Sesuai kode terakhir Anda) ---
        Positioned(
          bottom: -45,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            padding: const EdgeInsets.all(15), 
            child: Image.asset(
              "assets/LogoAJ.png", 
              fit: BoxFit.contain, 
            ),
          ),
        ),
      ],
    );
  }
}