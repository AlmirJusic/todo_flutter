import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './todo_item.dart';

import '../providers/ToDoProvider.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    Provider.of<ToDoProvider>(context, listen: false).getToDos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerToDo = Provider.of<ToDoProvider>(context);

    return providerToDo.toDoIncompletedList.isEmpty
        ? const Center(
            child: Text(
              'No ToDo\'s',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemBuilder: (ctx, index) => Column(
              children: [
                ToDoItem(todo: providerToDo.toDoIncompletedList[index]),
              ],
            ),
            itemCount: providerToDo.toDoIncompletedList.length,
            separatorBuilder: (ctx, index) => const SizedBox(
              height: 8,
            ),
          );
  }
}
