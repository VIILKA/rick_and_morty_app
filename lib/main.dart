import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/app/data/data_sources/character_remote_data_source.dart';
import 'package:rick_and_morty_app/app/data/data_sources/episode_remote_data_source.dart';
import 'package:rick_and_morty_app/app/data/data_sources/location_remote_data_source.dart';
import 'package:rick_and_morty_app/app/data/repository_impl/character_repository_impl.dart';
import 'package:rick_and_morty_app/app/data/repository_impl/episode_repository_impl.dart';
import 'package:rick_and_morty_app/app/data/repository_impl/location_repository_impl.dart';
import 'package:rick_and_morty_app/app/presentation/characters/bloc/characters_bloc.dart';
import 'package:rick_and_morty_app/app/presentation/episodes/bloc/episodes_bloc.dart';
import 'package:rick_and_morty_app/app/presentation/locations/bloc/locations_bloc.dart';
import 'package:rick_and_morty_app/core/routes/app_router.dart';
import 'package:rick_and_morty_app/core/styles/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(
      BaseOptions(
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
    final charDS = CharacterRemoteDataSource(dio);
    final charRepo = CharacterRepositoryImpl(charDS);
    final remoteDS = EpisodeRemoteDataSource(dio);
    final repo = EpisodeRepositoryImpl(remoteDS);
    final locationDS = LocationRemoteDataSource(dio);
    final locationRepo = LocationRepositoryImpl(locationDS);
    return MultiBlocProvider(
      providers: [
        BlocProvider<CharactersBloc>(create: (_) => CharactersBloc(charRepo)),
        BlocProvider<EpisodesBloc>(
          create: (_) => EpisodesBloc(repo),
        ),
        BlocProvider<LocationsBloc>(
          create: (_) => LocationsBloc(locationRepo),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        title: 'Rick & Morty with GoRouter',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
