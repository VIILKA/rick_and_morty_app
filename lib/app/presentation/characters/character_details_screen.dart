import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'bloc/characters_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final String characterId; // строковый ID, полученный из GoRouter

  const CharacterDetailsScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    // 1. Превращаем строку в int
    final idInt = int.tryParse(characterId);

    // Если не получилось превратить в число, показываем ошибку.
    if (idInt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Неверный ID")),
        body: const Center(child: Text("Параметр ID не является числом.")),
      );
    }

    // 2. Берём список персонажей из CharactersBloc.
    // Здесь мы используем context.select, чтобы сразу получить
    // нужные данные (список) из state, но можно и через BlocProvider.of сделать.
    final characters =
        context.select((CharactersBloc bloc) => bloc.state.characters);

    // 3. Ищем нужного персонажа
    // Если c.id == idInt — значит это наш искомый персонаж
    final found = characters.where((c) => c.id == idInt).toList();

    // 4. Если список пуст, значит не нашли такого персонажа
    if (found.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Персонаж не найден")),
        body: const Center(child: Text("Не удалось найти персонажа.")),
      );
    }

    // 5. Если нашли, берём первого
    final character = found.first;

    // 6. Рендерим детальную страницу
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: character.image,
              placeholder: (ctx, url) => const CircularProgressIndicator(),
              errorWidget: (ctx, url, error) => Image.asset(
                'assets/images/no_image.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text("Status: ${character.status}"),
            Text("Species: ${character.species}"),
            Text("Gender: ${character.gender}"),
            Text("Location: ${character.location.name}"),
            Text("Origin: ${character.origin.name}"),
            Text("Created: ${character.created}"),
            // ... и т.д.
          ],
        ),
      ),
    );
  }
}
