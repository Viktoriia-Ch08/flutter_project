import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_project/provider/todos.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_project/services/storage_service.dart';
import 'package:flutter_project/toast/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final currentUser = FirebaseAuth.instance.currentUser;
final uuid = Uuid();

class NewTodoForm extends ConsumerStatefulWidget {
  const NewTodoForm({super.key, this.todo});

  final TodoModel? todo;

  @override
  ConsumerState<NewTodoForm> createState() {
    return _NewTodoFormState();
  }
}

class _NewTodoFormState extends ConsumerState<NewTodoForm> {
  String? _enteredTitle;
  String? _enteredDescr;
  String _selectedStatus = StatusTitle.low.name;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  File? _chosenImage;
  String? _errorMessage;
  String? _networkImage;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _enteredTitle = widget.todo!.title;
      _enteredDescr = widget.todo!.description;
      _networkImage = widget.todo!.imageUrl!;
      _selectedStatus = widget.todo!.status!;
      _isEditing = true;
    }
  }

  void _onSave() async {
    if (_formKey.currentState!.validate() && currentUser != null) {
      setState(() {
        _errorMessage = null;
      });

      if (_chosenImage == null && _networkImage == null) {
        Toast(text: 'Choose image!').showError();
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        _formKey.currentState!.save();

        final uid = uuid.v4();

        final imageUrl = _chosenImage != null
            ? await StorageService().uploadTodoImage(_chosenImage, uid)
            : _networkImage;

        if (_isEditing) {
          _updateTodo(imageUrl);
          return;
        }

        _addTodo(imageUrl, uid);
      } on FirebaseException catch (err) {
        setState(() {
          isLoading = false;
        });
        Toast(text: err.message!);
      }
    }
  }

  void _addTodo(imageUrl, uid) {
    ref.read(todosProvider.notifier).addTodo(TodoModel(
        userId: currentUser!.uid,
        title: _enteredTitle,
        description: _enteredDescr,
        imageUrl: imageUrl,
        status: _selectedStatus,
        createdAt: Timestamp.now(),
        uid: uid));

    Navigator.of(context).pop();

    FirestoreService().addTodo({
      'userId': currentUser!.uid,
      'title': _enteredTitle,
      'description': _enteredDescr,
      'status': _selectedStatus,
      'imageUrl': imageUrl,
      'isDone': false,
      'uid': uid,
      'createdAt': Timestamp.now()
    }, uid);
  }

  void _updateTodo(imageUrl) {
    ref.read(todosProvider.notifier).updateTodo(TodoModel(
        userId: currentUser!.uid,
        title: _enteredTitle,
        description: _enteredDescr,
        imageUrl: imageUrl,
        status: _selectedStatus,
        uid: widget.todo!.uid,
        createdAt: Timestamp.now()));
    Navigator.of(context).pop();

    FirestoreService().updateTodo({
      'title': _enteredTitle,
      'description': _enteredDescr,
      'status': _selectedStatus,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now()
    }, widget.todo!.uid);
  }

  void _pickImage() async {
    final pickedImg = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImg == null) return;

    setState(() {
      _networkImage = null;
      _chosenImage = File(pickedImg.path);
    });
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {
      _chosenImage = null;
      _selectedStatus = StatusTitle.low.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white70)),
                  width: double.infinity,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_chosenImage != null || _networkImage != null)
                        Image(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          image: _networkImage != null && _chosenImage == null
                              ? NetworkImage(_networkImage!)
                              : FileImage(_chosenImage!),
                        ),
                      Positioned(
                        child: IconButton(
                            iconSize: 40,
                            color: Colors.white70,
                            onPressed: _pickImage,
                            icon: const Icon(Icons.camera_alt_outlined)),
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: widget.todo == null ? null : _enteredTitle,
                maxLength: 50,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length > 50) {
                    return 'Enter correct title.';
                  }
                  return null;
                },
                onSaved: (newValue) => _enteredTitle = newValue,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      border: _errorMessage == null
                          ? Border.all(color: Colors.white)
                          : Border.all(color: Colors.red)),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: TextFormField(
                          initialValue:
                              widget.todo == null ? null : _enteredDescr,
                          minLines: 5,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                              color: Colors.white, overflow: TextOverflow.clip),
                          decoration: const InputDecoration(
                              hintText: 'Write a description...',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              setState(() {
                                _errorMessage = 'Enter description.';
                              });
                              return '';
                            }

                            return null;
                          },
                          onSaved: (newValue) => _enteredDescr = newValue,
                        ),
                      ),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                        dropdownColor: Theme.of(context).colorScheme.secondary,
                        padding: const EdgeInsets.only(bottom: 20),
                        value: _selectedStatus,
                        items: [
                          for (final status in statusData)
                            DropdownMenuItem(
                                value: status.title.name,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black),
                                          color: status.color),
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      status.title.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        }),
                  ),
                  const SizedBox(width: 40),
                  TextButton(
                      onPressed: _reset,
                      child: const Text('Reset',
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton.icon(
                    onPressed: _onSave,
                    label: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(),
                          )
                        : null,
                    iconAlignment: IconAlignment.end,
                  )
                ],
              )
            ],
          )),
    );
  }
}
