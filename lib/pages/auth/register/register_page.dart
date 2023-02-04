import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _RegisterForm(),
                ))),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(label: Text('Nome')),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          decoration: const InputDecoration(label: Text('Email')),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(label: Text('Senha')),
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
            onPressed: () => _register(context),
            child: Text('Registrar'.toUpperCase()))
      ],
    ));
  }

  void _register(BuildContext context) =>
      DefaultTabController.of(context)!.animateTo(0);
}
