import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_item.dart';

class TaskNotifier extends StateNotifier<List<TaskItem>> {
  TaskNotifier() : super([]); // Başlangıçta boş liste

  // Ekleme Fonksiyonu (subtitle parametresi alıyor)
  void addTask(String title, String subtitle) {
    state = [
      ...state,
      TaskItem(
        id: DateTime.now().toString(),
        title: title,
        subtitle: subtitle, // Gelen set/tekrar bilgisi buraya
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
    ];
  }

  // Durum Değiştirme (Checkbox)
  void toggleTaskStatus(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          TaskItem(
            id: task.id,
            title: task.title,
            subtitle: task.subtitle, // <--- HATAYI ÇÖZEN SATIR: Mevcut subtitle'ı koruyoruz
            isCompleted: !task.isCompleted,
            createdAt: task.createdAt,
          )
        else
          task,
    ];
  }

  // Silme Fonksiyonu
  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}

// Provider Tanımı
final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskItem>>((ref) {
  return TaskNotifier();
});