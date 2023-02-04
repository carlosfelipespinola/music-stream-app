import 'package:awesome_music/cubits/musics_cubit.dart';
import 'package:awesome_music/widgets/musics_cubit_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicsPage extends StatefulWidget {
  const MusicsPage({super.key});

  @override
  State<MusicsPage> createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage>
    with SingleTickerProviderStateMixin {
  final tabs = const [
    Tab(
      text: "Eletro",
    ),
    Tab(
      text: "Clássicas",
    ),
    Tab(
      text: "Rock",
    ),
    Tab(
      text: "Pop",
    ),
    Tab(
      text: "Sertanejo",
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(tabControllerListener);
    super.initState();
  }

  void tabControllerListener() {
    if (_tabController.indexIsChanging) {
      return;
    }
    if (_tabController.previousIndex == _tabController.index) {
      return;
    }
    context.read<MusicsCubit>().fetch();
  }

  @override
  void didChangeDependencies() {
    context.read<MusicsCubit>().fetch();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Músicas'),
          bottom: TabBar(
            tabs: tabs,
            controller: _tabController,
          ),
        ),
        body: const MusicsCubitBuilder());
  }
}
