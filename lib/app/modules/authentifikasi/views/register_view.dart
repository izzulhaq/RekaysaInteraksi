import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentifikasi_controller.dart';

class RegisterView extends GetView<AuthentifikasiController> {
  const RegisterView({Key? key}) : super(key: key);

  final Color primaryColor = const Color(0xFF1A237E);
  final Color accentColor = const Color(0xFF5C6BC0);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Create Account", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- TOP SECTION: Header Melengkung ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, const Color(0xFF3949AB)],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                // LINGKARAN LOGO
                Positioned(
                  top: 70,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(Icons.person_add_rounded, size: 40, color: primaryColor),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70),

            // --- FORM SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  children: [
                    // 1. Full Name
                    _buildInputGroup(
                      label: "Full Name", 
                      controller: controller.fullNameC, 
                      icon: Icons.person_outline
                    ),

                    // 2. Email
                    _buildInputGroup(
                      label: "Email", 
                      controller: controller.registerEmailC, 
                      icon: Icons.email_outlined,
                      inputType: TextInputType.emailAddress
                    ),
                    
                    // 3. Password (Dengan Toggle Mata)
                    Obx(() => _buildInputGroup(
                      label: "Password", 
                      controller: controller.registerPassC, 
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isHidden: controller.isPasswordHidden.value,
                      onToggle: controller.togglePasswordVisibility
                    )),

                    // 4. Re-Password (Konfirmasi)
                    Obx(() => _buildInputGroup(
                      label: "Re-Password", 
                      controller: controller.confirmPassC, 
                      icon: Icons.lock_reset, // Icon beda biar jelas
                      isPassword: true,
                      isHidden: controller.isPasswordHidden.value,
                      onToggle: controller.togglePasswordVisibility
                    )),
                    
                    const SizedBox(height: 20),

                    // --- REGISTER BUTTON ---
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.registerUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: primaryColor.withOpacity(0.4),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "REGISTER NOW",
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    )),
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

  // --- WIDGET INPUT HELPER (Diupdate untuk Password) ---
  Widget _buildInputGroup({
    required String label, 
    required TextEditingController controller, 
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    bool isHidden = false,
    VoidCallback? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword ? isHidden : false, // Logika Hide/Show
          keyboardType: inputType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primaryColor, size: 20),
            // Logika Ikon Mata di Kanan
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onToggle,
                )
              : null,
            hintText: "Enter $label",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            filled: true,
            fillColor: const Color(0xFFF5F7FA).withOpacity(0.5), // Pake warna background
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}