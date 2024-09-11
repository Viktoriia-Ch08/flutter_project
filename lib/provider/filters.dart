import 'package:flutter_project/models/filters_model.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_project/provider/todos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersNotifier extends StateNotifier<FiltersModel> {
  FiltersNotifier()
      : super(const FiltersModel(
            isDone: false, isOldFirst: false, status: FilterStatus.all));

  void updateStatus(FilterStatus newStatus) {
    state = state.copyWith(status: newStatus);
  }

  void toggleIsDone() {
    state = state.copyWith(isDone: !state.isDone);
  }

  void toggleIsOldFirst() {
    state = state.copyWith(isOldFirst: !state.isOldFirst);
  }

  List<TodoModel> filter(List<TodoModel> todos) {
    print(state.isOldFirst);
    if (state.isOldFirst) {
      todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return todos;
    }
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todos;
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, FiltersModel>(
    (ref) => FiltersNotifier());

final filteredTodosProvider = Provider((ref) {
  final todos = ref.watch(todosProvider);
  final activeFilters = ref.watch(filtersProvider);

  final filteredTodos = todos.where((todo) {
    if (activeFilters.isDone && !todo.isDone) {
      return false;
    }
    if (activeFilters.status == FilterStatus.all) {
      return true;
    }
    if (activeFilters.status.name != todo.status) {
      return false;
    }
    return true;
  }).toList();

  if (activeFilters.isOldFirst) {
    filteredTodos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return filteredTodos;
  }

  filteredTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return filteredTodos;
});
