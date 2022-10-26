import 'package:flutter/material.dart';
import 'package:todo_flutter/main.dart';
import '../screens/crud_todo_screen.dart';
import '../widgets/todo_list.dart';
import '../widgets/todo_list_completed.dart';

class ToDoMainScreen extends StatefulWidget {
  const ToDoMainScreen({super.key});

  @override
  State<ToDoMainScreen> createState() => _ToDoMainScreenState();
}

class _ToDoMainScreenState extends State<ToDoMainScreen> {
  var selectedPageIndex = 0;
  final List<Map<String, Object>> pages = [
    {
      'page': const ToDoList(),
      'title': MyApp.title,
    },
    {
      'page': const ToDoListCompleted(),
      'title': 'Completed ToDos',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pages[selectedPageIndex]['title'] as String),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPageIndex,
        onTap: (index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined, size: 27),
            label: 'ToDo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 27),
            label: 'Completed',
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Colors.black,
      ),
      body: pages[selectedPageIndex]['page'] as Widget,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CrudToDoScreen.routeName);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
