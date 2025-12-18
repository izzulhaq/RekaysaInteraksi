import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/food_option.dart'; // Pastikan path model ini benar

class RekomendasiController extends GetxController {
  // --- STATE ---
  var isLoading = false.obs;
  var hasResult = false.obs; // false = Tampil Menu Input, true = Tampil Hasil
  
  // --- INPUT USER ---
  final locationC = TextEditingController();
  var isAroundMe = true.obs; // Toggle "Sekitar Saya"
  
  // Pilihan Harga (Ganti input manual budgetC dengan ini)
  var selectedPriceIndex = 1.obs; // Default: Standar
  final priceOptions = ["Hemat (<20rb)", "Standar (20-50rb)", "Sultan (>50rb)"];
  
  // Pilihan Mood (Grid Icon)
  var selectedMoodIndex = 4.obs; // Default: Terserah
  final moodOptions = [
    {"label": "Pedas", "icon": "🌶️", "keyword": "penyetan sambal pedas geprek"},
    {"label": "Seger", "icon": "❄️", "keyword": "es kopi cafe dessert"},
    {"label": "Berkuah", "icon": "🍜", "keyword": "soto bakso rawon sop ramen"},
    {"label": "Nasi", "icon": "🍚", "keyword": "nasi goreng padang warteg"},
    {"label": "Terserah", "icon": "🤯", "keyword": ""}, 
  ];

  // --- DATA HASIL ---
  final allOptions = <FoodOption>[].obs; 
  var recommendedFood = Rxn<FoodOption>(); 

  @override
  void onClose() {
    locationC.dispose();
    super.onClose();
  }

  // --- FUNGSI UTAMA: CARI & ACAK ---
  Future<void> cariRekomendasi() async {
    // 1. Masukkan API Key Google Anda Di Sini
    String apiKey = "AIzaSyDE0dwP4QKBE7pRUuj9LVV33ha902p8_3Y"; 

    // 2. Tentukan Lokasi
    String queryLoc = isAroundMe.value ? "Malang" : locationC.text; 
    if (queryLoc.isEmpty) {
      Get.snackbar("Eits", "Lokasi belum diisi!");
      return;
    }

    // 3. Susun Query
    String keyword = moodOptions[selectedMoodIndex.value]['keyword'].toString();
    // Tambah kata 'murah' di query jika pilih hemat
    String priceQuery = selectedPriceIndex.value == 0 ? "murah" : ""; 
    
    String textQuery = "Restoran $keyword $priceQuery di $queryLoc";

    isLoading.value = true;

    try {
      String url = "https://places.googleapis.com/v1/places:searchText";
      
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'places.displayName,places.rating,places.priceLevel,places.formattedAddress,places.id'
        },
        body: jsonEncode({
          "textQuery": textQuery,
          "minRating": 4.0, 
          "maxResultCount": 20, 
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List places = data['places'] ?? [];
        
        if (places.isEmpty) {
          Get.snackbar("Zonk", "Gak nemu yang cocok, coba ganti mood!");
          isLoading.value = false;
          return;
        }

        // Mapping Data
        allOptions.value = places.map((place) {
             double estPrice = 30000;
             String pl = place['priceLevel'] ?? "";
             if (pl == "PRICE_LEVEL_INEXPENSIVE") estPrice = 15000;
             if (pl == "PRICE_LEVEL_EXPENSIVE") estPrice = 75000;
             
             return FoodOption(
               id: place['name'].toString().split('/').last,
               name: place['displayName']['text'],
               rating: (place['rating'] ?? 0.0).toDouble(),
               distanceMinutes: 0, 
               price: estPrice,
             );
        }).toList();

        // Acak Hasil
        rollAgain();
        hasResult.value = true; 

      } else {
        Get.snackbar("Error", "Gagal koneksi ke Google");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Terjadi kesalahan sistem");
    } finally {
      isLoading.value = false;
    }
  }

  void rollAgain() {
    if (allOptions.isEmpty) return;
    final random = Random();
    recommendedFood.value = allOptions[random.nextInt(allOptions.length)];
  }

  void reset() {
    hasResult.value = false;
    recommendedFood.value = null;
    allOptions.clear();
  }

  void openMap() async {
    final food = recommendedFood.value;
    if (food == null) return;
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(food.name)}");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Gagal buka Maps");
    }
  }
}