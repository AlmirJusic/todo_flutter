import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import '../providers/ToDoProvider.dart';

class CrudToDoScreen extends StatefulWidget {
  static const routeName = '/crud-todo';
  final Todo? todo;
  final bool isEdit;
  const CrudToDoScreen({this.todo, required this.isEdit, super.key});

  @override
  State<CrudToDoScreen> createState() => _CrudToDoScreenState();
}

class _CrudToDoScreenState extends State<CrudToDoScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String? description = '';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      title = widget.todo!.title;
      description = widget.todo!.description;
    }
  }

  Future<void> saveForm() async {
    final isValid = _formKey.currentState!.validate();
    final provider = Provider.of<ToDoProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    if (!isValid) {
      return;
    } else if (widget.isEdit) {
      await provider.updateToDo(
          widget.todo!.id, title, description!, widget.todo!);
      navigator.pop();
    } else {
      final todo = Todo(
        createdTime: DateTime.now(),
        title: title,
        id: DateTime.now().toString(),
        description: description,
      );

      try {
        await provider.addToDo(todo);
      } catch (e) {
        rethrow;
      }

      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerToDo = Provider.of<ToDoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit ? const Text('Edit Todo') : const Text('Add Todo'),
        actions: [
          Visibility(
            visible: widget.isEdit,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                providerToDo.removeToDo(widget.todo!.id);

                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 1,
                    initialValue: title,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: UnderlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: 3,
                    initialValue: description,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveForm,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
