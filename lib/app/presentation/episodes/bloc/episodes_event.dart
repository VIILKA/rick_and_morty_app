import 'package:equatable/equatable.dart';

abstract class EpisodesEvent extends Equatable {
  const EpisodesEvent();

  @override
  List<Object?> get props => [];
}

class LoadEpisodesEvent extends EpisodesEvent {}

class LoadNextEpisodesEvent extends EpisodesEvent {}
