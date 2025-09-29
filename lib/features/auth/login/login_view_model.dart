import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/login_model.dart';
import 'package:absensi_app/core/services/pref_service.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:retrofit/retrofit.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({required this.authApi});

  final AuthApi authApi;
  final PrefService _prefService = PrefService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String username = '';
  String password = '';
  String? usernameError;
  String? passwordError;

  @override
  Future<void> initModel() async {
    setBusy(true);
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    usernameController.dispose();
    passwordController.dispose();
    super.disposeModel();
  }

  void updateUsername(String value) {
    username = value;
    usernameError = username.isEmpty ? 'Username tidak boleh kosong' : null;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    if (password.isEmpty) {
      passwordError = 'Password tidak boleh kosong';
    } else if (password.length < 6) {
      passwordError = 'Password minimal 6 karakter';
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  bool get isFormValid =>
      username.isNotEmpty && password.isNotEmpty && password.length >= 6;

  Future<void> login() async {
    setBusy(true);
    try {
      final deviceId = await FlutterUdid.consistentUdid;
      final HttpResponse<LoginResponse> response = await authApi.login(
        request: LoginRequest(
          username: username,
          password: password,
          deviceId: deviceId,
        ),
      );
      if (response.response.statusCode == 200) {
        final loginResponse = response.data;
        await _prefService.saveToken(loginResponse.token);
        setSuccess(loginResponse.message);
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
      setBusy(false);
    }
  }
}

