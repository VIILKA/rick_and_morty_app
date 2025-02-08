// lib/core/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/app/presentation/characters/character_details_screen.dart';
import 'package:rick_and_morty_app/app/presentation/characters/characters_screen.dart';
import 'package:rick_and_morty_app/app/presentation/episodes/episode_details_screen.dart';
import 'package:rick_and_morty_app/app/presentation/episodes/episodes_screen.dart';
import 'package:rick_and_morty_app/app/presentation/locations/location_details_screen.dart';
import 'package:rick_and_morty_app/app/presentation/locations/locations_screen.dart';
import 'package:rick_and_morty_app/app/presentation/screens/shell_page.dart';

final router = GoRouter(
  initialLocation: '/characters',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ShellPage(child: child);
      },
      routes: [
        /// Characters
        GoRoute(
          path: '/characters',
          pageBuilder: (context, state) {
            return NoTransitionPage(child: const CharactersScreen());
          },
          routes: [
            // Детальная страница персонажа: /characters/details/123
            GoRoute(
              path: 'details/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return CharacterDetailsScreen(characterId: id);
              },
            ),
          ],
        ),

        /// Episodes
        GoRoute(
          path: '/episodes',
          pageBuilder: (context, state) {
            return NoTransitionPage(child: const EpisodesScreen());
          },
          routes: [
            GoRoute(
              path: 'details/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return EpisodeDetailsScreen(episodeId: id);
              },
            ),
          ],
        ),

        /// Locations
        GoRoute(
          path: '/locations',
          pageBuilder: (context, state) {
            return NoTransitionPage(child: const LocationsScreen());
          },
          routes: [
            GoRoute(
              path: 'details/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return LocationDetailsScreen(locationId: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
