// lib/app/presentation/characters/bloc/characters_event.dart

import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharactersEvent extends CharactersEvent {}

class LoadNextPageEvent extends CharactersEvent {}

class ApplyFilterEvent extends CharactersEvent {
  final CharacterFilter filter;
  const ApplyFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
