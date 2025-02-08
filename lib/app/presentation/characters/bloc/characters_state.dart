// lib/app/presentation/characters/bloc/characters_state.dart

import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';
import '../../../domain/entities/character.dart';

enum CharactersStatus { initial, loading, loadingPage, loaded, empty, error }

class CharactersState extends Equatable {
  final CharactersStatus status;
  final List<Character> characters;
  final int page;
  final bool hasNextPage;
  final CharacterFilter? filter;
  final String? errorMessage;

  const CharactersState({
    required this.status,
    required this.characters,
    required this.page,
    required this.hasNextPage,
    required this.filter,
    this.errorMessage,
  });

  factory CharactersState.initial() {
    return CharactersState(
      status: CharactersStatus.initial,
      characters: const [],
      page: 1,
      hasNextPage: true,
      filter: null,
    );
  }

  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? characters,
    int? page,
    bool? hasNextPage,
    CharacterFilter? filter,
    String? errorMessage,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, characters, page, hasNextPage, filter, errorMessage];
}
