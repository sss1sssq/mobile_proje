import 'package:flutter/material.dart';
import 'home_tab.dart';
import '../profile/profile_tab.dart';
// Task Manager dosyanı import et
import 'task_manager_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Sayfalar Listesi
  final List<Widget> _tabs = [
    const HomeTab(),
    const TaskManagerTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Seçili sayfayı göster
      body: _tabs[_currentIndex],

      bottomNavigationBar: Container(
        // Alt bara hafif bir gölge vererek modernleştirdik
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // Butonlar kaymasın diye sabitliyoruz
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent, // Seçili olanın rengi
          unselectedItemColor: Colors.grey,     // Seçili olmayanın rengi
          showSelectedLabels: true,
          showUnselectedLabels: false, // Seçili olmayanın yazısını gizle (Daha temiz görünüm)

          items: [
            // --- 1. BUTON: ANASAYFA (Standart) ---
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 28), // Normal Boyut
              label: 'Anasayfa',
            ),

            // --- 2. BUTON: TASK MANAGER (BÜYÜK VE HAVALI) ---
            BottomNavigationBarItem(
              icon: Container(
                // İkonun arkasına yuvarlak, hafif renkli bir zemin ekledik
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: _currentIndex == 1
                        ? Colors.blueAccent
                        : Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if(_currentIndex == 1) // Sadece seçiliyken gölge ver
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                    ]
                ),
                // İkon boyutunu büyüttük (32 px) ve rengini ayarladık
                child: Icon(
                  Icons.assignment_turned_in_rounded, // Daha uygun bir ikon
                  size: 32,
                  color: _currentIndex == 1 ? Colors.white : Colors.blueAccent,
                ),
              ),
              label: 'Görevler',
            ),

            // --- 3. BUTON: PROFİL (Standart) ---
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 28), // Normal Boyut
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}