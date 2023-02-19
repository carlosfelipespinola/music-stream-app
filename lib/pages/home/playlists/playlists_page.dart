import 'package:awesome_music/cubits/musics_cubit.dart';
import 'package:awesome_music/widgets/musics_cubit_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  @override
  void didChangeDependencies() {
    context.read<MusicsCubit>().fetch();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Playlists'),
          centerTitle: true,
        ),
        body: const MusicsCubitBuilder());
  }
}
