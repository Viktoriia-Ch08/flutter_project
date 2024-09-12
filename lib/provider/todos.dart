import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosNotifier extends StateNotifier<List<TodoModel>> {
  TodosNotifier() : super([]);

  void addTodo(todo) {
    // final newTodo = TodoModel.fromJSON(todo);
    print('newTodo 2');
    // print(newTodo);
    state = [...state, todo];
  }

  void getTodos(storageTodos) {
    state = TodosList.fromJSON(storageTodos).todos ?? [];
  }

  void logout() {
    state = [];
  }

  void deleteTodo(String uid) {
    state = [...state.where((item) => item.uid != uid)];
  }

  void updateTodo(TodoModel todo) {
    state = [
      ...state.map((el) {
        if (el.uid == todo.uid) return todo;
        return el;
      }),
    ];
  }

  void updateIsDone(String uid) {
    state = [
      ...state.map((el) {
        if (el.uid == uid) {
          el.isDone = !el.isDone;
          return el;
        }
        return el;
      }),
    ];
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<TodoModel>>(
    (ref) => TodosNotifier());
