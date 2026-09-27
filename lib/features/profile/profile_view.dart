import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/models/profile_model.dart';
import 'package:absensi_app/features/auth/login/login_view.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/profile/edit-password/edit_password_view.dart';
import 'package:absensi_app/features/profile/edit-profile/edit_profile_view.dart';
import 'package:absensi_app/features/profile/profile_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/shared/custom_button.dart';
import 'package:absensi_app/ui/shared/custom_snackbar.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      model: ProfileViewModel(authApi: Provider.of<AuthApi>(context)),
      onModelReady: (ProfileViewModel model) => model.initModel(),
      onModelDispose: (ProfileViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ProfileViewModel model, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Akun Pengguna'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, ProfileViewModel model) {
  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
    children: [
      // Profile Header Card
      ProfileHeader(isLoading: model.isBusy, user: model.user),

      const SizedBox(height: 24.0),

      // Section Menu Title
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          'Pengaturan Akun',
          style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 15),
        ),
      ),

      const SizedBox(height: 12.0),

      // Menu Group Card
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            profileMenuItem(
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.primary,
              iconBgColor: AppColors.primarySubtle,
              title: 'Informasi Akun',
              subtitle: 'Lihat dan perbarui data profil pribadi',
              onPressed: () async {
                if (model.user == null) return;
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileView(user: model.user!)),
                );
                if (result == true) {
                  await model.fetchProfile();
                }
              },
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.borderLight, indent: 68),
            profileMenuItem(
              icon: Icons.lock_outline_rounded,
              iconColor: AppColors.orange,
              iconBgColor: AppColors.orangeSubtle,
              title: 'Ubah Password',
              subtitle: 'Perbarui kata sandi login Anda',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditPasswordView()),
                );
              },
            ),
          ],
        ),
      ),

      const SizedBox(height: 32.0),

      // Logout Button
      Button.filled(
        height: 50,
        borderRadius: 14,
        icon: const Icon(Icons.logout_rounded, color: AppColors.white, size: 20),
        onPressed: () => _showLogoutConfirmDialog(context, model),
        label: 'Keluar dari Akun',
        color: AppColors.red,
        isLoading: model.isBusy,
      ),

      const SizedBox(height: 16),
      Center(
        child: Text(
          'SIM Absensi v1.0.0',
          style: AppFonts.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
        ),
      ),
    ],
  );
}

void _showLogoutConfirmDialog(BuildContext context, ProfileViewModel model) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.redSubtle,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout_rounded, color: AppColors.red, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Konfirmasi Keluar',
            style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 16),
          ),
        ],
      ),
      content: Text(
        'Apakah Anda yakin ingin keluar dari aplikasi presensi ini?',
        style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(
            'Batal',
            style: AppFonts.medium.copyWith(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await model.logout();
            if (context.mounted) {
              if (model.error) {
                CustomSnackbar.showError(context, model.message);
              }
              if (model.success) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Keluar',
            style: AppFonts.semiBold.copyWith(color: AppColors.white),
          ),
        ),
      ],
    ),
  );
}

Widget profileMenuItem({
  required IconData icon,
  required Color iconColor,
  required Color iconBgColor,
  required String title,
  required String subtitle,
  required VoidCallback onPressed,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: iconBgColor,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    ),
  );
}

class ProfileHeader extends StatelessWidget {
  final bool isLoading;
  final User? user;

  const ProfileHeader({super.key, required this.isLoading, this.user});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer();
    }
    return _buildContent();
  }

  Widget _buildContent() {
    final initial = (user?.name != null && user!.name!.isNotEmpty)
        ? user!.name![0].toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Center(
              child: Text(
                initial,
                style: AppFonts.h1.copyWith(color: AppColors.primary, fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Name
          Text(
            user?.name ?? 'Nama Pengguna',
            style: AppFonts.h2.copyWith(color: AppColors.textDark, fontSize: 18),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Email
          if (user?.email != null) ...[
            Text(
              user!.email!,
              style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],

          // Role Badge & Identity Number
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (user?.role != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    user!.role!.toUpperCase(),
                    style: AppFonts.badge.copyWith(color: AppColors.primaryDark, fontSize: 11),
                  ),
                ),
              if (user?.identityNumber != null && user!.identityNumber!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'ID: ${user!.identityNumber}',
                    style: AppFonts.badge.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(width: 150, height: 18, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 180, height: 14, color: Colors.white),
            const SizedBox(height: 12),
            Container(width: 80, height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
          ],
        ),
      ),
    );
  }
}
