class Todo {
  final DateTime createdTime;
  late String title;
  final String id;
  late String? description;
  bool isCompleted;

  Todo(
      {required this.createdTime,
      required this.title,
      required this.id,
      this.description,
      this.isCompleted = false});
}
