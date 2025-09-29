import 'package:absensi_app/core/api/attendance_api.dart';
import 'package:absensi_app/core/api/attendance_point_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/attendance_model.dart';
import 'package:absensi_app/core/models/attendance_point_model.dart';
import 'package:absensi_app/core/models/attendance_point_nearest_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AttendanceViewModel extends BaseViewModel {
  AttendanceViewModel({required this.attendancePointApi, required this.attendanceApi});
  final AttendancePointApi attendancePointApi;
  final AttendanceApi attendanceApi;

  // Controller untuk mengatur map OSM
  final MapController mapController = MapController();

  // Zoom level awal map (15 = level kota, 18 = sangat dekat ke gedung)
  double currentZoom = 15;
  LatLng? userLocation;
  double? latitude;
  double? longitude;

  LatLng? selectedMarker;
  String? selectedMarkerName;
  int? selectedMarkerRadius;

  // Daftar titik absensi yang diambil dari API
  List<AttendancePoint> attendancePoints = [];
  AttendancePointNearest? attendancePointNearest;
  String errorMessage = '';
  bool isLoadingPressed = false;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchCurrentLocation();
    await fetchAttendancePointNearest();
    await fetchAttendancePoints();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      latitude = position.latitude;
      longitude = position.longitude;
      userLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      errorMessage = "Gagal mendapatkan lokasi: $e";
      notifyListeners();
    }
  }

  Future<void> fetchAttendancePointNearest() async {
    setBusy(true);
    try {
      final response = await attendancePointApi.attendancePointNearest(
        latitude: latitude!,
        longitude: longitude!,
      );
      if (response.response.statusCode == 200) {
        attendancePointNearest = response.data.data;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }

  Future<void> fetchAttendancePoints() async {
    setBusy(true);
    try {
      final response = await attendancePointApi.attendancePoints();
      if (response.response.statusCode == 200) {
        attendancePoints = response.data.data;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }

  // Future<void> checkAttendance() async {
  //   if (userLocation == null || attendancePointNearest == null) {
  //     setError('Lokasi atau titik absensi tidak tersedia');
  //     notifyListeners();
  //     return;
  //   }

  //   // Konversi koordinat dari nearest point
  //   final pointLat = attendancePointNearest!.latitude;
  //   final pointLng = attendancePointNearest!.longitude;
  //   final radius = attendancePointNearest!.radius; // default 50 m

  //   // Hitung jarak user ke titik absensi (meter)
  //   final distance = Geolocator.distanceBetween(
  //     userLocation!.latitude,
  //     userLocation!.longitude,
  //     pointLat,
  //     pointLng,
  //   );

  //   if (distance <= radius) {
  //     isLoadingPressed = true;
  //     notifyListeners();
  //     try {
  //       final response = await attendanceApi.attendance(
  //         request: AttendanceRequest(
  //           attendancePointId: attendancePointNearest!.id,
  //           latitude: userLocation!.latitude,
  //           longitude: userLocation!.longitude,
  //         ),
  //       );

  //       if (response.response.statusCode == 200) {
  //         final attendanceResponse = response.data;
  //         setSuccess(attendanceResponse.message);
  //       }
  //     } on DioException catch (e) {
  //       final apiResponse = ApiResponse.fromJson(e.response!.data);
  //       setError(apiResponse.message);
  //     }
  //     isLoadingPressed = false;
  //     notifyListeners();
  //   } else {
  //     String distanceText;
  //     if (distance >= 1000) {
  //       distanceText = '${(distance / 1000).toStringAsFixed(1)} km';
  //     } else {
  //       distanceText = '${distance.round()} m';
  //     }
  //     setError('Jarak anda terlalu jauh ($distanceText)');
  //   }
  //   isLoadingPressed = false;
  //   notifyListeners();
  // }

  Future<void> checkAttendance() async {
    if (userLocation == null || attendancePointNearest == null) {
      setError('Lokasi atau titik absensi tidak tersedia');
      return;
    }

    final pointLat = attendancePointNearest!.latitude;
    final pointLng = attendancePointNearest!.longitude;
    final radius = attendancePointNearest!.radius;

    // Hitung jarak user ke titik absensi (meter)
    final distance = Geolocator.distanceBetween(
      userLocation!.latitude,
      userLocation!.longitude,
      pointLat,
      pointLng,
    );

    // Helper format jarak
    String formatDistance(double distance) {
      if (distance >= 1000) {
        return '${(distance / 1000).toStringAsFixed(1)} km';
      }
      return '${distance.round()} m';
    }

    // Cek jarak
    if (distance > radius) {
      setError('Jarak anda terlalu jauh (${formatDistance(distance)})');
      return;
    }

    // Dalam radius → panggil API
    isLoadingPressed = true;
    notifyListeners();

    try {
      final response = await attendanceApi.attendances(
        request: AttendanceRequest(
          attendancePointId: attendancePointNearest!.id,
          latitude: userLocation!.latitude,
          longitude: userLocation!.longitude,
        ),
      );

      if (response.response.statusCode == 200) {
        final attendanceResponse = response.data;
        setSuccess(attendanceResponse.message);
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }

    // Pastikan selalu reset loading
    isLoadingPressed = false;
    notifyListeners();
  }

  void selectMarker(AttendancePoint point) {
    selectedMarker = LatLng(point.latitude, point.longitude);
    selectedMarkerName = point.name;
    selectedMarkerRadius = point.radius;
    notifyListeners();
  }


  void zoomIn() {
    currentZoom += 1;
    mapController.move(mapController.camera.center, currentZoom); // tetap pusat map saat ini
  }

  void zoomOut() {
    currentZoom -= 1;
    mapController.move(mapController.camera.center, currentZoom);
  }

  void moveToCurrentLocation({double zoom = 18}) {
    if (userLocation != null) {
      mapController.move(userLocation!, zoom);
    }
  }
}
