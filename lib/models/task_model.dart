import 'exercise_model.dart';

class TaskItem {
  ExerciseModel exercise;
  int sets;
  int reps;
  DateTime date;
  bool isCompleted;

  TaskItem({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.date,
    this.isCompleted = false,
  });
}
