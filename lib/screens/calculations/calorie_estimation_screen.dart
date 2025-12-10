import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/calculation_service.dart';

class CalorieEstimationScreen extends StatefulWidget {
  final UserModel user;

  const CalorieEstimationScreen({super.key, required this.user});

  @override
  State<CalorieEstimationScreen> createState() =>
      _CalorieEstimationScreenState();
}

class _CalorieEstimationScreenState extends State<CalorieEstimationScreen> {
  double _speed = 8.0; // km/h
  double _incline = 0.0; // percentage
  int _durationMinutes = 30;
  String _activityType = 'running';
  double? _estimatedCalories;
  double? _bmr;
  double? _dailyCalorieNeeds;

  @override
  void initState() {
    super.initState();
    _calculateBMR();
    _calculateDailyCalorieNeeds();
    _estimateCalories();
  }

  void _calculateBMR() {
    if (widget.user.gender != null) {
      setState(() {
        _bmr = CalculationService.calculateBMR(
          weightKg: widget.user.weight,
          heightCm: widget.user.height,
          age: widget.user.age,
          gender: widget.user.gender!,
        );
      });
    }
  }

  void _calculateDailyCalorieNeeds() {
    if (_bmr != null) {
      setState(() {
        _dailyCalorieNeeds = CalculationService.calculateDailyCalorieNeeds(
          bmr: _bmr!,
          activityLevel: 'moderate', // Default to moderate
        );
      });
    }
  }

  void _estimateCalories() {
    setState(() {
      _estimatedCalories = CalculationService.estimateCaloriesBurned(
        weightKg: widget.user.weight,
        duration: Duration(minutes: _durationMinutes),
        speedKmh: _speed,
        incline: _incline,
        activityType: _activityType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Estimation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Estimated Calories Burned',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _estimatedCalories?.toStringAsFixed(1) ?? '0.0',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activity Parameters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _activityType,
                      decoration: const InputDecoration(
                        labelText: 'Activity Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'running', child: Text('Running')),
                        DropdownMenuItem(value: 'walking', child: Text('Walking')),
                        DropdownMenuItem(value: 'cycling', child: Text('Cycling')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _activityType = value ?? 'running';
                          _estimateCalories();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Duration: $_durationMinutes minutes',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Slider(
                      value: _durationMinutes.toDouble(),
                      min: 5,
                      max: 180,
                      divisions: 35,
                      label: '$_durationMinutes minutes',
                      onChanged: (value) {
                        setState(() {
                          _durationMinutes = value.toInt();
                          _estimateCalories();
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Speed: ${_speed.toStringAsFixed(1)} km/h',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Slider(
                      value: _speed,
                      min: 1.0,
                      max: 20.0,
                      divisions: 190,
                      label: '${_speed.toStringAsFixed(1)} km/h',
                      onChanged: (value) {
                        setState(() {
                          _speed = value;
                          _estimateCalories();
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Incline: ${_incline.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Slider(
                      value: _incline,
                      min: 0.0,
                      max: 15.0,
                      divisions: 150,
                      label: '${_incline.toStringAsFixed(1)}%',
                      onChanged: (value) {
                        setState(() {
                          _incline = value;
                          _estimateCalories();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_bmr != null && _dailyCalorieNeeds != null) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                color: Colors.blue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Metabolic Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('BMR (Basal Metabolic Rate):'),
                          Text(
                            '${_bmr!.toStringAsFixed(1)} kcal/day',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Daily Calorie Needs:'),
                          Text(
                            '${_dailyCalorieNeeds!.toStringAsFixed(1)} kcal/day',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              color: Colors.green.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Calorie estimation uses MET (Metabolic Equivalent of Task) values adjusted for your weight, speed, incline, and activity duration. The calculation accounts for your personal metrics to provide accurate estimates.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

