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
          children: [
            _buildMainInfoCard(context, ep),
            const SizedBox(height: 16),
            _buildCreatedCard(context, ep),
            const SizedBox(height: 16),
            _buildCharactersCard(context, ep),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context, ep) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ep.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            Text("Эпизод: ${ep.episode}",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text("Дата выхода: ${ep.airDate}",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text("URL: ${ep.url}",
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatedCard(BuildContext context, ep) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8),
            Text(
              "Создано: ${ep.created.toLocal()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharactersCard(BuildContext context, ep) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Персонажи",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ep.characters.map<Widget>((charUrl) {
                final splitted = charUrl.split('/');
                final charId = splitted.last;
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
