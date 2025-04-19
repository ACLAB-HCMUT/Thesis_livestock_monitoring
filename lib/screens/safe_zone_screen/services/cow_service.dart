import 'package:do_an_app/models/cow_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class CowService {
  static void updateCowPosition(
    MapLibreMapController? mapController,
    Map<Symbol, CowModel>  cowsSymbol,
  ) async {
    if (mapController != null && cowsSymbol != null) {
      for (var cowSymbol in cowsSymbol.keys) {
        CowModel? cow = cowsSymbol[cowSymbol];
        mapController.updateSymbol(
          cowSymbol,
          SymbolOptions(
            geometry: LatLng(cow!.latestLatitude!, cow.latestLongitude!),
          ),
        );
      }
    }
  }
}