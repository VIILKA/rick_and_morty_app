// lib/app/presentation/characters/bloc/characters_bloc.dart

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
    // 1. Если уже есть данные, не перезагружаем заново:
    if (state.status == CharactersStatus.loaded &&
        state.characters.isNotEmpty) {
      return;
    }

    try {
      emit(state.copyWith(
        status: CharactersStatus.loading,
        characters: [],
        page: 1,
      ));

      // Получаем (список, hasNext) с первой страницы
      final (results, hasNext) = await repository.getCharacters(
        1,
        filter: state.filter,
      );

      if (results.isEmpty) {
        // Если пусто - значит вообще нет результатов
        emit(state.copyWith(
          status: CharactersStatus.empty,
          page: 1,
          hasNextPage: false,
          characters: [],
        ));
      } else {
        // Иначе обновляем state
        emit(state.copyWith(
          status: CharactersStatus.loaded,
          page: 1,
          hasNextPage: hasNext,
          characters: results,
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
    // Если next-страницы нет или уже идёт загрузка
    if (!state.hasNextPage || state.status == CharactersStatus.loadingPage) {
      return;
    }

    try {
      // Ставим state: догружаем
      emit(state.copyWith(status: CharactersStatus.loadingPage));

      final nextPage = state.page + 1;

      // Получаем (список, hasNext) со следующей страницы
      final (results, hasNext) = await repository.getCharacters(
        nextPage,
        filter: state.filter,
      );

      if (results.isEmpty) {
        // Значит страниц больше нет
        emit(state.copyWith(
          hasNextPage: false,
          status: CharactersStatus.loaded,
        ));
      } else {
        // Дополняем общий список
        final updated = [...state.characters, ...results];
        emit(state.copyWith(
          status: CharactersStatus.loaded,
          page: nextPage,
          hasNextPage: hasNext,
          characters: updated,
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
    // Запоминаем фильтр
    emit(state.copyWith(filter: event.filter));
    // Перезапускаем загрузку с 1-й страницы
    add(LoadCharactersEvent());
  }
}
