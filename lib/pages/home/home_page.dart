import 'package:awesome_music/cubits/music_player_cubit.dart';
import 'package:awesome_music/pages/home/musics/musics_page.dart';
import 'package:awesome_music/pages/home/news/news_page.dart';
import 'package:awesome_music/pages/home/playlists/playlists_page.dart';
import 'package:awesome_music/widgets/music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 1;

  static final List<Widget> _pages = <Widget>[
    const NewsPage(),
    const MusicsPage(),
    const PlaylistsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedPage),
      ),
      bottomSheet: BlocBuilder<MusicPlayerCubit, MusicPlayerCubitState>(
          builder: (context, state) {
        return Offstage(
          offstage: state.playlist.isEmpty,
          child: Container(
            width: double.infinity,
            height: 112,
            padding: EdgeInsets.all(8.0),
            child: MusicPlayer(),
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: 'Notícias'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow), label: 'Músicas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlists',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedPage,
        onTap: _onItemTapped,
      ),
    );
  }
}
