import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/app/domain/entities/location.dart';
import 'bloc/locations_bloc.dart';
import 'bloc/locations_event.dart';
import 'bloc/locations_state.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final bloc = context.read<LocationsBloc>();
    if (bloc.state.locations.isEmpty) {
      bloc.add(LoadLocationsEvent());
    }

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent * 0.9) {
      context.read<LocationsBloc>().add(LoadNextLocationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Локации"),
      ),
      body: BlocBuilder<LocationsBloc, LocationsState>(
        builder: (context, state) {
          switch (state.status) {
            case LocationsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LocationsStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ошибка: ${state.errorMessage}"),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LocationsBloc>().add(LoadLocationsEvent());
                      },
                      child: const Text("Повторить"),
                    ),
                  ],
                ),
              );
            case LocationsStatus.empty:
              return const Center(child: Text("Нет результатов"));
            case LocationsStatus.loaded:
            case LocationsStatus.loadingPage:
              return _buildList(
                locations: state.locations,
                isLoadingPage: state.status == LocationsStatus.loadingPage,
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildList({
    required List<Location> locations,
    required bool isLoadingPage,
  }) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: locations.length + 1,
      itemBuilder: (context, index) {
        if (index < locations.length) {
          final loc = locations[index];
          return ListTile(
            title: Text(loc.name),
            subtitle: Text("${loc.type} | ${loc.dimension}"),
            onTap: () {
              context.go('/locations/details/${loc.id}');
            },
          );
        } else {
          if (isLoadingPage) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
