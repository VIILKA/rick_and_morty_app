import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rick_and_morty_app/app/presentation/episodes/bloc/episodes_bloc.dart';

class EpisodeDetailsScreen extends StatelessWidget {
  final String episodeId;

  const EpisodeDetailsScreen({
    super.key,
    required this.episodeId,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Достаём список эпизодов из BLoC
    final episodes = context.select((EpisodesBloc bloc) => bloc.state.episodes);

    // 2. Преобразуем episodeId в int
    final idInt = int.tryParse(episodeId);
    if (idInt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Неверный ID")),
        body:
            const Center(child: Text("Параметр episodeId должен быть числом.")),
      );
    }

    // 3. Ищем эпизод по ID (если не нашли - можно отобразить «не найден»)
    final ep = episodes.firstWhere((e) => e.id == idInt);

    if (ep.id == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text("Эпизод не найден")),
        body: const Center(child: Text("У нас нет данных о таком эпизоде.")),
      );
    }

    // 4. Показываем детали эпизода
    return Scaffold(
      appBar: AppBar(
        title: Text(ep.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Эпизод: ${ep.episode}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Дата выхода: ${ep.airDate}"),
            const SizedBox(height: 8),
            Text("URL: ${ep.url}"),
            const SizedBox(height: 8),
            Text("Создан: ${ep.created.toLocal()}"),
            const SizedBox(height: 16),

            const Text(
              "Персонажи:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 5. Выводим аватарки персонажей
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ep.characters.map((charUrl) {
                // Извлекаем ID
                final splitted = charUrl.split('/');
                final charId = splitted.last; // "1", "2", "14" ...
                final avatarUrl =
                    "https://rickandmortyapi.com/api/character/avatar/$charId.jpeg";

                return CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(avatarUrl),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
