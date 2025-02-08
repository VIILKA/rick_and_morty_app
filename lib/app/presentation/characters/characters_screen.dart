import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/app/domain/entities/character.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';

import 'character_filter_bottom_sheet.dart';
import 'bloc/characters_bloc.dart';
import 'bloc/characters_event.dart';
import 'bloc/characters_state.dart';

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
                    ElevatedButton(
                      onPressed: () => context
                          .read<CharactersBloc>()
                          .add(LoadCharactersEvent()),
                      child: const Text("Повторить"),
                    ),
                  ],
                ),
              );
            case CharactersStatus.empty:
              return const Center(child: Text("Нет результатов"));
            case CharactersStatus.loaded:
            case CharactersStatus.loadingPage:
              return _buildList(
                characters: state.characters,
                isLoadingPage: state.status == CharactersStatus.loadingPage,
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildList({
    required List<Character> characters,
    required bool isLoadingPage,
  }) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: characters.length + 1,
      itemBuilder: (context, index) {
        if (index < characters.length) {
          final c = characters[index];
          return ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl: c.image,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/no_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(c.name),
            subtitle: Text("${c.status} | ${c.species}"),
            onTap: () {
              // переход на детальную страницу, если есть
              context.go('/characters/details/${c.id}');
            },
          );
        } else {
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

  void _showFilterBottomSheet() {
    // Берём текущий фильтр из BLoC state
    final currentFilter =
        context.read<CharactersBloc>().state.filter ?? const CharacterFilter();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return CharacterFilterBottomSheet(
          currentFilter: currentFilter,
          onApply: (filter) {
            Navigator.pop(context);
            // отправляем событие "применить"
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
