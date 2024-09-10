import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_project/provider/todos.dart';
import 'package:flutter_project/screens/todo_details.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_project/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosList extends ConsumerStatefulWidget {
  const TodosList({super.key});

  @override
  ConsumerState<TodosList> createState() {
    return _TodosListState();
  }
}

class _TodosListState extends ConsumerState<TodosList> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _setTodos();
  }

  void _setTodos() async {
    final storageTodos = await FirestoreService().getTodos(currentUser!.uid);

    if (storageTodos.isEmpty) return;

    ref.read(todosProvider.notifier).getTodos(storageTodos);
  }

  Color? _setColor(String status) {
    return statusData.where((el) => el.title.name == status).single.color;
  }

  void _deleteTodo(String uid, int i) {
    ref.read(todosProvider.notifier).deleteTodo(uid);
    FirestoreService().deleteTodo(uid);
    StorageService().deleteTodoImage(uid);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todo was deleted'),
      ),
    );
  }

  void _openTodoDetails(todoUid) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => TodoDetails(todoUid: todoUid)));
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosProvider);
    Widget content = const Center(child: Text('No todos found'));

    if (todos.isNotEmpty) {
      content = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: todos.length,
        itemBuilder: ((ctx, i) => GestureDetector(
              onTap: () {
                _openTodoDetails(todos[i].uid);
              },
              child: Dismissible(
                  onDismissed: (direction) {
                    _deleteTodo(todos[i].uid!, i);
                  },
                  key: ValueKey(todos[i].uid),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            boxShadow: List.filled(
                                1,
                                const BoxShadow(
                                    blurRadius: 3, spreadRadius: 1)),
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(todos[i].imageUrl!),
                              fit: BoxFit.cover,
                            )),
                        child: ListTile(
                          title: Text(
                            textAlign: TextAlign.center,
                            todos[i].title!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          subtitle: Text(
                            textAlign: TextAlign.center,
                            todos[i].description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _setColor(todos[i].status!)),
                            width: 20,
                            height: 20,
                          )),
                    ],
                  )),
            )),
      );
    }

    return content;
  }
}
