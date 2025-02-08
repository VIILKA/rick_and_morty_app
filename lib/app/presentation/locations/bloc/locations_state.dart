import 'package:equatable/equatable.dart';
import '../../../domain/entities/location.dart';

enum LocationsStatus { initial, loading, loadingPage, loaded, empty, error }

class LocationsState extends Equatable {
  final LocationsStatus status;
  final List<Location> locations;
  final int page;
  final bool hasNextPage;
  final String? errorMessage;

  const LocationsState({
    required this.status,
    required this.locations,
    required this.page,
    required this.hasNextPage,
    this.errorMessage,
  });

  factory LocationsState.initial() {
    return const LocationsState(
      status: LocationsStatus.initial,
      locations: [],
      page: 1,
      hasNextPage: true,
      errorMessage: null,
    );
  }

  LocationsState copyWith({
    LocationsStatus? status,
    List<Location>? locations,
    int? page,
    bool? hasNextPage,
    String? errorMessage,
  }) {
    return LocationsState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, locations, page, hasNextPage, errorMessage];
}
