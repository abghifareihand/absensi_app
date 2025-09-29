import 'package:absensi_app/features/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/features/auth/splash/splash_view_model.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Permission lokasi dan storage diperlukan!')));
          }
          if (model.isDeviceValid) {
            // ✅ Device valid + token cocok -> HomeView
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
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
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.images.logo.image(width: 200, height: 200),
        const SizedBox(height: 24),
        const CircularProgressIndicator(),
      ],
    ),
  );
}
