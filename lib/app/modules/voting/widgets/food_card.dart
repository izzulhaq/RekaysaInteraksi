import 'package:flutter/material.dart';
import 'package:lunchify/app/modules/voting/models/food_option.dart';
import '../models/food_model.dart';

class FoodCard extends StatelessWidget {
  final FoodOption food;
  final VoidCallback onTap;

  const FoodCard({required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: ListTile(
        title: Text(food.name),
        subtitle: Text(
          "⭐ ${food.rating} | ${food.distanceMinutes} min | Rp ${food.price}",
        ),
        trailing: ElevatedButton(onPressed: onTap, child: Text("Pilih Ini")),
      ),
    );
  }
}
