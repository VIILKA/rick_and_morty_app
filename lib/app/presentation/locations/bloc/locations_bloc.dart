import 'package:flutter_bloc/flutter_bloc.dart';

import 'locations_event.dart';
import 'locations_state.dart';
import '../../../domain/repositories/location_repository.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationRepository repository;

  LocationsBloc(this.repository) : super(LocationsState.initial()) {
    on<LoadLocationsEvent>(_onLoadLocations);
    on<LoadNextLocationsEvent>(_onLoadNextLocations);
  }

  Future<void> _onLoadLocations(
    LoadLocationsEvent event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: LocationsStatus.loading,
        locations: [],
        page: 1,
      ));

      final (list, hasNext) = await repository.getLocations(1);

      if (list.isEmpty) {
        emit(state.copyWith(
          status: LocationsStatus.empty,
          page: 1,
          hasNextPage: false,
          locations: [],
        ));
      } else {
        emit(state.copyWith(
          status: LocationsStatus.loaded,
          page: 1,
          hasNextPage: hasNext,
          locations: list,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LocationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadNextLocations(
    LoadNextLocationsEvent event,
    Emitter<LocationsState> emit,
  ) async {
    if (!state.hasNextPage || state.status == LocationsStatus.loadingPage) {
      return;
    }
    try {
      emit(state.copyWith(status: LocationsStatus.loadingPage));
      final nextPage = state.page + 1;

      final (list, hasNext) = await repository.getLocations(nextPage);
      if (list.isEmpty) {
        emit(state.copyWith(
          status: LocationsStatus.loaded,
          hasNextPage: false,
        ));
      } else {
        final updated = [...state.locations, ...list];
        emit(state.copyWith(
          status: LocationsStatus.loaded,
          page: nextPage,
          hasNextPage: hasNext,
          locations: updated,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LocationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
