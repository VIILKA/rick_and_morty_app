import 'package:equatable/equatable.dart';
import '../../../domain/entities/episode.dart';

enum EpisodesStatus { initial, loading, loadingPage, loaded, empty, error }

class EpisodesState extends Equatable {
  final EpisodesStatus status;
  final List<Episode> episodes;
  final int page;
  final bool hasNextPage;
  final String? errorMessage;

  const EpisodesState({
    required this.status,
    required this.episodes,
    required this.page,
    required this.hasNextPage,
    this.errorMessage,
  });

  factory EpisodesState.initial() {
    return const EpisodesState(
      status: EpisodesStatus.initial,
      episodes: [],
      page: 1,
      hasNextPage: true,
      errorMessage: null,
    );
  }

  EpisodesState copyWith({
    EpisodesStatus? status,
    List<Episode>? episodes,
    int? page,
    bool? hasNextPage,
    String? errorMessage,
  }) {
    return EpisodesState(
      status: status ?? this.status,
      episodes: episodes ?? this.episodes,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, episodes, page, hasNextPage, errorMessage];
}
