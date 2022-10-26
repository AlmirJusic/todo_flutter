import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ToDoProvider.dart';
import './todo_item.dart';

class ToDoListCompleted extends StatelessWidget {
  const ToDoListCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    final providerToDo = Provider.of<ToDoProvider>(context);

    return providerToDo.toDoCompletedList.isEmpty
        ? const Center(
            child: Text(
              'No completed ToDo\'s',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemBuilder: (ctx, index) => Column(
              children: [
                ToDoItem(todo: providerToDo.toDoCompletedList[index]),
              ],
            ),
            itemCount: providerToDo.toDoCompletedList.length,
            separatorBuilder: (ctx, index) => const SizedBox(
              height: 8,
            ),
          );
  }
}
