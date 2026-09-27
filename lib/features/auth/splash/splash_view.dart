import 'package:absensi_app/features/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/features/auth/splash/splash_view_model.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:absensi_app/features/auth/login/login_view.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
      model: SplashViewModel(authApi: Provider.of<AuthApi>(context)),
      onModelReady: (SplashViewModel model) async {
        await model.initModel();

        if (context.mounted) {
          if (!model.hasPermission) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permission lokasi dan storage diperlukan!')),
            );
          }
          if (model.isDeviceValid) {
            // ✅ Device valid + token cocok -> HomeView
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
          } else {
            // ❌ Token kosong / device_id beda -> LoginView
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            );
          }
        }
      },
      onModelDispose: (SplashViewModel model) => model.disposeModel(),
      builder: (BuildContext context, SplashViewModel model, _) {
        return Scaffold(backgroundColor: AppColors.white, body: _buildBody(context, model));
      },
    );
  }
}

Widget _buildBody(BuildContext context, SplashViewModel model) {
  return SafeArea(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(24),
              child: Assets.images.logo.image(width: 140, height: 140, fit: BoxFit.contain),
            ),
            Text(
              'SIM ABSENSI',
              style: AppFonts.h1.copyWith(
                color: AppColors.textDark,
                letterSpacing: 1.2,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sistem Informasi Presensi Terpadu',
              style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat aplikasi...',
              style: AppFonts.caption.copyWith(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
