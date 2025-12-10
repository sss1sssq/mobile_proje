import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../models/workout_session_model.dart';
import '../../providers/workout_provider.dart';
import '../../services/calculation_service.dart';

class CardioStopwatchScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const CardioStopwatchScreen({super.key, required this.user});

  @override
  ConsumerState<CardioStopwatchScreen> createState() =>
      _CardioStopwatchScreenState();
}

class _CardioStopwatchScreenState
    extends ConsumerState<CardioStopwatchScreen> {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;
  DateTime? _startTime;
  double _speed = 8.0; // km/h
  double _incline = 0.0; // percentage
  String _activityType = 'running';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      _startTime = DateTime.now();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _duration = Duration(seconds: _duration.inSeconds + 1);
        });
      });
      setState(() => _isRunning = true);
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _duration = Duration.zero;
      _isRunning = false;
      _startTime = null;
    });
  }

  void _saveWorkout() {
    if (_duration.inSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No workout to save')),
      );
      return;
    }

    final caloriesBurned = CalculationService.estimateCaloriesBurned(
      weightKg: widget.user.weight,
      duration: _duration,
      speedKmh: _speed,
      incline: _incline,
      activityType: _activityType,
    );

    final session = WorkoutSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: _startTime ?? DateTime.now(),
      endTime: DateTime.now(),
      duration: _duration,
      caloriesBurned: caloriesBurned,
      exerciseType: 'cardio',
      metadata: {
        'speed': _speed,
        'incline': _incline,
        'activityType': _activityType,
      },
    );

    ref.read(workoutSessionsProvider.notifier).addWorkoutSession(session);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Workout saved! Calories burned: ${caloriesBurned.toStringAsFixed(1)}',
        ),
      ),
    );

    _resetTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  double _getCaloriesBurned() {
    if (_duration.inSeconds == 0) return 0;
    return CalculationService.estimateCaloriesBurned(
      weightKg: widget.user.weight,
      duration: _duration,
      speedKmh: _speed,
      incline: _incline,
      activityType: _activityType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardio Stopwatch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isRunning ? _stopTimer : _startTimer,
                          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                          label: Text(_isRunning ? 'Stop' : 'Start'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: _isRunning ? Colors.orange : Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _resetTimer,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
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
                  children: [
                    const Text(
                      'Estimated Calories Burned',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getCaloriesBurned().toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 14,
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
                      'Activity Settings',
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
                        setState(() => _activityType = value ?? 'running');
                      },
                    ),
                    const SizedBox(height: 16),
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
                        setState(() => _speed = value);
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
                        setState(() => _incline = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveWorkout,
              icon: const Icon(Icons.save),
              label: const Text('Save Workout'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

