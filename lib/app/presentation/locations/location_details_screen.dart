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
    // 1. Получаем список локаций из BLoC
    final locations =
        context.select((LocationsBloc bloc) => bloc.state.locations);

    // 2. Преобразуем строку в int
    final idInt = int.tryParse(locationId);
    if (idInt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Некорректный ID")),
        body: const Center(
            child: Text("Параметр locationId должен быть числом.")),
      );
    }

    // 3. Ищем локацию по id
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

    // Если не нашли => показываем заглушку
    if (loc.id == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text("Локация не найдена")),
        body: const Center(child: Text("У нас нет данных о такой локации.")),
      );
    }

    // 4. Показываем детальное описание
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Тип: ${loc.type}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Измерение: ${loc.dimension}"),
            const SizedBox(height: 8),
            Text("URL: ${loc.url}"),
            const SizedBox(height: 8),
            Text("Создано: ${loc.created.toLocal()}"),
            const SizedBox(height: 16),

            const Text("Резиденты:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Выводим список жителей
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: loc.residents.map((charUrl) {
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
