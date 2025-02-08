import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rick_and_morty_app/app/presentation/characters/bloc/characters_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final String characterId; // строковый ID из GoRouter

  const CharacterDetailsScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    final idInt = int.tryParse(characterId);
    if (idInt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Неверный ID")),
        body: const Center(child: Text("Параметр ID должен быть числом.")),
      );
    }

    final state = context.select((CharactersBloc bloc) => bloc.state);
    final characters = state.characters;

    final found = characters.where((c) => c.id == idInt);

    final character = found.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Основная карточка с аватаркой
            _buildAvatarCard(context, character),
            const SizedBox(height: 16),
            // Доп. карточка с полями статуса, вида, гендера
            _buildInfoCard(context, character),
            const SizedBox(height: 16),
            // Карточка локации / происхождения
            _buildLocationCard(context, character),
            const SizedBox(height: 16),
            // Карточка даты создания, если нужно
            _buildCreatedCard(context, character),
          ],
        ),
      ),
    );
  }

  /// Карточка с изображением персонажа (округлённым) и именем
  Widget _buildAvatarCard(BuildContext context, character) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: character.image,
                placeholder: (ctx, url) => const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (ctx, url, error) => Image.asset(
                    'assets/images/no_image.png',
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              character.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Карточка со статусом, расой, гендером
  Widget _buildInfoCard(BuildContext context, character) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Информация",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildRowItem("Статус", character.status),
            _buildRowItem("Вид", character.species),
            _buildRowItem("Гендер", character.gender),
          ],
        ),
      ),
    );
  }

  /// Карточка с локацией и origin
  Widget _buildLocationCard(BuildContext context, character) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Локация",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildRowItem("Текущая локация", character.location.name),
            _buildRowItem("Происхождение", character.origin.name),
          ],
        ),
      ),
    );
  }

  /// Карточка с датой создания
  Widget _buildCreatedCard(BuildContext context, character) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 8),
            Text(
              "Создан: ${character.created.toLocal()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// Вспомогательный виджет для строки "Поле: значение"
  Widget _buildRowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
