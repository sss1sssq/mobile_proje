import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
// DİKKAT: authStateProvider'ın olduğu dosya yolunu buraya ekle.
// Genelde auth_provider.dart içindedir.
import '../../providers/auth_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const ProfileEditScreen({super.key, required this.user});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // İsim ve Soyisim için Controller
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 1. Önce veritabanındaki (UserModel) ismi kontrol et, yoksa Firebase'den çek
    // Eğer UserModel içinde 'name' ve 'surname' alanların varsa önce onları kullan:
    // _nameController.text = widget.user.name ?? "";

    // Şimdilik Firebase DisplayName'den çekiyoruz:
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.displayName != null) {
      final names = currentUser!.displayName!.split(' ');
      if (names.isNotEmpty) {
        _nameController.text = names.first;
        if (names.length > 1) {
          _surnameController.text = names.sublist(1).join(' ');
        }
      }
    }

    _heightController.text = widget.user.height.toStringAsFixed(1);
    _weightController.text = widget.user.weight.toStringAsFixed(1);
    _ageController.text = widget.user.age.toString();
    _selectedGender = widget.user.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. FIREBASE AUTH İSMİNİ GÜNCELLE
      final user = FirebaseAuth.instance.currentUser;
      final fullName = "${_nameController.text.trim()} ${_surnameController.text.trim()}";

      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.reload();
      }

      // 2. DATABASE GÜNCELLEMESİ (UserModel)
      // Not: Eğer UserModel'inde 'name' alanı varsa buraya eklemelisin: name: _nameController.text
      final updatedUser = widget.user.copyWith(
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        updatedAt: DateTime.now(),
      );

      await ref.read(userProfileProvider.notifier).updateProfile(updatedUser);

      // --- KRİTİK NOKTA: KULLANICI VERİSİNİ YENİLEMEYE ZORLA ---
      // Bu satır sayesinde 'currentUserProvider' veriyi tekrar çeker
      ref.invalidate(authStateProvider);
      // ---------------------------------------------------------

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil başarıyla güncellendi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profili Düzenle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ad', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                validator: (v) => v!.isEmpty ? 'Ad giriniz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Soyad', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v!.isEmpty ? 'Soyad giriniz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Boy (cm)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.height)),
                validator: (v) => v!.isEmpty ? 'Boy giriniz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Kilo (kg)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.monitor_weight)),
                validator: (v) => v!.isEmpty ? 'Kilo giriniz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yaş', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                validator: (v) => v!.isEmpty ? 'Yaş giriniz' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
<<<<<<< HEAD
                initialValue: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
=======
                value: _selectedGender,
>>>>>>> 663c45709b78ccf4e34e1595676a603f9846e520
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Erkek')),
                  DropdownMenuItem(value: 'female', child: Text('Kadın')),
                  DropdownMenuItem(value: 'other', child: Text('Diğer')),
                ],
                onChanged: (v) => setState(() => _selectedGender = v),
                decoration: const InputDecoration(labelText: 'Cinsiyet', border: OutlineInputBorder(), prefixIcon: Icon(Icons.people)),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Değişiklikleri Kaydet', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}