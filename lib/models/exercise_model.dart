class ExerciseModel {
  // deneme
  final String id;
  final String name;
  final String bodyPart; // e.g., "abs", "legs", "arms", "chest", "back"
  final String description;
  final String? videoUrl;
  final String? imageUrl;
  final List<String> instructions;
  final int? sets;
  final int? reps;
  final String? difficulty; // "beginner", "intermediate", "advanced"

  ExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.description,
    this.videoUrl,
    this.imageUrl,
    required this.instructions,
    this.sets,
    this.reps,
    this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'description': description,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'instructions': instructions,
      'sets': sets,
      'reps': reps,
      'difficulty': difficulty,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bodyPart: map['bodyPart'] ?? '',
      description: map['description'] ?? '',
      videoUrl: map['videoUrl'],
      imageUrl: map['imageUrl'],
      instructions: List<String>.from(map['instructions'] ?? []),
      sets: map['sets'],
      reps: map['reps'],
      difficulty: map['difficulty'],
    );
  }
}

