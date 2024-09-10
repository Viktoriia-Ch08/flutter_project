import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosNotifier extends StateNotifier<List<TodoModel>> {
  TodosNotifier() : super([]);

  void addTodo(TodoModel todo) {
    state = [...state, todo];
  }

  void getTodos(List<TodoModel> todos) {
    state = [...todos];
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
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<TodoModel>>(
    (ref) => TodosNotifier());
