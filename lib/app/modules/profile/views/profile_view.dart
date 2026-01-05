import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

// Pastikan path import ini sesuai dengan lokasi file Anda
import 'components/edit_profile_view.dart';
import 'components/change_password_view.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  // Inject Controller
  final controller = Get.put(ProfileController());

  // Tema Warna
  final Color primaryColor = const Color(0xFF1A237E);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. HEADER & AVATAR (OVERLAPPING STYLE) ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // Background Biru Gradient
                Container(
                  height: 200,
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text(
                      "My Profile",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Foto Profil (Lingkaran)
                Positioned(
                  bottom: -60,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Obx(() {
                      // Logika Foto: Jika kosong pakai dummy, jika ada pakai NetworkImage
                      ImageProvider image;
                      if (controller.photoUrl.value.isEmpty) {
                        // Avatar Dummy (Inisial Nama)
                        image = const NetworkImage("https://ui-avatars.com/api/?background=random&name=User");
                      } else {
                        image = NetworkImage(controller.photoUrl.value);
                      }
                      
                      return CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: image,
                      );
                    }),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70), // Spasi agar teks tidak tertutup avatar

            // --- 2. NAMA & EMAIL USER ---
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Text(
                    controller.fullName.value,
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: primaryColor
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    controller.email.value,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              );
            }),

            const SizedBox(height: 40),

            // --- 3. MENU PENGATURAN (CARD) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSectionTitle("Account Settings"),
                  
                  Container(
                    decoration: _boxDecoration(),
                    child: Column(
                      children: [
                        // Edit Profile -> Pindah Halaman
                        _buildProfileTile(
                          Icons.edit, 
                          "Edit Profile", 
                          "Tap to edit", 
                          isAction: true,
                          onTap: () => Get.to(() => const EditProfileView()),
                        ),
                        
                        _divider(),
                        
                        // Change Photo -> Muncul Modal Bawah
                        _buildProfileTile(
                          Icons.camera_alt, 
                          "Change Photo", 
                          "Update", 
                          isAction: true,
                          onTap: () => _showPhotoOptions(context),
                        ),
                        
                        _divider(),
                        
                        // Change Password -> Pindah Halaman
                        _buildProfileTile(
                          Icons.lock, 
                          "Change Password", 
                          "***", 
                          isAction: true,
                          onTap: () => Get.to(() => const ChangePasswordView()),
                        ),
                        
                        _divider(),
                        
                        // Logout -> Panggil Controller
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.logout, color: Colors.red),
                          ),
                          title: const Text(
                            "Logout", 
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)
                          ),
                          onTap: controller.logout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- 4. FUNGSI MODAL BOTTOM SHEET (UNTUK GANTI FOTO) ---
  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gagang kecil di atas
            Container(
              width: 40, 
              height: 4, 
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))
            ),
            const SizedBox(height: 20),
            
            const Text("Change Profile Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Pilihan Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionBtn(Icons.camera_alt, "Camera", Colors.blue, () {
                  Get.back();
                  Get.snackbar("Info", "Fitur Kamera akan segera hadir!");
                }),
                _buildOptionBtn(Icons.photo_library, "Gallery", Colors.purple, () {
                  Get.back();
                  Get.snackbar("Info", "Fitur Galeri akan segera hadir!");
                }),
                _buildOptionBtn(Icons.delete, "Remove", Colors.red, () {
                   Get.back();
                   // Tambahkan logika hapus foto di controller jika perlu
                   Get.snackbar("Info", "Foto dihapus (Placeholder)");
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- 5. WIDGET HELPER UI ---
  
  // Style Kotak Putih
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
      ],
    );
  }

  // Garis Pemisah Tipis
  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(color: Colors.grey[100], height: 1),
    );
  }

  // Judul Section Kecil (ACCOUNT SETTINGS)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey[500],
            letterSpacing: 1.2
          ),
        ),
      ),
    );
  }

  // Tombol Bulat di Modal Sheet
  Widget _buildOptionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // List Item Menu (Baris Menu)
  Widget _buildProfileTile(IconData icon, String title, String value, {bool isAction = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E).withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF1A237E)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      trailing: isAction 
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : Text(value, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
      onTap: isAction ? onTap : null,
    );
  }
}