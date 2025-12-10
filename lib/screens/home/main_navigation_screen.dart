import 'package:flutter/material.dart';
import 'home_tab.dart';
import '../profile/profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // const kelimelerini kaldırdık çünkü içindeki sayfalar const olmayabilir
  final List<Widget> _tabs = [
    HomeTab(),                        // 1. Anasayfa
    Center(child: Text("Task Manager")), // 2. Task Manager
    ProfileTab(),                     // 3. Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex], // Seçili sayfayı göster
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [ // Burada 'const' olmamalı
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Task Manager',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}