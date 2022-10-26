import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/crud_todo_screen.dart';
import '../screens/todo_main_screen.dart';

import '../providers/ToDoProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'My ToDo App';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ToDoProvider(),
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
              .copyWith(secondary: Colors.white70),
          scaffoldBackgroundColor: Colors.blueGrey,
        ),
        home: const ToDoMainScreen(),
        initialRoute: '/',
        routes: {
          CrudToDoScreen.routeName: (ctx) => const CrudToDoScreen(
                isEdit: false,
              ),
        },
      ),
    );
  }
}
