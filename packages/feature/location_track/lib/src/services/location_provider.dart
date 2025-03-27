import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:location_track/location_track.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:offline_location/domain/offline_location_repository.dart';

class LocationServiceProvider {
  final LocationService locationServiceProvider;
  final FirebaseLocationStoreProvider locationStoreProvider;
  final GeoLocatorService geoService;
  final OfflineLocationRepository offlineLocationRepository;

  LocationServiceProvider(
      {required this.locationServiceProvider,
      required this.locationStoreProvider,
      required this.geoService,
      required this.offlineLocationRepository});

  LocationData userLocation = LocationData.fromMap({});
  geocoding.Placemark? placeMark;
  String place = '';
  late StreamSubscription locationSubscription;
  LatLong initialCameraPosition = const LatLong(23.256555, 90.157965);
  final StreamController<String> _placeController = StreamController<String>.broadcast();

  Stream<String> get placeStream => _placeController.stream;

  ///return future location
  Future<Position?> getUserPositionFuture() async {
    try {
      return await geoService.getCordFuture();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> onLocationRefresh() async {
    Position? position = await getUserPositionFuture();
    try {
      if (position != null) {
        final places = await getAddressByPosition(position: position);
        placeMark = places?.first;
        place =
            '${placeMark?.street ?? ""}  ${placeMark?.subLocality ?? ""} ${placeMark?.locality ?? ""} ${placeMark?.postalCode ?? ""}';
      }
      return place;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLocationEnabled() async {
    final status = await locationServiceProvider.hasPermission();
    return status == PermissionStatus.granted;
  }

  ///return driver current location stream
  ///for this we use another package called {Location:any}
  ///to get location more better way
  void getCurrentLocationStream({required String uid, required MetaClubApiClient metaClubApiClient}) async {
    ///location permission check
    final isGranted = await askForLocationAlwaysPermission();

    if (!isGranted) {
      await askForLocationAlwaysPermission();
    }

    ///listening data from location service
    locationSubscription = locationServiceProvider.locationStream.listen((event) async {
      ///initialize userLocation data
      userLocation = event;

      ///convert locationData into Position data
      final position = Position(
          latitude: event.latitude!,
          longitude: event.longitude!,
          speed: event.speed!,
          heading: event.heading!,
          altitude: event.altitude!,
          accuracy: event.accuracy!,
          timestamp: DateTime.now(),
          speedAccuracy: event.speedAccuracy!,
          altitudeAccuracy: 0,
          headingAccuracy: 0);

      final places = await getAddressByPosition(position: position);
      placeMark = places?.first;
      place =
          '${placeMark?.street ?? ""}  ${placeMark?.subLocality ?? ""} ${placeMark?.locality ?? ""} ${placeMark?.postalCode ?? ""}';
      if (!_placeController.isClosed) {
        _placeController.add(place);
      }

      ///when locationSubscription is enable only then
      ///location data can be processed to manipulate
      if (!locationSubscription.isPaused) {
        ///Inactive all listener to listen location data for a while
        locationSubscription.pause();

        debugPrint('isPaused ${locationSubscription.isPaused}');
      }

      ///initial camera position
      initialCameraPosition = LatLong(event.latitude!, event.longitude!);
    });

    ///when locationSubscription is enable only then
    ///location data can be processed to manipulate
    if (!locationSubscription.isPaused) {
      final position = await getUserPositionFuture();
      userLocation = LocationData.fromMap({"latitude": position?.latitude, "longitude": position?.longitude});
      if (position != null) {
        ///getting address from current position
        addLocationDataToLocal(position: position, uid: uid);
      }

      ///store data to server from hive
      deleteLocationDataAndStoreToServer(metaClubApiClient: metaClubApiClient);

      debugPrint('isPaused ${locationSubscription.isPaused}');
    }

    ///set timer to toggle location subscription
    Timer.periodic(const Duration(minutes: 2), (timer) async {
      if (locationSubscription.isPaused) {
        locationSubscription.resume();
      }
      debugPrint('isPaused ${locationSubscription.isPaused}');
    });
  }

  Future<List<geocoding.Placemark>?> getAddressByPosition({required Position position}) async {
    return await geoService.getAddress(position);
  }

  ///return last stored location from hive database
  getLastLocationFromLocal() async {
    final data = await offlineLocationRepository.getUserLastPosition();
    return data;
  }

  ///return first stored location from hive database
  getFirstLocationFromLocal() async {
    final data = await offlineLocationRepository.getUserFirstPosition();
    return data;
  }

  ///store data to local
  addLocationDataToLocal({String? currentDateData, required Position position, required String uid}) async {
    userLocation = LocationData.fromMap({"latitude": position.latitude, "longitude": position.longitude});

    final places = await getAddressByPosition(position: position);

    placeMark = places?.first;

    place =
        '${placeMark?.street ?? ""}  ${placeMark?.subLocality ?? ""} ${placeMark?.locality ?? ""} ${placeMark?.postalCode ?? ""}';
    if (!_placeController.isClosed) {
      _placeController.add(place);
    }

    Timer.periodic(const Duration(minutes: 2), (timer) async {
      if (kDebugMode) {
        print('local from position ${position.toString()}');
      }

      double distance = 0.0;

      final locationModel = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          speed: position.speed,
          city: placeMark?.locality,
          country: placeMark?.country,
          countryCode: placeMark?.isoCountryCode,
          address:
              '${placeMark?.name} ${placeMark?.subLocality} ${placeMark?.thoroughfare} ${placeMark?.subThoroughfare}',
          heading: position.heading,
          distance: distance,
          datetime: DateTime.now().toString());

      ///add data to local database
      offlineLocationRepository.add(locationModel);

      FirebaseLocationStoreProvider.sendLocationToFirebase(uid, locationModel.toJson());
    });
  }

  ///data will be delete after data store to server
  deleteLocationDataAndStoreToServer({String? currentDateData, required MetaClubApiClient metaClubApiClient}) async {
    ///data will be stored to server after 4 minute
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      final data = await offlineLocationRepository.toMapList();
      if (data.length > 3 && !locationSubscription.isPaused) {
        if (kDebugMode) {
          print('data that u have to sent server $data');
        }
        metaClubApiClient
            .storeLocationToServer(locations: data, date: DateTime.now().toString())
            .then((isStored) async {
          isStored.fold((l) {}, (data) async {
            if (data != null) {
              if (data.data['result'] == true) {
                SharedUtil.setValue(bulletinKey, data.data['data']);
              }
            }
            await offlineLocationRepository.deleteAllLocation();
          });
        });
      }
    });
  }

  /// Tries to ask for "location always" permissions from the user.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> askForLocationAlwaysPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
      return false;
    }
    return true;
  }

  void disposePlaceController() async {
    await _placeController.close();
  }
}
