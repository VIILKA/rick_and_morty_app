import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/app/domain/entities/character_enums.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';

class CharacterFilterBottomSheet extends StatefulWidget {
  final Function(CharacterFilter) onApply;

  /// Текущий фильтр, из которого мы «стартуем».
  final CharacterFilter currentFilter;

  const CharacterFilterBottomSheet({
    super.key,
    required this.onApply,
    required this.currentFilter,
  });

  @override
  State<CharacterFilterBottomSheet> createState() =>
      _CharacterFilterBottomSheetState();
}

class _CharacterFilterBottomSheetState
    extends State<CharacterFilterBottomSheet> {
  // Поля локального состояния
  String? _name;
  CharacterStatus? _status;
  CharacterSpecies? _species;
  CharacterGender? _gender;
  String? _type;

  @override
  void initState() {
    super.initState();
    // Инициализируем локальное состояние из widget.currentFilter
    final f = widget.currentFilter;
    _name = f.name;
    _status = f.status; // null если не выбрано
    _species = f.species; // null если не выбрано
    _gender = f.gender; // null если не выбрано
    _type = f.type;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Text("Фильтр персонажей", style: TextStyle(fontSize: 18)),
            TextField(
              decoration: const InputDecoration(labelText: "Имя"),
              controller: TextEditingController(text: _name),
              onChanged: (v) => _name = v,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: "Тип"),
              controller: TextEditingController(text: _type),
              onChanged: (v) => _type = v,
            ),
            const SizedBox(height: 10),
            const Text("Статус:"),
            _buildStatusChips(),
            const SizedBox(height: 10),
            const Text("Species:"),
            _buildSpeciesChips(),
            const SizedBox(height: 10),
            const Text("Gender:"),
            _buildGenderChips(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _apply,
              child: const Text("Применить"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    // для примера: [CharacterStatus.alive, .dead, .unknown]
    // Если _status == null, значит ничего не выбрано
    final statuses = CharacterStatus.values;

    return Wrap(
      spacing: 8,
      children: statuses.map((status) {
        final selected = (_status == status);
        return FilterChip(
          label: Text(
            status.toString().split('.').last,
            style: TextStyle(
              color: selected ? Colors.deepPurple : Colors.black,
            ),
          ),
          selectedColor: Colors.deepPurple[100],
          checkmarkColor: Colors.deepPurple,
          selected: selected,
          onSelected: (bool value) {
            setState(() {
              _status = value ? status : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSpeciesChips() {
    final speciesList = CharacterSpecies.values;

    return Wrap(
      spacing: 8,
      children: speciesList.map((sp) {
        final selected = (_species == sp);
        return FilterChip(
          label: Text(sp.toString().split('.').last),
          selected: selected,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _species = sp;
              } else {
                _species = null;
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildGenderChips() {
    final genders = CharacterGender.values;

    return Wrap(
      spacing: 18,
      children: genders.map((g) {
        final selected = (_gender == g);
        return FilterChip(
          label: Text(g.toString().split('.').last),
          selected: selected,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _gender = g;
              } else {
                _gender = null;
              }
            });
          },
        );
      }).toList(),
    );
  }

  void _apply() {
    // Собираем окончательный фильтр
    final filter = CharacterFilter(
      name: _name?.isNotEmpty == true ? _name : null,
      status: _status, // null если не выбрано
      species: _species, // null если не выбрано
      gender: _gender, // null если не выбрано
      type: _type?.isNotEmpty == true ? _type : null,
    );

    widget.onApply(filter);
  }
}
