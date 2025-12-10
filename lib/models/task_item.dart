class TaskItem {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final DateTime createdAt;

  TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    required this.createdAt,
  });
}