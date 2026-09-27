import 'package:absensi_app/core/api/attendance_api.dart';
import 'package:absensi_app/core/api/attendance_point_api.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/attendance/attendance_view_model.dart';
import 'package:absensi_app/ui/shared/custom_button.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<AttendanceViewModel>(
      model: AttendanceViewModel(
        attendancePointApi: Provider.of<AttendancePointApi>(context),
        attendanceApi: Provider.of<AttendanceApi>(context),
      ),
      onModelReady: (AttendanceViewModel model) => model.initModel(),
      onModelDispose: (AttendanceViewModel model) => model.disposeModel(),
      builder: (BuildContext context, AttendanceViewModel model, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, AttendanceViewModel model) {
  if (model.isBusy) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Menghubungkan GPS...',
              style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Mohon tunggu sebentar',
              style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  if (model.userLocation == null) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off_rounded, size: 48, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              'Lokasi Tidak Ditemukan',
              style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              model.errorMessage.isNotEmpty ? model.errorMessage : "Pastikan izin lokasi telah diaktifkan.",
              textAlign: TextAlign.center,
              style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Button.filled(
              onPressed: () => model.initModel(),
              label: 'Coba Lagi',
              height: 44,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }

  final nearestPointName = model.attendancePointNearest?.name ?? 'Memeriksa lokasi...';

  return Stack(
    children: [
      // Peta
      FlutterMap(
        mapController: model.mapController,
        options: MapOptions(
          initialCenter: model.userLocation!,
          initialZoom: model.currentZoom,
          minZoom: 10,
          maxZoom: 18,
          onMapReady: () {
            model.mapController.move(model.userLocation!, 18);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/openstreetmap/{z}/{x}/{y}.png?key={apiKey}',
            additionalOptions: const {'apiKey': 'PWEwzUmmSlADlrtQlXEh'},
            userAgentPackageName: 'com.example.absensi_app',
            tileProvider: FMTCStore('mapStore').getTileProvider(),
          ),

          // Marker User Location
          MarkerLayer(
            markers: [
              Marker(
                point: model.userLocation!,
                width: 32,
                height: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),

          // Marker Titik Absen
          MarkerLayer(
            markers: model.attendancePoints.map((point) {
              final pointLatLng = LatLng(point.latitude, point.longitude);
              final isSelected = model.selectedMarker == pointLatLng;
              return Marker(
                point: pointLatLng,
                width: 44,
                height: 44,
                child: GestureDetector(
                  onTap: () => model.selectMarker(point),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : AppColors.primary,
                        width: 2,
                      ),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: isSelected ? Colors.white : AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),

      // Top Floating Header Bar
      Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Row(
          children: [
            Material(
              color: AppColors.surface,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (model.selectedMarker != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primarySubtle,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.pin_drop_rounded, color: AppColors.primary, size: 14),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${model.selectedMarkerName}',
                          style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),

      // Peringatan Fake GPS Banner
      if (model.isMockLocationDetected)
        Positioned(
          top: MediaQuery.of(context).padding.top + 64,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.redSubtle,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.red, width: 1.5),
              boxShadow: AppColors.softShadow,
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    model.errorMessage.isNotEmpty ? model.errorMessage : 'Fake GPS terdeteksi! Harap gunakan GPS asli.',
                    style: AppFonts.medium.copyWith(color: AppColors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),

      // Floating Map Action Buttons (Right Side)
      Positioned(
        bottom: 220,
        right: 16,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: model.zoomIn,
                icon: const Icon(Icons.add_rounded, color: AppColors.textDark),
                tooltip: 'Perbesar',
              ),
              Container(width: 24, height: 1, color: AppColors.border),
              IconButton(
                onPressed: model.zoomOut,
                icon: const Icon(Icons.remove_rounded, color: AppColors.textDark),
                tooltip: 'Perkecil',
              ),
              Container(width: 24, height: 1, color: AppColors.border),
              IconButton(
                onPressed: model.moveToCurrentLocation,
                icon: const Icon(Icons.my_location_rounded, color: AppColors.primary),
                tooltip: 'Lokasi Saya',
              ),
            ],
          ),
        ),
      ),

      // Floating Status Toast Message
      Positioned(
        bottom: 215,
        left: 20,
        right: 80,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: model.message.isNotEmpty
              ? Container(
                  key: const ValueKey("visible"),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: model.error ? AppColors.redSubtle : AppColors.greenSubtle,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: model.error ? AppColors.red : AppColors.green,
                    ),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        model.error ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                        color: model.error ? AppColors.red : AppColors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          model.message,
                          style: AppFonts.medium.copyWith(
                            color: model.error ? AppColors.red : AppColors.primaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey("hidden")),
        ),
      ),

      // Bottom Attendance Action Card
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppColors.floatShadow,
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.location_city_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Presensi Terdekat',
                            style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nearestPointName,
                            style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Button.filled(
                  height: 52,
                  borderRadius: 16,
                  icon: const Icon(Icons.fingerprint_rounded, color: AppColors.white, size: 22),
                  onPressed: model.isMockLocationDetected
                      ? null
                      : () async {
                          await model.checkAttendance();
                        },
                  label: model.isMockLocationDetected ? 'Fake GPS Terdeteksi' : 'Catat Kehadiran Sekarang',
                  isLoading: model.isLoadingPressed,
                  color: model.isMockLocationDetected ? AppColors.textMuted : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
