import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:gym_buddy_ali_try/models/user_model.dart';
import 'package:gym_buddy_ali_try/screens/profile/profile_edit_screen.dart';
import 'package:gym_buddy_ali_try/providers/user_provider.dart';

class MockUserProvider extends Mock {}

void main() {
  group('ProfileEditScreen Tests', () {
    final testUser = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      height: 180.0,
      weight: 75.0,
      age: 25,
      gender: 'male',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    testWidgets('displays initial user data', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.byDisplayValue('180.0'), findsOneWidget);
      expect(find.byDisplayValue('75.0'), findsOneWidget);
      expect(find.byDisplayValue('25'), findsOneWidget);
    });

    testWidgets('validates height field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      final heightField = find.byType(TextFormField).first;
      await tester.enterText(heightField, '30');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      expect(find.text('Please enter a valid height (50-250 cm)'), findsOneWidget);
    });

    testWidgets('validates weight field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), '10');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      expect(find.text('Please enter a valid weight (20-300 kg)'), findsOneWidget);
    });

    testWidgets('validates age field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), '150');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      expect(find.text('Please enter a valid age'), findsOneWidget);
    });

    testWidgets('shows loading indicator during save', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('gender dropdown works', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderContainer(
          child: MaterialApp(
            home: ProfileEditScreen(user: testUser),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });
  });
}

class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const ProfileEditScreen({super.key, required this.user});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _heightController.text = widget.user.height.toStringAsFixed(1);
    _weightController.text = widget.user.weight.toStringAsFixed(1);
    _ageController.text = widget.user.age.toString();
    _selectedGender = widget.user.gender;
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = widget.user.copyWith(
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        updatedAt: DateTime.now(),
      );

      await ref.read(userProfileProvider.notifier).updateProfile(updatedUser);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
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
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: Icon(Icons.height),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  final height = double.tryParse(value);
                  if (height == null || height < 50 || height > 250) {
                    return 'Please enter a valid height (50-250 cm)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 20 || weight > 300) {
                    return 'Please enter a valid weight (20-300 kg)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 13 || age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() => _selectedGender = value);
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

