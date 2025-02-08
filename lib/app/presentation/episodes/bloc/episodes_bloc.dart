import 'package:flutter_bloc/flutter_bloc.dart';
import 'episodes_event.dart';
import 'episodes_state.dart';
import '../../../domain/repositories/episode_repository.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final EpisodeRepository repository;

  EpisodesBloc(this.repository) : super(EpisodesState.initial()) {
    on<LoadEpisodesEvent>(_onLoadEpisodes);
    on<LoadNextEpisodesEvent>(_onLoadNextEpisodes);
  }

  Future<void> _onLoadEpisodes(
    LoadEpisodesEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    try {
      emit(state.copyWith(
          status: EpisodesStatus.loading, episodes: [], page: 1));
      final (list, hasNext) = await repository.getEpisodes(1);

      if (list.isEmpty) {
        emit(state.copyWith(
          status: EpisodesStatus.empty,
          page: 1,
          hasNextPage: false,
          episodes: [],
        ));
      } else {
        emit(state.copyWith(
          status: EpisodesStatus.loaded,
          page: 1,
          hasNextPage: hasNext,
          episodes: list,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: EpisodesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadNextEpisodes(
    LoadNextEpisodesEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    if (!state.hasNextPage || state.status == EpisodesStatus.loadingPage) {
      return;
    }

    try {
      emit(state.copyWith(status: EpisodesStatus.loadingPage));
      final nextPage = state.page + 1;

      final (list, hasNext) = await repository.getEpisodes(nextPage);
      if (list.isEmpty) {
        emit(state.copyWith(
          status: EpisodesStatus.loaded,
          hasNextPage: false,
        ));
      } else {
        final updated = [...state.episodes, ...list];
        emit(state.copyWith(
          status: EpisodesStatus.loaded,
          page: nextPage,
          hasNextPage: hasNext,
          episodes: updated,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: EpisodesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
