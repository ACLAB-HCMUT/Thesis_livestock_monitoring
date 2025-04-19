import 'package:do_an_app/models/cow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'widgets/map_controls.dart';
import 'services/map_service.dart';
import 'services/cow_service.dart';
import 'utils/map_helpers.dart';
import '../../models/save_zone_model.dart';
import '../../controllers/cow_controller/cow_bloc.dart';
import '../../controllers/cow_controller/cow_state.dart';

class SafeZoneScreen extends StatefulWidget {
  final List<CoordinatePoint> safeZones;
  final String name;
  const SafeZoneScreen(
      {super.key, required this.safeZones, required this.name});
  @override
  _SafeZoneScreenState createState() => _SafeZoneScreenState();
}

class _SafeZoneScreenState extends State<SafeZoneScreen> {
  MapLibreMapController? mapController;
  final Map<Symbol, CowModel> cowsSymbol = {};

  @override
  void initState() {
    super.initState();
  }

  void _focusOnCow(CowModel cow) {
    if (mapController != null &&
        cow.latestLatitude != null &&
        cow.latestLongitude != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(cow.latestLatitude!, cow.latestLongitude!),
          18, // Zoom level
        ),
      );
    }
  }

  void _showCowList(BuildContext context) {
    final cowState = context.read<CowBloc>().state;
    if (cowState is CowsLoaded) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allow the sheet to take up more space
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return BlocBuilder<CowBloc, CowState>(
            builder: (context, state) {
              final cowState = context.read<CowBloc>().state as CowsLoaded;
              final filteredCows = cowState.cows
                  .where((cow) =>
                      cow.groupId == widget.name) // Filter again to access data
                  .toList();
              return Container(
                height: MediaQuery.of(context).size.height *
                    0.6, // 3/4 of the screen height
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Cow list of ${widget.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green.shade500),
                    ),
                    const SizedBox(height: 16),
                    // List of cows
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: filteredCows.length,
                          itemBuilder: (context, index) {
                            final cow = filteredCows[index];

                            return Card(
                              color: Colors.green.shade100,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.pets,
                                  color: Colors.green[700],
                                ),
                                title: Text(
                                  cow.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lat: ${cow.latestLatitude}, Lng: ${cow.latestLongitude}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Current status: ${cow.status}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        if (cow.sick!)
                                          Icon(
                                            Icons.medical_services,
                                            color: Colors.red[400],
                                            size: 16,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onTap: () {
                                  // Focus the map on the selected cow
                                  _focusOnCow(cow);
                                  Navigator.pop(
                                      context); // Close the bottom sheet
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng centerPoint = MapHelpers.calculateCenter(widget.safeZones);
    return BlocListener<CowBloc, CowState>(
      listener: (context, state) {
        if (state is CowsLoaded) {
          mapController!.clearSymbols();
          final cows = state.cows
                  .where((cow) =>
                      cow.groupId == widget.name) // Filter again to access data
                  .toList();
          MapHelpers.addCowMarkers(mapController!, cows, cowsSymbol);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Map (${widget.name})",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green[300],
        ),
        body: Stack(
          children: [
            MapLibreMap(
              styleString:
                  "https://basemaps.cartocdn.com/gl/voyager-gl-style/style.json",
              initialCameraPosition: CameraPosition(
                target: centerPoint,
                zoom: 17.5,
              ),
              onMapCreated: (controller) {
                MapService.initializeMap(
                    controller, widget.safeZones, context, cowsSymbol, widget.name);
                mapController = controller;
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () => _showCowList(context),
                child: const Icon(Icons.list),
                backgroundColor: Colors.green.shade200,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: MapControls.buildFloatingActionButton(context),
        bottomNavigationBar: MapControls.buildBottomAppBar(),
      ),
    );
  }
}
