import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/app/domain/entities/location.dart';
import 'package:rick_and_morty_app/app/presentation/locations/bloc/locations_bloc.dart';

class LocationDetailsScreen extends StatelessWidget {
  final String locationId;

  const LocationDetailsScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context) {
    final locations =
        context.select((LocationsBloc bloc) => bloc.state.locations);

    final idInt = int.tryParse(locationId);
    if (idInt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Некорректный ID")),
        body: const Center(
            child: Text("Параметр locationId должен быть числом.")),
      );
    }

    final loc = locations.firstWhere(
      (l) => l.id == idInt,
      orElse: () => Location(
        id: -1,
        name: "Not found",
        type: "",
        dimension: "",
        residents: [],
        url: "",
        created: DateTime(1970),
      ),
    );

    if (loc.id == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text("Локация не найдена")),
        body: const Center(child: Text("У нас нет данных о такой локации.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMainInfoCard(context, loc),
            const SizedBox(height: 16),
            _buildCreatedCard(context, loc),
            const SizedBox(height: 16),
            _buildResidentsCard(context, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context, Location loc) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            Text("Тип: ${loc.type}",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text("Измерение: ${loc.dimension}",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text("URL: ${loc.url}",
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatedCard(BuildContext context, Location loc) {
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
              "Создано: ${loc.created.toLocal()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResidentsCard(BuildContext context, Location loc) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Резиденты",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (loc.residents.isEmpty) const Text("Нет жителей"),
            if (loc.residents.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: loc.residents.map((charUrl) {
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
