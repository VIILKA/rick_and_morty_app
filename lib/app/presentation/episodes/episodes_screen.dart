import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/app/domain/entities/episode.dart';
import 'bloc/episodes_bloc.dart';
import 'bloc/episodes_event.dart';
import 'bloc/episodes_state.dart';

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
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

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
                    const SizedBox(height: 8),
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
              final isLoadingPage =
                  (state.status == EpisodesStatus.loadingPage);
              final eps = state.episodes;
              return isWide
                  ? _buildGrid(eps, isLoadingPage)
                  : _buildList(eps, isLoadingPage);
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildList(List<Episode> episodes, bool isLoadingPage) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: episodes.length + (isLoadingPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < episodes.length) {
          final e = episodes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title:
                  Text(e.name, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text("${e.episode} | ${e.airDate}"),
              onTap: () => context.go('/episodes/details/${e.id}'),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildGrid(List<Episode> episodes, bool isLoadingPage) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: episodes.length + (isLoadingPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < episodes.length) {
          final e = episodes[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.go('/episodes/details/${e.id}'),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text("${e.episode} | ${e.airDate}"),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
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
