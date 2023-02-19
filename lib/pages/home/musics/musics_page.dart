import 'package:awesome_music/cubits/musics_cubit.dart';
import 'package:awesome_music/widgets/musics_cubit_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicsPage extends StatefulWidget {
  const MusicsPage({super.key});

  @override
  State<MusicsPage> createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage> {
  @override
  void didChangeDependencies() {
    context.read<MusicsCubit>().fetch();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Músicas'),
          centerTitle: true,
        ),
        body: const MusicsCubitBuilder());
  }
}
