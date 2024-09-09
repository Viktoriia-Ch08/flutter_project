import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm({super.key, required this.onSave});

  final Future<void> Function(String email, String password) onSave;

  @override
  State<AuthForm> createState() {
    return _AuthFormState();
  }
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredEmail;
  String? _enteredPassword;

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave(_enteredEmail!, _enteredPassword!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Enter valid email';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredEmail = newValue;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                enableSuggestions: false,
                obscureText: true,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.trim().length < 5) {
                    return 'Password must have min 5 chars';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredPassword = newValue;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              OutlinedButton(
                onPressed: _onSubmit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
