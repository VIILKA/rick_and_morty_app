import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/app/domain/entities/character.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';
import 'bloc/characters_bloc.dart';
import 'bloc/characters_event.dart';
import 'bloc/characters_state.dart';
import 'character_filter_bottom_sheet.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CharactersBloc>().add(LoadCharactersEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent * 0.9) {
      context.read<CharactersBloc>().add(LoadNextPageEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Герои"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          switch (state.status) {
            case CharactersStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CharactersStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ошибка: ${state.errorMessage}"),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<CharactersBloc>()
                            .add(LoadCharactersEvent());
                      },
                      child: const Text("Повторить"),
                    ),
                  ],
                ),
              );
            case CharactersStatus.empty:
              return const Center(child: Text("Нет результатов"));
            case CharactersStatus.loaded:
            case CharactersStatus.loadingPage:
              final isLoadingPage =
                  (state.status == CharactersStatus.loadingPage);
              final characters = state.characters;
              return isWide
                  ? _buildGrid(characters, isLoadingPage)
                  : _buildList(characters, isLoadingPage);
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildList(List<Character> characters, bool isLoadingPage) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: characters.length + (isLoadingPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < characters.length) {
          final c = characters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: c.image,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/no_image.png',
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              title: Text(
                c.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text("${c.status} | ${c.species}"),
              onTap: () => context.go('/characters/details/${c.id}'),
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

  Widget _buildGrid(List<Character> characters, bool isLoadingPage) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: characters.length + (isLoadingPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < characters.length) {
          final c = characters[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.go('/characters/details/${c.id}'),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: c.image,
                      width: 80,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => const SizedBox(
                        width: 80,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (ctx, url, error) => Image.asset(
                        'assets/images/no_image.png',
                        fit: BoxFit.cover,
                        width: 80,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            c.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text("${c.status} | ${c.species}", maxLines: 1),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _showFilterBottomSheet() {
    final currentFilter =
        context.read<CharactersBloc>().state.filter ?? const CharacterFilter();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return CharacterFilterBottomSheet(
          currentFilter: currentFilter,
          onApply: (filter) {
            Navigator.pop(context);
            context.read<CharactersBloc>().add(ApplyFilterEvent(filter));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
