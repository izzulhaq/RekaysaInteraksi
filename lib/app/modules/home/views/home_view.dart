import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  // Warna utama berdasarkan gambar (Biru)
  final Color primaryBlue = const Color(0xFF004AAD);
  // Warna background tombol menu (Biru muda/abu-abu)
  final Color menuBackground = const Color(0xFFEFF4F8);

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false, // Membiarkan header biru menutupi status bar jika diinginkan
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 20),
                    // Menu Buttons
                    _buildMenuButton(
                      title: "Voting Food",
                      icon: Icons.assignment_turned_in, // Icon checklist
                      onTap: controller.goToVotingFood,
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      title: "Cek Keramaian\nResto",
                      icon: Icons.groups, // Icon group/people
                      onTap: controller.goToCekKeramaian,
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      title: "Rekomendasi\nMakanan",
                      icon: Icons.volunteer_activism, // Icon tangan/lampu (rekomendasi)
                      onTap: controller.goToRekomendasi,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,
            selectedItemColor: primaryBlue,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'CEK RESTO',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'PROFIL',
              ),
            ],
          )),
    );
  }

  // Widget untuk Header (Biru melengkung + Logo)
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Background Biru
        Container(
          height: 200, // Tinggi header biru
          margin: const EdgeInsets.only(bottom: 40), // Ruang untuk lingkaran logo
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(200, 30), // Efek melengkung
              bottomRight: Radius.elliptical(200, 30),
            ),
          ),
        ),
        // Lingkaran Putih Pembungkus Logo
        Positioned(
          bottom: 0,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              // Ganti dengan Image.asset('assets/logo.png') jika sudah ada file gambarnya
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.restaurant_menu, size: 30, color: primaryBlue),
                   Text(
                     "LUNCHIFY",
                     style: TextStyle(
                       fontSize: 10, 
                       fontWeight: FontWeight.bold, 
                       color: primaryBlue
                     ),
                   )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk Kartu Welcome Message
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Welcome Message",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  // Widget Helper untuk Tombol Menu
  Widget _buildMenuButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: menuBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Icon Container
            Icon(
              icon,
              size: 40,
              color: primaryBlue,
            ),
            const SizedBox(width: 20),
            // Text
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}