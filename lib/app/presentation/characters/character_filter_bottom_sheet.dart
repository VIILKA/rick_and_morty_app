import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/app/domain/entities/character_enums.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';

class CharacterFilterBottomSheet extends StatefulWidget {
  final Function(CharacterFilter) onApply;

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
  String? _name;
  CharacterStatus? _status;
  CharacterSpecies? _species;
  CharacterGender? _gender;
  String? _type;

  @override
  void initState() {
    super.initState();

    final f = widget.currentFilter;
    _name = f.name;
    _status = f.status;
    _species = f.species;
    _gender = f.gender;
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
    final filter = CharacterFilter(
      name: _name?.isNotEmpty == true ? _name : null,
      status: _status,
      species: _species,
      gender: _gender,
      type: _type?.isNotEmpty == true ? _type : null,
    );

    widget.onApply(filter);
  }
}
