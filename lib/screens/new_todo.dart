import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_project/widgets/todo/new_todo_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTodo extends ConsumerStatefulWidget {
  const NewTodo({super.key, this.todo});

  final TodoModel? todo;

  @override
  ConsumerState<NewTodo> createState() {
    return _NewTodoState();
  }
}

class _NewTodoState extends ConsumerState<NewTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        appBar: AppBar(
          foregroundColor: Colors.white70,
          title: Text(
            widget.todo == null ? 'Create New Todo' : 'Edit Todo',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white70),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: NewTodoForm(todo: widget.todo)));
  }
}
