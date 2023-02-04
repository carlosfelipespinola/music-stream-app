import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/api/models/music.dart';

class MusicPlayerCubitState {
  final List<Music> playlist;
  final int playingIndex;
  Music get currentPlayingMusic => playlist.elementAt(playingIndex);
  bool get hasNext => playingIndex < playlist.length - 1;

  MusicPlayerCubitState({required this.playlist, required this.playingIndex});
}

class MusicPlayerCubit extends Cubit<MusicPlayerCubitState> {
  MusicPlayerCubit(super.initialState);

  void setPlayList(List<Music> playList) {}

  void play(List<Music> playList, int startAtIndex) {
    emit(MusicPlayerCubitState(
      playlist: playList,
      playingIndex: startAtIndex,
    ));
  }

  void next() {
    emit(MusicPlayerCubitState(
        playlist: state.playlist, playingIndex: state.playingIndex + 1));
  }

  void setPlayingIndex(int index) {
    emit(MusicPlayerCubitState(playlist: state.playlist, playingIndex: index));
  }

  void stopAndClearPlaylist() {
    emit(MusicPlayerCubitState(playlist: [], playingIndex: 0));
  }
}
