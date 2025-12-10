import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../exercises/exercises_tab.dart';
import '../calculations/calculations_tab.dart';
import '../nutrition/nutrition_tab.dart';
import '../supplements/supplements_tab.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {

    void logout() {
      // Çıkış işlemleri buraya
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.black),
          ),
        ),
        title: const Text("GymBuddy"),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            label: const Text("Log out"),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // --- 1. BUTON: EXERCISE (DÜZELTİLDİ) ---
            _buildMenuCard(
              context,
              title: "Exercise",
              icon: Icons.fitness_center,
              color: Colors.blueAccent,
              onTap: () {
                // BURASI ARTIK AKTİF:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExercisesTab()),
                );
              },
            ),

            // --- 2. BUTON: CALCULATE ---
            _buildMenuCard(
              context,
              title: "Calculate",
              icon: Icons.calculate,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalculationsTab()),
                );
              },
            ),

            // --- 3. BUTON: SUPPLEMENT ---
            _buildMenuCard(
              context,
              title: "Supplement",
              icon: Icons.local_pharmacy,
              color: Colors.greenAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SupplementsTab()),
                );
              },
            ),

            // --- 4. BUTON: NUTRITION ---
            _buildMenuCard(
              context,
              title: "Nutrition",
              icon: Icons.restaurant_menu,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NutritionTab()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}