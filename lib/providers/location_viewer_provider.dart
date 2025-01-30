import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationViewerProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final MapController _mapController = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );
  MapController get mapController => _mapController;

  GeoPoint _currentLocation = GeoPoint(latitude: 0, longitude: 0);
  GeoPoint get currentLocation => _currentLocation;

  setCurrentLocation() async {
    toggleLoading();

    try {
      _currentLocation = await _mapController.myLocation();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }

    toggleLoading();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
