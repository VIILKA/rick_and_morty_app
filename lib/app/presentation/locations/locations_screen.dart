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
                    const SizedBox(height: 12),
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
              final isLoadingPage =
                  (state.status == LocationsStatus.loadingPage);
              return _buildAdaptiveLayout(
                context,
                locations: state.locations,
                isLoadingPage: isLoadingPage,
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildAdaptiveLayout(
    BuildContext context, {
    required List<Location> locations,
    required bool isLoadingPage,
  }) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 600; // можно подбирать порог

    if (isWide) {
      return _buildGrid(context, locations, isLoadingPage);
    } else {
      return _buildList(context, locations, isLoadingPage);
    }
  }

  Widget _buildGrid(
      BuildContext context, List<Location> locations, bool isLoadingPage) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: locations.length + (isLoadingPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= locations.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final loc = locations[index];
        return _buildLocationCard(context, loc);
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<Location> locations, bool isLoadingPage) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: locations.length + (isLoadingPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < locations.length) {
          final loc = locations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: _buildLocationCard(context, loc),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildLocationCard(BuildContext context, Location loc) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.go('/locations/details/${loc.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                "${loc.type} | ${loc.dimension}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
