class Task {
  final String id; 
  String title;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;  
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted, 
    );
  }
}