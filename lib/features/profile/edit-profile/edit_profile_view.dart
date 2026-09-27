import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/models/profile_model.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/profile/edit-profile/edit_profile_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/shared/custom_button.dart';
import 'package:absensi_app/ui/shared/custom_snackbar.dart';
import 'package:absensi_app/ui/shared/custom_text_field.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileViewModel>(
      model: EditProfileViewModel(authApi: Provider.of<AuthApi>(context), user: user),
      onModelReady: (EditProfileViewModel model) => model.initModel(),
      onModelDispose: (EditProfileViewModel model) => model.disposeModel(),
      builder: (BuildContext context, EditProfileViewModel model, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Ubah Data Profil'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EditProfileViewModel model) {
  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: model.nameController,
              textCapitalization: TextCapitalization.words,
              label: 'Nama Lengkap',
              hintText: 'Masukkan nama lengkap',
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
              onChanged: model.updateName,
              errorText: model.nameError,
            ),
            const SizedBox(height: 18.0),
            CustomTextField(
              controller: model.usernameController,
              label: 'Username',
              hintText: 'Masukkan username',
              prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.primary, size: 20),
              onChanged: model.updateUsername,
              errorText: model.usernameError,
            ),
            const SizedBox(height: 18.0),
            CustomTextField(
              controller: model.emailController,
              keyboardType: TextInputType.emailAddress,
              label: 'Email',
              hintText: 'Masukkan alamat email',
              prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.primary, size: 20),
              onChanged: model.updateEmail,
              errorText: model.emailError,
            ),
            const SizedBox(height: 18.0),
            CustomTextField(
              controller: model.identityNumberController,
              label: 'Nomor Identitas (NIM / NIP)',
              hintText: 'Masukkan nomor identitas',
              prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary, size: 20),
              onChanged: model.updateIdentityNumber,
              errorText: model.identityNumberError,
            ),
            const SizedBox(height: 18.0),
            CustomTextField(
              controller: model.phoneController,
              keyboardType: TextInputType.phone,
              label: 'Nomor Handphone / WhatsApp',
              hintText: 'Contoh: 08123456789',
              prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary, size: 20),
              onChanged: model.updatePhone,
              errorText: model.phoneError,
            ),
            const SizedBox(height: 18.0),
            CustomTextField(
              controller: model.addressController,
              label: 'Alamat Tinggal',
              hintText: 'Masukkan alamat lengkap domisili...',
              onChanged: model.updateAddress,
              errorText: model.addressError,
              maxLines: 3,
            ),
            const SizedBox(height: 24.0),
            Button.filled(
              height: 50,
              borderRadius: 14,
              icon: const Icon(Icons.save_rounded, color: AppColors.white, size: 20),
              onPressed: model.isFormValid
                  ? () async {
                      await model.saveProfile();
                      if (context.mounted) {
                        if (model.error) {
                          CustomSnackbar.showError(context, model.message);
                        }
                        if (model.success) {
                          Navigator.of(context).pop(true);
                          CustomSnackbar.showSuccess(context, 'Data profil berhasil disimpan.');
                        }
                      }
                    }
                  : null,
              label: 'Simpan Perubahan',
              isLoading: model.isBusy,
            ),
          ],
        ),
      ),
    ],
  );
}
