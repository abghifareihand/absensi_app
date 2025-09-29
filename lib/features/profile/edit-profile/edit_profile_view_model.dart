import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/profile_model.dart';
import 'package:absensi_app/core/models/update_profile_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';

class EditProfileViewModel extends BaseViewModel {
  EditProfileViewModel({required this.user, required this.authApi});
  final AuthApi authApi;
  final User user;

  late TextEditingController nameController;
  String name = '';
  String? nameError;

  late TextEditingController usernameController;
  String username = '';
  String? usernameError;

  late TextEditingController emailController;
  String email = '';
  String? emailError;

  late TextEditingController phoneController;
  String phone = '';
  String? phoneError;

  late TextEditingController identityNumberController;
  String identityNumber = '';
  String? identityNumberError;

  late TextEditingController addressController;
  String address = '';
  String? addressError;

  @override
  Future<void> initModel() async {
    setBusy(true);
    fetchUserData(user);
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    identityNumberController.dispose();
    addressController.dispose();
    super.disposeModel();
  }

  void updateName(String value) {
    name = value;
    nameError = name.isEmpty ? 'Nama tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateUsername(String value) {
    username = value;
    usernameError = username.isEmpty ? 'Username tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    if (email.isEmpty) {
      emailError = 'Email tidak boleh kosong';
    }  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      emailError = 'Format email tidak valid';
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  void updatePhone(String value) {
    phone = value;
    phoneError = phone.isEmpty ? 'No Hp tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateIdentityNumber(String value) {
    identityNumber = value;
    identityNumberError = identityNumber.isEmpty ? 'No Identitas tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateAddress(String value) {
    address = value;
    addressError = address.isEmpty ? 'Alamat tidak boleh kosong' : null;
    notifyListeners();
  }

  bool get isFormValid => name.isNotEmpty && username.isNotEmpty;

  void fetchUserData(User user) {
    // isi controller
    nameController = TextEditingController(text: user.name);
    usernameController = TextEditingController(text: user.username);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
    identityNumberController = TextEditingController(text: user.identityNumber);
    addressController = TextEditingController(text: user.address);

    // isi variabel model juga
    name = user.name ?? '';
    username = user.username ?? '';
    email = user.email ?? '';
    phone = user.phone ?? '';
    identityNumber = user.identityNumber ?? '';
    address = user.address ?? '';
  }

  Future<void> saveProfile() async {
    setBusy(true);
    try {
      final HttpResponse<ApiResponse> response = await authApi.updateProfile(
        request: UpdateProfileRequest(
          name: name,
          username: username,
          email: email.isEmpty ? null : email,
          identityNumber: identityNumber.isEmpty ? null : identityNumber,
          phone: phone.isEmpty ? null : phone,
          address: address.isEmpty ? null : address,
        ),
      );

      if (response.response.statusCode == 200) {
        setSuccess(response.data.message);
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response?.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}
