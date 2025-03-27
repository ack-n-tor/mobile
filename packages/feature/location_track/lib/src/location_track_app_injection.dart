import 'package:core/core.dart';
import 'package:location_track/location_track.dart';

class LocationTrackInjection {
  Future<void> initInjection() async {
    instance.registerSingleton<LocationService>(LocationService());
    instance.registerSingleton<GeoLocatorService>(GeoLocatorService());
    instance.registerSingleton<FirebaseLocationStoreProvider>(FirebaseLocationStoreProvider());
    instance.registerSingleton<LocationServiceProvider>(LocationServiceProvider(
        locationServiceProvider: instance(),
        locationStoreProvider: instance(),
        geoService: instance(),
        offlineLocationRepository: instance()));
  }
}
