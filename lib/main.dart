import 'package:awesome_music/cubits/auth_cubit.dart';
import 'package:awesome_music/cubits/music_player_cubit.dart';
import 'package:awesome_music/cubits/musics_cubit.dart';
import 'package:awesome_music/pages/auth/auth_page.dart';
import 'package:awesome_music/services/api/api_client.dart';
import 'package:awesome_music/services/local_storage_service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(
            create: (_) =>
                ApiClient(localStorageService: LocalStorageService.create()))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(AuthCubitStateSuccess(null),
                  apiClient: RepositoryProvider.of<ApiClient>(context))),
          BlocProvider<MusicsCubit>(
              create: (context) => MusicsCubit(
                  MusicsCubitStateSuccess(musics: []),
                  apiClient: RepositoryProvider.of<ApiClient>(context))
                ..fetch()),
          BlocProvider<MusicPlayerCubit>(
              create: (context) => MusicPlayerCubit(
                  MusicPlayerCubitState(playlist: [], playingIndex: 0)))
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(useMaterial3: true),
          darkTheme: ThemeData.dark().copyWith(
              useMaterial3: true,
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                backgroundColor: ThemeData.dark().colorScheme.secondary,
                foregroundColor: ThemeData.dark().colorScheme.onSecondary,
              )),
              inputDecorationTheme: ThemeData.dark()
                  .inputDecorationTheme
                  .copyWith(border: const OutlineInputBorder())),
          themeMode: ThemeMode.dark,
          home: const AuthPage(),
        ),
      ),
    );
  }
}
