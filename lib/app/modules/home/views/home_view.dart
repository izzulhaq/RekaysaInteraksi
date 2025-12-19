import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  // Tema Warna Deep Navy
  final Color primaryColor = const Color(0xFF1A237E);
  final Color accentColor = const Color(0xFF5C6BC0);
  final Color backgroundColor = const Color(0xFFF5F7FA); // Background agak abu terang

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // GABUNGAN HEADER & WELCOME CARD (Overlapping Layout)
            _buildTopSection(),

            const SizedBox(height: 30),

            // MENU GRID (Tampilan Kotak Besar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Main Menu",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: primaryColor
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Row untuk membuat efek Grid 2 Kolom
                  Row(
                    children: [
                      // Tombol 1: Voting Food
                      Expanded(
                        child: _buildGridMenuCard(
                          title: "Voting Food",
                          icon: Icons.how_to_vote_outlined,
                          onTap: controller.goToVotingFood,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 15), // Jarak antar kotak
                      
                      // Tombol 2: Rekomendasi
                      Expanded(
                        child: _buildGridMenuCard(
                          title: "Rekomendasi",
                          icon: Icons.recommend_outlined,
                          onTap: controller.goToRekomendasi,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // FOOTER STATIC (Hiasan Bawah agar tidak terlalu kosong)
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Icon(Icons.restaurant, size: 40, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text(
                    "Lunchify App v1.0",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'EXPLORE',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'PROFILE',
              ),
            ],
          )),
    );
  }

  // WIDGET BAGIAN ATAS (Header Biru + Kartu Welcome Menumpuk)
  Widget _buildTopSection() {
    return Stack(
      clipBehavior: Clip.none, // Izinkan elemen keluar dari batas Stack
      alignment: Alignment.topCenter,
      children: [
        // 1. Background Biru Lengkung
        Container(
          height: 240,
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
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello, User!",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 22, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "What do you want to eat?",
                          style: TextStyle(
                            color: Colors.white70, 
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                    // Logo Kecil di Header
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        // 2. Kartu "Welcome/Info" yang Menumpuk (Overlapping)
        Positioned(
          top: 180, // Mengatur posisi agar setengah di biru, setengah di putih
          left: 20,
          right: 20,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Bagian Kiri (Icon Besar)
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Icon(Icons.fastfood_rounded, size: 40, color: primaryColor),
                ),
                // Bagian Kanan (Teks)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lunch Time!",
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: primaryColor
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Don't forget to vote for your meal today.",
                          style: TextStyle(
                            fontSize: 12, 
                            color: Colors.grey[600]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Spacer transparan agar konten di bawah tidak tertutup Stack
        const SizedBox(height: 290), 
      ],
    );
  }

  // WIDGET KOTAK MENU BESAR (Grid Card)
  Widget _buildGridMenuCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160, // Tinggi kotak agar terlihat besar
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lingkaran Icon
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 35, color: primaryColor),
            ),
            const SizedBox(height: 15),
            // Judul Menu
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 5),
            // Subtitle kecil (Opsional, statis)
            Text(
              "Tap to open",
              style: TextStyle(fontSize: 10, color: Colors.grey[400]),
            )
          ],
        ),
      ),
    );
  }
}