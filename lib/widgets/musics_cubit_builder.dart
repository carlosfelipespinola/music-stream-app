import 'package:awesome_music/cubits/music_player_cubit.dart';
import 'package:awesome_music/cubits/musics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicsCubitBuilder extends StatelessWidget {
  const MusicsCubitBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicsCubit, MusicsCubitState>(
        builder: (context, state) {
      if (state is MusicsCubitStatePending) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is MusicsCubitStateError && state.musics.isEmpty) {
        return const Center(
          child: Text("Ocorreu um erro"),
        );
      }
      return ListView.builder(
          itemCount: state.musics.length,
          itemBuilder: (context, index) {
            final music = state.musics.elementAt(index);
            return ListTile(
              onTap: () =>
                  context.read<MusicPlayerCubit>().play(state.musics, index),
              leading: CircleAvatar(
                radius: 32,
                foregroundImage: NetworkImage(music.imageUrl),
              ),
              title: Text(music.name),
              subtitle: const Text("3 Doors Down, Foo Fighters, Linkin Park"),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            );
          });
    });
  }
}
