import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ExploreController extends GetxController {
  // --- STATE ---
  var isLoading = false.obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  final searchC = TextEditingController();

  // API Key Anda
  final String apiKey = "AIzaSyDE0dwP4QKBE7pRUuj9LVV33ha902p8_3Y"; 

  final categories = ["Penyetan", "Bakso", "Cafe", "Soto", "Mie", "Nasi Goreng"];

  void searchFood(String query) async {
    // 1. CEK QUERY KOSONG
    if (query.trim().isEmpty) {
      Get.snackbar("Eits", "Ketik dulu mau makan apa", backgroundColor: Colors.orange);
      return;
    }

    isLoading.value = true;
    searchResults.clear();

    try {
      String fullQuery = "$query di Malang"; 
      String url = "https://places.googleapis.com/v1/places:searchText";
      
      print("Mencari: $fullQuery..."); // Debug 1

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          // PERBAIKAN: FieldMask disederhanakan dulu (hapus priceLevel)
          'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.rating,places.userRatingCount'
        },
        body: jsonEncode({
          "textQuery": fullQuery,
          "minRating": 3.0, 
          "maxResultCount": 10,
        }),
      );

      // --- DEBUGGING ERROR 400 ---
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List places = data['places'] ?? [];

        searchResults.assignAll(places.map((place) {
          return {
            "name": place['displayName']['text'],
            "address": place['formattedAddress'] ?? "Alamat tidak tersedia",
            "rating": (place['rating'] ?? 0.0).toDouble(),
            "count": place['userRatingCount'] ?? 0,
            // Price kita default dulu biar aman
            "price": "Standard", 
          };
        }).toList());
        
      } else {
        // INI PENTING: Lihat error asli Google di Terminal
        print("ERROR GOOGLE: ${response.body}"); 
        Get.snackbar("Gagal", "Error ${response.statusCode}. Cek terminal untuk detail.");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan koneksi");
      print("SYSTEM ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
  void openMap(String address, String name) async {
    // Kita buat query pencarian yang spesifik: "Nama Restoran, Alamat"
    // Encode komponen URL agar karakter spesial (spasi, koma) aman
    String query = Uri.encodeComponent("$name, $address");
    
    // URL Scheme untuk Google Maps
    // Menggunakan query search agar lebih akurat mencari lokasi
    Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    try {
      // Coba buka aplikasi eksternal (Google Maps App / Browser)
      if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Tidak dapat membuka aplikasi peta");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }
}