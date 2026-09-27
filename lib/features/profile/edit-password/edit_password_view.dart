import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/profile/edit-password/edit_password_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/shared/custom_button.dart';
import 'package:absensi_app/ui/shared/custom_snackbar.dart';
import 'package:absensi_app/ui/shared/custom_text_field.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPasswordView extends StatelessWidget {
  const EditPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<EditPasswordViewModel>(
      model: EditPasswordViewModel(authApi: Provider.of<AuthApi>(context)),
      onModelReady: (EditPasswordViewModel model) => model.initModel(),
      onModelDispose: (EditPasswordViewModel model) => model.disposeModel(),
      builder: (BuildContext context, EditPasswordViewModel model, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Ubah Password'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EditPasswordViewModel model) {
  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
    children: [
      // Security Tips Banner
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blueSubtle,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined, color: AppColors.blue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keamanan Akun',
                    style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Gunakan kombinasi minimal 8 karakter dengan huruf, angka, dan simbol untuk keamanan maksimal.',
                    style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // Form Card
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
              obscureText: true,
              controller: model.currentPasswordController,
              label: 'Password Saat Ini',
              hintText: 'Masukkan password saat ini',
              prefixIcon: const Icon(Icons.lock_open_rounded, color: AppColors.primary, size: 20),
              onChanged: model.updateCurrentPassword,
              errorText: model.currentPasswordError,
            ),
            const SizedBox(height: 18.0),
            CustomTextField(
              obscureText: true,
              controller: model.newPasswordController,
              label: 'Password Baru',
              hintText: 'Masukkan password baru',
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 20),
              onChanged: model.updateNewPassword,
              errorText: model.newPasswordError,
            ),
            const SizedBox(height: 18.0),
            CustomTextField(
              obscureText: true,
              controller: model.newPasswordConfirmationController,
              label: 'Konfirmasi Password Baru',
              hintText: 'Ulangi password baru',
              prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 20),
              onChanged: model.updateNewPasswordConfirmation,
              errorText: model.newPasswordConfirmationError,
            ),
            const SizedBox(height: 24.0),
            Button.filled(
              height: 50,
              borderRadius: 14,
              icon: const Icon(Icons.check_rounded, color: AppColors.white, size: 20),
              onPressed: model.isFormValid
                  ? () async {
                      await model.savePassword();
                      if (context.mounted) {
                        if (model.error) {
                          CustomSnackbar.showError(context, model.message);
                        }
                        if (model.success) {
                          Navigator.pop(context);
                          CustomSnackbar.showSuccess(context, 'Password berhasil diperbarui.');
                        }
                      }
                    }
                  : null,
              label: 'Perbarui Password',
              isLoading: model.isBusy,
            ),
          ],
        ),
      ),
    ],
  );
}
