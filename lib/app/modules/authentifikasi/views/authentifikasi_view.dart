import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentifikasi_controller.dart';
import 'register_view.dart';

class AuthentifikasiView extends GetView<AuthentifikasiController> {
  const AuthentifikasiView({Key? key}) : super(key: key);

  // Tema Warna Deep Navy agar konsisten dengan RegisterView
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

            // FORM LOGIN (Dibungkus Card agar modern)
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
                    // --- EMAIL FIELD (Diupdate dari Username) ---
                    _buildLabel("Email Address"),
                    TextField(
                      controller: controller.loginEmailC, // Pakai controller Email
                      keyboardType: TextInputType.emailAddress, // Keyboard khusus email
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        suffixIcon: Icon(Icons.email_outlined, color: primaryColor), // Icon Email
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
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?", 
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ),
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
        // ... (Bagian Background Biru Tetap Sama) ...
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
        
        // --- BAGIAN LOGO YANG DIGANTI ---
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
            // Padding agar gambar tidak terlalu mepet pinggir lingkaran
            padding: const EdgeInsets.all(15), 
            
            // GANTI Column/Icon DENGAN INI:
            child: Image.asset(
              "assets/LogoAJ.png", // Sesuaikan nama file Anda
              fit: BoxFit.contain, // Agar gambar pas di tengah
            ),
          ),
        ),
      ],
    );
  }
}