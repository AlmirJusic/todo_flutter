import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/http_exception.dart';
import '../models/todo.dart';

class ToDoProvider extends ChangeNotifier {
  List<Todo> _toDoList = [
/*    Todo(
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
    ), */
  ];

  List<Todo> get toDoIncompletedList =>
      _toDoList.where((todo) => todo.isCompleted == false).toList();

  List<Todo> get toDoCompletedList =>
      _toDoList.where((todo) => todo.isCompleted == true).toList();

  Future<void> addToDo(Todo todo) async {
    final url = Uri.parse(
        'https://todo-app-flutter-12837-default-rtdb.europe-west1.firebasedatabase.app/todos.json');

    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': todo.title,
          'description': todo.description,
          'createdTime': timeStamp.toIso8601String(),
          'isCompleted': todo.isCompleted,
        }),
      );

      final newTodo = Todo(
        createdTime: timeStamp,
        title: todo.title,
        description: todo.description,
        id: json.decode(response.body)['name'],
        isCompleted: todo.isCompleted,
      );

      _toDoList.add(newTodo);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getToDos() async {
    final url = Uri.parse(
        'https://todo-app-flutter-12837-default-rtdb.europe-west1.firebasedatabase.app/todos.json');

    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<Todo> loadedToDos = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((todoId, todoData) {
        loadedToDos.add(
          Todo(
            id: todoId,
            title: todoData['title'],
            description: todoData['description'],
            createdTime: DateTime.parse(todoData['createdTime']),
            isCompleted: todoData['isCompleted'],
          ),
        );
      });
      _toDoList = loadedToDos;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateToDo(
      String id, String title, String description, Todo newTodo) async {
    try {
      final todoIndex = _toDoList.indexWhere((todo) => todo.id == id);

      if (todoIndex >= 0) {
        final url = Uri.parse(
            'https://todo-app-flutter-12837-default-rtdb.europe-west1.firebasedatabase.app/todos/$id.json');
        await http.patch(url,
            body: json.encode({
              'title': title,
              'description': description,
              'createdTime': newTodo.createdTime.toString(),
              'isCompleted': newTodo.isCompleted,
            }));
        newTodo.title = title;
        newTodo.description = description;
        _toDoList[todoIndex] = newTodo;
        notifyListeners();
      } else {
        print('...');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> toggleToDoStatus(Todo todo) async {
    String id = todo.id;
    final url = Uri.parse(
        'https://todo-app-flutter-12837-default-rtdb.europe-west1.firebasedatabase.app/todos/$id.json');

    final oldStatus = todo.isCompleted;
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode({
            'title': todo.title,
            'description': todo.description,
            'createdTime': todo.createdTime.toString(),
            'isCompleted': todo.isCompleted,
          }));
      notifyListeners();
      if (response.statusCode >= 400) {
        todo.isCompleted = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      todo.isCompleted = oldStatus;
      notifyListeners();
    }
  }

  Future<void> removeToDo(String id) async {
    final url = Uri.parse(
        'https://todo-app-flutter-12837-default-rtdb.europe-west1.firebasedatabase.app/todos/$id.json');

    final existingToDoIndex =
        _toDoList.indexWhere((element) => element.id == id);
    Todo? existingToDo = _toDoList[existingToDoIndex];
    _toDoList.removeAt(existingToDoIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _toDoList.insert(existingToDoIndex, existingToDo);
      notifyListeners();
      throw HttpException('Could not delete todo!');
    }
    existingToDo = null;
  }

  /* void addToDo(Todo todo) {
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
  } */
}
