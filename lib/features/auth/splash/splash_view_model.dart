import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/services/pref_service.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({required this.authApi});

  final AuthApi authApi;
  final PrefService _prefService = PrefService();
  bool hasPermission = false;
  bool isDeviceValid = false;

  @override
  Future<void> initModel() async {
    setBusy(true);

    // 1. Cek token + device terlebih dahulu
    isDeviceValid = await validateDevice();

    // 2. Cek permission hanya jika sudah login/device valid
    // Atau bisa juga tidak memblokir flow login jika permission gagal
    if (isDeviceValid) {
      hasPermission = await _checkPermissions();
    } else {
      hasPermission = true; // Supaya tidak muncul snackbar error permission di halaman login
    }

    // 3. Delay untuk efek splash
    await Future.delayed(const Duration(seconds: 2));

    setBusy(false);
  }

  /// ✅ Validasi device ke API
  Future<bool> validateDevice() async {
    final token = await _prefService.getToken();
    print('🔑 Token : $token');
    if (token == null || token.isEmpty) return false;
    try {
      final deviceId = await FlutterUdid.consistentUdid;
      final response = await authApi.checkDevice(deviceId: deviceId);
      if (response.response.statusCode == 200 && response.data.status == true) {
        return true;
      } else {
        await PrefService().removeAll();
        return false;
      }
    } on DioException {
      await PrefService().removeAll();
      return false;
    }
  }

  /// ✅ Cek permission lokasi + storage
  Future<bool> _checkPermissions() async {
    // Cek lokasi
    final locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      final result = await Permission.location.request();
      if (!result.isGranted) return false;
    }

    // Cek storage (Hanya untuk Android)
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        final result = await Permission.manageExternalStorage.request();
        if (result.isPermanentlyDenied) {
          openAppSettings();
          return false;
        }
        if (!result.isGranted) return false;
      }
    }

    return true;
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }
}
