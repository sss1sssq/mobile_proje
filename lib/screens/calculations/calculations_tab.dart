import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'bmi_calculator_screen.dart';
import 'cardio_stopwatch_screen.dart';
import 'calorie_estimation_screen.dart';

class CalculationsTab extends StatelessWidget {
  const CalculationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Calculation Hub'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(currentUserProvider);
          
          if (user == null) {
            return const Center(
              child: Text('Please complete your profile first'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCalculationCard(
                context,
                title: 'BMI Calculator',
                description: 'Calculate your Body Mass Index and get status feedback',
                icon: Icons.monitor_weight,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BMICalculatorScreen(user: user),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildCalculationCard(
                context,
                title: 'Cardio Stopwatch',
                description: 'Full-featured stopwatch for cardio workouts',
                icon: Icons.timer,
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CardioStopwatchScreen(user: user),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildCalculationCard(
                context,
                title: 'Calorie Estimation',
                description: 'Real-time calorie burn estimation based on activity',
                icon: Icons.local_fire_department,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CalorieEstimationScreen(user: user),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalculationCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

