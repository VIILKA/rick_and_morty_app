import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/app/domain/entities/episode.dart';
import 'package:rick_and_morty_app/app/presentation/episodes/bloc/episodes_bloc.dart';
import 'package:rick_and_morty_app/app/presentation/episodes/bloc/episodes_event.dart';
import 'package:rick_and_morty_app/app/presentation/episodes/bloc/episodes_state.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({super.key});

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final bloc = context.read<EpisodesBloc>();
    if (bloc.state.episodes.isEmpty) {
      bloc.add(LoadEpisodesEvent());
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent * 0.9) {
      context.read<EpisodesBloc>().add(LoadNextEpisodesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Эпизоды"),
      ),
      body: BlocBuilder<EpisodesBloc, EpisodesState>(
        builder: (context, state) {
          switch (state.status) {
            case EpisodesStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case EpisodesStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ошибка: ${state.errorMessage}"),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EpisodesBloc>().add(LoadEpisodesEvent());
                      },
                      child: const Text("Повторить"),
                    ),
                  ],
                ),
              );
            case EpisodesStatus.empty:
              return const Center(child: Text("Нет результатов"));
            case EpisodesStatus.loaded:
            case EpisodesStatus.loadingPage:
              return _buildList(
                episodes: state.episodes,
                isLoadingPage: state.status == EpisodesStatus.loadingPage,
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildList({
    required List<Episode> episodes,
    required bool isLoadingPage,
  }) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: episodes.length + 1,
      itemBuilder: (context, index) {
        if (index < episodes.length) {
          final e = episodes[index];
          return ListTile(
            title: Text(e.name),
            subtitle: Text("${e.episode} | ${e.airDate}"),
            onTap: () {
              context.go('/episodes/details/${e.id}');
            },
          );
        } else {
          // Последняя ячейка: индикатор, если догружаем
          if (isLoadingPage) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
