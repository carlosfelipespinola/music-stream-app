import 'package:awesome_music/services/api/api_client.dart';
import 'package:awesome_music/services/api/models/music.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MusicsCubitState {
  final List<Music> musics;

  MusicsCubitState({required this.musics});
}

class MusicsCubitStatePending extends MusicsCubitState {
  MusicsCubitStatePending({required super.musics});
}

class MusicsCubitStateError extends MusicsCubitState {
  MusicsCubitStateError({required super.musics});
}

class MusicsCubitStateSuccess extends MusicsCubitState {
  MusicsCubitStateSuccess({required super.musics});
}

class MusicsCubit extends Cubit<MusicsCubitState> {
  final ApiClient apiClient;

  MusicsCubit(MusicsCubitState initialState, {required this.apiClient})
      : super(initialState);

  void fetch() async {
    try {
      emit(MusicsCubitStatePending(
        musics: state.musics,
      ));
      final fetched = await apiClient.fetchMusics();
      emit(MusicsCubitStateSuccess(musics: fetched));
    } catch (_) {
      emit(MusicsCubitStateError(musics: state.musics));
    }
  }
}
