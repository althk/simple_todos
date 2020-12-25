class Todo {
  String id;
  String todo;
  DateTime createdAt;
  DateTime completedAt;
  List<String> tags = [];
  bool completed = false;
  bool archived = false;

  Todo();

  String toString() =>
      'Todo($id) => {completed: $completed, archived: $archived, '
      'todo: $todo, createdAt: $createdAt, '
      'completedAt: $completedAt, tags: $tags}';

  Map toMap() {
    return {
      'id': id,
      'todo': todo,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'tags': tags?.join(','),
      'completed': completed ? 1 : 0,
      'archived': archived ? 1 : 0,
    };
  }

  Todo.fromMap(Map entry) {
    id = entry['id'];
    todo = entry['todo'];
    createdAt = entry['createdAt'] ??
        DateTime.fromMillisecondsSinceEpoch(entry['createdAt']);
    completedAt = entry['completedAt'] ??
        DateTime.fromMillisecondsSinceEpoch(entry['completedAt']);
    tags = entry['tags'] ?? (entry['tags'] as String).split(',');
    completed = entry['completed'] == 1 ? true : false;
    archived = entry['archived'] == 1 ? true : false;
  }
}
