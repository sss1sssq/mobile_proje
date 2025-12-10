import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';
import '../../models/task_item.dart';

class TaskManagerTab extends ConsumerWidget {
  const TaskManagerTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Tasarımdaki açık gri arka plan
      body: SafeArea(
        child: Column(
          children: [
            // Başlık Alanı
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                "Görev Listesi",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // Liste Alanı
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                child: Text(
                  "Henüz görev eklenmemiş.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final TaskItem task = tasks[index];
                  return _buildTaskCard(context, ref, task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, TaskItem task) {
    // Tamamlanma durumuna göre renk belirleme
    Color accentColor = task.isCompleted ? Colors.green : Colors.lightBlue;

    // Kaydırarak silme (Dismissible) özelliği
    return Dismissible(
      key: Key(task.id.toString()), // Task ID'si unique key olmalı
      direction: DismissDirection.endToStart, // Sadece sola kaydırma
      onDismissed: (_) {
        ref.read(taskProvider.notifier).removeTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Görev silindi"), duration: Duration(seconds: 1)),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        // Tıklayınca Riverpod üzerinden durumu güncelle
        onTap: () {
          ref.read(taskProvider.notifier).toggleTaskStatus(task.id);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Sol Şerit (Accent Bar)
              Container(
                width: 10,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 2. Özel Checkbox Tasarımı
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isCompleted ? accentColor : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: task.isCompleted ? accentColor : Colors.transparent,
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
              const SizedBox(width: 16),

              // 3. Yazı Alanı
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: task.isCompleted ? Colors.grey : Colors.black87,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: accentColor),
                        const SizedBox(width: 4),
                        Text(
                          // Tarihi basitçe gösteriyoruz
                          "${task.createdAt.hour.toString().padLeft(2, '0')}:${task.createdAt.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}