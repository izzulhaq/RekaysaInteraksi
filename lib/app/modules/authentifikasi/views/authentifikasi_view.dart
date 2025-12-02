import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentifikasi_controller.dart';
import 'register_view.dart'; // Kita akan buat file ini setelahnya

class AuthentifikasiView extends GetView<AuthentifikasiController> {
  const AuthentifikasiView({Key? key}) : super(key: key);

  final Color primaryBlue = const Color(0xFF004AAD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER (Sama seperti Home)
            _buildHeader(),
            
            const SizedBox(height: 50),

            // FORM LOGIN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username Field
                  _buildLabel("Username"),
                  TextField(
                    controller: controller.loginUserC,
                    decoration: InputDecoration(
                      hintText: "PRAJESH SHAKYA", // Placeholder dummy
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixIcon: Icon(Icons.person, color: primaryBlue),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // Password Field
                  _buildLabel("Password"),
                  Obx(() => TextField(
                    controller: controller.loginPassC,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: "*****************",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value 
                            ? Icons.visibility_off 
                            : Icons.visibility,
                          color: primaryBlue,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                  )),

                  const SizedBox(height: 50),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                         // Arahkan ke Home
                         Get.offAllNamed('/home'); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Forgot Password & Link ke Register
                  Center(
                    child: Column(
                      children: [
                        Text("Forgot Password ?", style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 10),
                        // Tombol Text untuk ke halaman Register
                        GestureDetector(
                          onTap: () => Get.to(() => const RegisterView()),
                          child: Text(
                            "Don't have an account? Register",
                            style: TextStyle(
                              color: primaryBlue, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Header Melengkung (Reusable)
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 280, // Sedikit lebih tinggi untuk Login
          margin: const EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(250, 100), // Lengkungan curam
              bottomRight: Radius.elliptical(250, 100),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.restaurant_menu, size: 40, color: primaryBlue),
                 Text("LUNCHIFY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryBlue))
              ],
            ),
          ),
        ),
      ],
    );
  }
}