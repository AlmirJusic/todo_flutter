import 'package:flutter/material.dart';

import '../models/todo.dart';

class ToDoProvider extends ChangeNotifier {
  final List<Todo> _toDoList = [
    Todo(
      id: '1',
      createdTime: DateTime.now(),
      title: 'Buy Food 😋',
      description: '''- Eggs
- Milk
- Bread
- Water ''',
    ),
    Todo(
      id: '2',
      createdTime: DateTime.now(),
      title: 'Plan family trip to Norway',
      description: '''- Rent some hotels
- Rent a car
- Pack suitcase''',
    ),
    Todo(
      id: '3',
      createdTime: DateTime.now(),
      title: 'Walk the Dog 🐕',
    ),
    Todo(
      id: '4',
      createdTime: DateTime.now(),
      title: 'Plan Jacobs birthday party 🎉🥳',
    ),
  ];

  List<Todo> get toDoIncompletedList =>
      _toDoList.where((todo) => todo.isCompleted == false).toList();

  List<Todo> get toDoCompletedList =>
      _toDoList.where((todo) => todo.isCompleted == true).toList();

  void addToDo(Todo todo) {
    _toDoList.add(todo);
    notifyListeners();
  }

  void removeToDo(Todo todo) {
    _toDoList.remove(todo);
    notifyListeners();
  }

  bool toggleToDoStatus(Todo todo) {
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();

    return todo.isCompleted;
  }

  void updateToDo(Todo todo, String title, String description) {
    todo.title = title;
    todo.description = description;

    notifyListeners();
  }
}
