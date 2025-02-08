import 'package:equatable/equatable.dart';

abstract class LocationsEvent extends Equatable {
  const LocationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocationsEvent extends LocationsEvent {}

class LoadNextLocationsEvent extends LocationsEvent {}
