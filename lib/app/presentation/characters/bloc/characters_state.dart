import 'package:equatable/equatable.dart';
import '../../../domain/entities/character.dart';
import '../../../domain/entities/filters/character_filter.dart';

enum CharactersStatus { initial, loading, loadingPage, loaded, empty, error }

class CharactersState extends Equatable {
  final CharactersStatus status;
  final List<Character> characters;
  final int page;
  final bool hasNextPage;
  final CharacterFilter? filter;
  final String? errorMessage;

  // Новое поле: фильтр, по которому мы последний раз УСПЕШНО загрузили данные.
  final CharacterFilter? lastLoadedFilter;

  const CharactersState({
    required this.status,
    required this.characters,
    required this.page,
    required this.hasNextPage,
    required this.filter,
    this.errorMessage,
    this.lastLoadedFilter,
  });

  factory CharactersState.initial() {
    return const CharactersState(
      status: CharactersStatus.initial,
      characters: [],
      page: 1,
      hasNextPage: true,
      filter: null,
      errorMessage: null,
      lastLoadedFilter: null,
    );
  }

  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? characters,
    int? page,
    bool? hasNextPage,
    CharacterFilter? filter,
    String? errorMessage,
    CharacterFilter? lastLoadedFilter,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
      lastLoadedFilter: lastLoadedFilter ?? this.lastLoadedFilter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        characters,
        page,
        hasNextPage,
        filter,
        errorMessage,
        lastLoadedFilter,
      ];
}
