import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_project/provider/todos.dart';
import 'package:flutter_project/screens/new_todo.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoDetails extends ConsumerStatefulWidget {
  const TodoDetails({super.key, required this.todoUid});

  final String todoUid;

  @override
  ConsumerState<TodoDetails> createState() {
    return _TodoDetailsState();
  }
}

class _TodoDetailsState extends ConsumerState<TodoDetails> {
  int? lines = 3;

  void _viewMore() {
    if (lines == null) {
      setState(() {
        lines = 3;
      });
      return;
    }
    setState(() {
      lines = null;
    });
  }

  Color _getStatusColor(String status) {
    return statusData.where((el) => el.title.name == status).single.color;
  }

  void _editTodo(TodoModel todo) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewTodo(todo: todo)));
  }

  void _updateIsDone(bool isDone, String uid) {
    ref.read(todosProvider.notifier).updateIsDone(uid);

    FirestoreService().updateIsDone(isDone, uid);
  }

  @override
  Widget build(BuildContext context) {
    final todo = ref
        .watch(todosProvider)
        .where((el) => el.uid == widget.todoUid)
        .toList()[0];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Todo details'),
        actions: [
          IconButton(
              onPressed: () {
                _editTodo(todo);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black54,
              ))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(todo.imageUrl!), fit: BoxFit.cover)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
                top: 25,
                right: 15,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: _getStatusColor(todo.status!),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          todo.status!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white70),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                            todo.isDone == true
                                ? Icons.done
                                : Icons.work_history_outlined,
                            color: Colors.white70),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(todo.isDone == true ? 'Done' : 'In progress',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white70))
                      ],
                    ),
                    Switch(
                      value: todo.isDone,
                      onChanged: (isChecked) =>
                          _updateIsDone(isChecked, todo.uid!),
                    )
                  ],
                )),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              height: lines == null ? double.infinity : 200,
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.9)),
              child: Column(
                children: [
                  Text(
                    todo.title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Text(
                    todo.description!,
                    maxLines: lines,
                    overflow: lines == null ? null : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
                  
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: _viewMore,
                      style: ButtonStyle(
                          side: WidgetStateProperty.all(const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid))),
                      child: Text(
                        lines == null ? 'Hide' : 'View more',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
