import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/features/auth/login/login_view_model.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/home/home_view.dart';
import 'package:absensi_app/ui/shared/custom_button.dart';
import 'package:absensi_app/ui/shared/custom_snackbar.dart';
import 'package:absensi_app/ui/shared/custom_text_field.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      model: LoginViewModel(authApi: Provider.of<AuthApi>(context)),
      onModelReady: (LoginViewModel model) => model.initModel(),
      onModelDispose: (LoginViewModel model) => model.disposeModel(),
      builder: (BuildContext context, LoginViewModel model, _) {
        return Scaffold(backgroundColor: AppColors.white, body: _buildBody(context, model));
      },
    );
  }
}

Widget _buildBody(BuildContext context, LoginViewModel model) {
  return SafeArea(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),

                child: Assets.images.logo.image(width: 120, height: 120, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Selamat Datang',
              style: AppFonts.h1.copyWith(color: AppColors.textDark, fontSize: 24),
            ),
            const SizedBox(height: 6),
            Text(
              'Silakan masuk dengan akun Anda untuk melanjutkan presensi kehadiran.',
              style: AppFonts.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: model.usernameController,
                    label: 'Username',
                    hintText: 'Masukkan username Anda',
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onChanged: model.updateUsername,
                    errorText: model.usernameError,
                  ),
                  const SizedBox(height: 18.0),
                  CustomTextField(
                    controller: model.passwordController,
                    obscureText: true,
                    label: 'Password',
                    hintText: 'Masukkan password Anda',
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: model.updatePassword,
                    errorText: model.passwordError,
                  ),
                  const SizedBox(height: 24.0),
                  Button.filled(
                    height: 50,
                    borderRadius: 14,
                    icon: const Icon(Icons.login_rounded, color: AppColors.white, size: 20),
                    onPressed:
                        model.isFormValid
                            ? () async {
                              await model.login();
                              if (context.mounted) {
                                if (model.error) {
                                  CustomSnackbar.showError(context, model.message);
                                }
                                if (model.success) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => const HomeView()),
                                  );
                                }
                              }
                            }
                            : null,
                    label: 'Masuk Sekarang',
                    isLoading: model.isBusy,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Terhubung dengan Device ID & Lokasi Aman',
                    style: AppFonts.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
