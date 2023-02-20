import 'package:awesome_music/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _LoginForm(),
                ))),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text('Email')),
            onChanged: (value) => email = value,
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(label: Text('Senha')),
            onChanged: (value) => password = value,
          ),
          const SizedBox(
            height: 12,
          ),
          BlocConsumer<AuthCubit, AuthCubitState>(
              listenWhen: (previous, current) =>
                  previous is! AuthCubitStateError &&
                  current is AuthCubitStateError,
              listener: (context, state) => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                      content: Text("Ocorreu um erro ao fazer login"))),
              builder: (context, state) {
                if (state is AuthCubitStatePending) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                    onPressed: () => _login(context),
                    child: Text('Login'.toUpperCase()));
              })
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    context.read<AuthCubit>().authenticate(email, password);
  }
}
