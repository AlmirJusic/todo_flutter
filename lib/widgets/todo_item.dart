import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/crud_todo_screen.dart';

import '../models/todo.dart';
import '../providers/ToDoProvider.dart';

class ToDoItem extends StatelessWidget {
  final Todo todo;
  const ToDoItem({required this.todo, super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context); //mora zbog async
    final providerToDo = Provider.of<ToDoProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Slidable(
        key: Key(todo.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CrudToDoScreen(
                      todo: todo,
                      isEdit: true,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                await providerToDo.removeToDo(todo.id);
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text('Deleted the task!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                value: todo.isCompleted,
                onChanged: (_) {
                  providerToDo.toggleToDoStatus(todo);

                  /*  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isCompleted
                          ? 'Task is completed!'
                          : 'Task is not completed!'),
                      duration: const Duration(seconds: 2),
                    ),
                  ); */
                },
                activeColor: Theme.of(context).colorScheme.primary,
                checkColor: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy - hh:mm').format(todo.createdTime),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                    if (todo.description != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(
                          todo.description!,
                          style: const TextStyle(fontSize: 18, height: 1.5),
                        ),
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
