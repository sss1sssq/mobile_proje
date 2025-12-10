import 'package:flutter/material.dart';
import '../../services/exercise_service.dart';
import '../../models/exercise_model.dart';
import 'exercise_detail_screen.dart';

class ExercisesTab extends StatefulWidget {
  const ExercisesTab({super.key});

  @override
  State<ExercisesTab> createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<ExercisesTab> {
  String? _selectedBodyPart;
  List<String> _availableBodyParts = [];

  @override
  void initState() {
    super.initState();
    _availableBodyParts = ExerciseService.getAvailableBodyParts();
  }

  List<ExerciseModel> get _filteredExercises {
    if (_selectedBodyPart == null) {
      return ExerciseService.getAllExercises();
    }
    return ExerciseService.getExercisesByBodyPart(_selectedBodyPart!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Targeted Exercise Guides'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: DropdownButtonFormField<String>(
              initialValue: _selectedBodyPart,
              decoration: const InputDecoration(
                labelText: 'Filter by Body Part',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Exercises'),
                ),
                ..._availableBodyParts.map((part) => DropdownMenuItem(
                      value: part,
                      child: Text(part.toUpperCase()),
                    )),
              ],
              onChanged: (value) {
                setState(() => _selectedBodyPart = value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.2),
                      child: const Icon(Icons.fitness_center, color: Colors.green),
                    ),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(exercise.description),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text(exercise.bodyPart),
                              backgroundColor: Colors.green.withOpacity(0.2),
                            ),
                            if (exercise.difficulty != null) ...[
                              const SizedBox(width: 8),
                              Chip(
                                label: Text(exercise.difficulty!),
                                backgroundColor: Colors.blue.withOpacity(0.2),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseDetailScreen(exercise: exercise),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

