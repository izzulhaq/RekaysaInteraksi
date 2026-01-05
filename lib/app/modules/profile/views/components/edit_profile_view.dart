import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Isi controller dengan data saat ini agar user tidak mengetik ulang
    controller.editNameC.text = controller.fullName.value;
    controller.editEmailC.text = controller.email.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // KOTAK INPUT
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildTextField("Full Name", controller.editNameC, Icons.person, false),
                  const SizedBox(height: 20),
                  _buildTextField("Email (Read Only)", controller.editEmailC, Icons.email, true), // Read Only
                ],
              ),
            ),
            const SizedBox(height: 30),

            // TOMBOL SAVE
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.updateProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, bool isReadOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: isReadOnly ? Colors.grey : const Color(0xFF1A237E)),
            filled: true,
            fillColor: isReadOnly ? Colors.grey[200] : const Color(0xFFF5F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}