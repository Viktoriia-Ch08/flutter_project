import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/provider/todos.dart';
import 'package:flutter_project/provider/user.dart';
import 'package:flutter_project/screens/auth.dart';
import 'package:flutter_project/screens/new_todo.dart';
import 'package:flutter_project/screens/profile.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_project/widgets/todos/todos_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() {
    return _TodosScreenState();
  }
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  bool isLoading = false;
  User? currentUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _setUserData();
  }

  void _setUserData() async {
    final storageUser = await FirestoreService().getUser(currentUser!.uid);

    if (storageUser == null) return;

    ref.read(userProvider.notifier).getUser(storageUser);
  }

  void _logout() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    ref.read(userProvider.notifier).logout();
    ref.read(todosProvider.notifier).logout();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const AuthScreen()));
  }

  void _addTodo() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewTodo()));
  }

  void _selectPage(i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const TodosList();

    if (_selectedIndex == 1) {
      content = const Profile();
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              title: Text(_selectedIndex == 0 ? 'Todo List' : 'Profile',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white70)),
              actions: [
                IconButton(
                    onPressed: _addTodo,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white70,
                    )),
                IconButton(
                    onPressed: _logout,
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white70,
                    ))
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                onTap: (i) => _selectPage(i),
                currentIndex: _selectedIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list_outlined), label: 'Todo List'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_4_outlined), label: 'Profile'),
                ]),
            body: content);
  }
}
