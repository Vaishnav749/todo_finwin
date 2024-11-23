class Task {
  String title;
  String? description;
  String priority;
  bool isCompleted;

  Task({
    required this.title,
    this.description,
    required this.priority,
    this.isCompleted = false,
  });

  // Convert a Task object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  // Create a Task object from JSON format
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
