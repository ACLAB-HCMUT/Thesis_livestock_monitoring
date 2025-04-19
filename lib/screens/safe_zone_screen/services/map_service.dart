import 'dart:typed_data';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/models/save_zone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../utils/map_helpers.dart';

class MapService {
  static void Function(Symbol) _onCowSymbolTapped(Map<Symbol, CowModel> cowSymbols, BuildContext context){
    return (Symbol symbol){
      if(cowSymbols.containsKey(symbol)){
        final cow = cowSymbols[symbol];
        MapHelpers.showCowInfoBottomSheet(context, cow!);
      }
    };
  }
  static Future<void> initializeMap(
    MapLibreMapController controller,
    List<CoordinatePoint> safeZones,
    BuildContext context,
    Map<Symbol, CowModel> cowsSymbol,
    String groupName
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    await controller.setSymbolIconAllowOverlap(true);
    await controller.setSymbolTextAllowOverlap(true);

    controller.onSymbolTapped.add(_onCowSymbolTapped(cowsSymbol, context));
    final Uint8List markerIcon = await MapHelpers.getImageFromAsset('assets/location_icon.jpg');
    await controller.addImage("location-icon", markerIcon);
    final cowState = context.read<CowBloc>().state;
    if (cowState is CowsLoaded) {
      final cows = cowState.cows
                  .where((cow) =>
                      cow.groupId == groupName) // Filter again to access data
                  .toList();
      MapHelpers.addCowMarkers(controller, cows, cowsSymbol);
    }     
    List<LatLng> polygons = MapHelpers.convertPointsToLatLng(safeZones);
    MapHelpers.drawSafeZone(controller, polygons);
  }
}