import 'package:audio_session/audio_session.dart';
import 'package:awesome_music/cubits/music_player_cubit.dart';
import 'package:awesome_music/services/api/models/music.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class PositionData {
  Duration duration;
  Duration position;
  Duration bufferedPosition;

  PositionData(this.duration, this.position, this.bufferedPosition);
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> with WidgetsBindingObserver {
  final _player = AudioPlayer();

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              duration ?? Duration.zero, position, bufferedPosition));

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MusicPlayerCubit, MusicPlayerCubitState>(
            listenWhen: (previous, current) {
          return previous.playlist != current.playlist;
        }, listener: (context, state) {
          onPlaylistChanged(state.playlist, state.playingIndex);
        }),
        BlocListener<MusicPlayerCubit, MusicPlayerCubitState>(
            listenWhen: (previous, current) =>
                previous.playlist == current.playlist &&
                previous.playlist.length < current.playlist.length,
            listener: (context, state) {
              onPlaylistIncreased();
            }),
        BlocListener<MusicPlayerCubit, MusicPlayerCubitState>(
            listenWhen: (previous, current) =>
                previous.playlist == current.playlist &&
                previous.playingIndex != current.playingIndex,
            listener: (context, state) {
              onIndexRequest(state.playingIndex);
            })
      ],
      child: Column(
        children: [
          ControlButtons(_player),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                total: positionData?.duration ?? Duration.zero,
                progress: positionData?.position ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                onSeek: _player.seek,
                baseBarColor:
                    Theme.of(context).colorScheme.secondary.withAlpha(50),
                bufferedBarColor:
                    Theme.of(context).colorScheme.secondary.withAlpha(150),
                progressBarColor: Theme.of(context).colorScheme.secondary,
                thumbColor: Theme.of(context).colorScheme.secondary,
                barHeight: 2,
                thumbRadius: 4,
              );
            },
          ),
        ],
      ),
    );
  }

  void onIndexRequest(int index) async {
    try {
      if (_player.currentIndex != index) {
        await _player.seek(const Duration(), index: index);
      }
    } catch (_) {
      _player.stop();
    }
  }

  void onPlaylistIncreased() {}

  void onPlaylistChanged(List<Music> playlist, int initialIndex) async {
    try {
      if (playlist.isEmpty) {
        return;
      }
      await _player.stop();
      await _player.setVolume(1.0);
      await _player.setAudioSource(
          ConcatenatingAudioSource(
              shuffleOrder: DefaultShuffleOrder(),
              children: playlist.map((e) {
                print(e.audioUrl);
                return AudioSource.uri(Uri.parse(e.audioUrl));
              }).toList()),
          initialIndex: initialIndex,
          preload: true);
      await _player.play();
    } catch (e) {
      print(e);
      _player.stop();
      showErrorMessage();
    }
  }

  @override
  void initState() {
    super.initState();
    // ambiguate(WidgetsBinding.instance)!.addObserver(this);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _player.currentIndexStream.listen((index) {
      if (index == null) {
        return;
      }
      context.read<MusicPlayerCubit>().setPlayingIndex(index);
    });
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      showErrorMessage();
    });
  }

  void showErrorMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Ocorreu um erro ao reproduzir a música")));
    }
  }

  @override
  void dispose() {
    // ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerCubit, MusicPlayerCubitState>(
        builder: (context, state) {
      if (state.playlist.isEmpty) {
        return Container();
      }
      return ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 64.0,
                    height: 64.0,
                    child: const CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 32.0,
                    onPressed: player.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 32.0,
                    onPressed: player.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 32.0,
                    onPressed: () => player.seek(Duration.zero),
                  );
                }
              },
            ),
            if (state.hasNext) ...[
              const SizedBox(
                width: 8,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                iconSize: 32.0,
                onPressed: () => context.read<MusicPlayerCubit>().next(),
              )
            ]
          ],
        ),
        title: Text(state.currentPlayingMusic.name),
        subtitle: Text(state.currentPlayingMusic.name),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      );
    });
  }
}
