import 'package:awesome_music/cubits/auth_cubit.dart';
import 'package:awesome_music/navigator.dart';
import 'package:awesome_music/pages/auth/login/login_page.dart';
import 'package:awesome_music/pages/auth/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void didChangeDependencies() {
    context.read<AuthCubit>().checkAuthenticationState();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listenWhen: (oldState, newState) =>
          oldState is AuthCubitStatePending &&
          newState is AuthCubitStateSuccess &&
          newState.isAuthenticated,
      listener: (context, state) => onAuthenticated(context),
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(tabs: [
                Tab(
                  text: 'Login',
                ),
                Tab(
                  text: 'Registro',
                )
              ]),
            ),
            body: const TabBarView(children: [LoginPage(), RegisterPage()]),
          )),
    );
  }

  void onAuthenticated(BuildContext context) => AppNavigator.toHome(context);
}
