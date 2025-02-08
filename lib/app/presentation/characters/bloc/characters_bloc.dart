import 'package:flutter_bloc/flutter_bloc.dart';
import 'characters_event.dart';
import 'characters_state.dart';
import '../../../domain/repositories/character_repository.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharacterRepository repository;

  CharactersBloc(this.repository) : super(CharactersState.initial()) {
    on<LoadCharactersEvent>(_onLoadCharacters);
    on<LoadNextPageEvent>(_onLoadNextPage);
    on<ApplyFilterEvent>(_onApplyFilter);
  }

  Future<void> _onLoadCharacters(
    LoadCharactersEvent event,
    Emitter<CharactersState> emit,
  ) async {
    if (state.status == CharactersStatus.loaded &&
        state.characters.isNotEmpty &&
        state.filter == state.lastLoadedFilter) {
      return;
    }

    try {
      emit(state.copyWith(
        status: CharactersStatus.loading,
        characters: [],
        page: 1,
      ));

      final (results, hasNext) = await repository.getCharacters(
        1,
        filter: state.filter,
      );

      if (results.isEmpty) {
        emit(state.copyWith(
          status: CharactersStatus.empty,
          page: 1,
          hasNextPage: false,
          characters: [],
        ));
      } else {
        emit(state.copyWith(
          status: CharactersStatus.loaded,
          page: 1,
          hasNextPage: hasNext,
          characters: results,
          lastLoadedFilter: state.filter,
        ));
      }
    } catch (e) {
      // Если ошибка
      emit(state.copyWith(
        status: CharactersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadNextPage(
    LoadNextPageEvent event,
    Emitter<CharactersState> emit,
  ) async {
    if (!state.hasNextPage || state.status == CharactersStatus.loadingPage) {
      return;
    }

    try {
      emit(state.copyWith(status: CharactersStatus.loadingPage));

      final nextPage = state.page + 1;

      final (results, hasNext) = await repository.getCharacters(
        nextPage,
        filter: state.filter,
      );

      if (results.isEmpty) {
        emit(state.copyWith(
          hasNextPage: false,
          status: CharactersStatus.loaded,
        ));
      } else {
        final updated = [...state.characters, ...results];
        emit(state.copyWith(
          status: CharactersStatus.loaded,
          page: nextPage,
          hasNextPage: hasNext,
          characters: updated,
          lastLoadedFilter: state.filter,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onApplyFilter(
    ApplyFilterEvent event,
    Emitter<CharactersState> emit,
  ) async {
    emit(state.copyWith(filter: event.filter));

    add(LoadCharactersEvent());
  }
}
