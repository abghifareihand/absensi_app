import 'package:absensi_app/core/api/attendance_api.dart';
import 'package:absensi_app/core/api/attendance_point_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
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
        return Scaffold(backgroundColor: AppColors.white, body: _buildBody(context, model));
      },
    );
  }
}

Widget _buildBody(BuildContext context, AttendanceViewModel model) {
  if (model.isBusy) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Mendapatkan lokasi...',
            style: AppFonts.medium.copyWith(color: AppColors.primary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  if (model.userLocation == null) {
    return Center(
      child: Text(
        model.errorMessage.isNotEmpty ? model.errorMessage : "Lokasi tidak ditemukan",
        style: AppFonts.medium.copyWith(color: Colors.red, fontSize: 12),
      ),
    );
  }
  return Stack(
    children: [
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

          // Marker User
          MarkerLayer(
            markers: [
              Marker(
                point: model.userLocation!,
                width: 18,
                height: 18,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Marker Titik Absen
          MarkerLayer(
            markers:
                model.attendancePoints.map((point) {
                  return Marker(
                    point: LatLng(point.latitude, point.longitude),
                    width: 32,
                    height: 32,
                    child: GestureDetector(
                      onTap: () => model.selectMarker(point),
                      child: Assets.svg.iconLocation.svg(
                        colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),

      /// Tombol Back di kiri atas
      Positioned(
        top: 40,
        left: 16,
        right: 16,
        child: Row(
          children: [
            // Tombol back
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Assets.svg.iconBack.svg(),
              ),
            ),

            const SizedBox(width: 12),

            // Container untuk info marker
            if (model.selectedMarker != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Assets.svg.iconLocation.svg(
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${model.selectedMarkerName}',
                        style: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),

      // ======= DRAGGABLE BOTTOM SHEET =======
      DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.2,
        maxChildSize: 0.2,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Absen di ${model.attendancePointNearest!.name}',
                    style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 16),
                  ),

                  Text(
                    'Tekan tombol di bawah untuk Check-in / Check-out',
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                  ),
                  Spacer(),
                  Button.filled(
                    onPressed: () async {
                      await model.checkAttendance();
                    },
                    label: 'Absen',
                    isLoading: model.isLoadingPressed,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          );
        },
      ),

      Positioned(
        bottom: 0.2 * MediaQuery.of(context).size.height + 8,
        left: 16,
        right: 16,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              model.message.isNotEmpty
                  ? Container(
                    key: const ValueKey("visible"),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: model.error ? Colors.red[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          model.error ? Icons.error : Icons.check_circle,
                          color: model.error ? Colors.red : Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            model.message,
                            style: AppFonts.medium.copyWith(
                              color: model.error ? Colors.red[900] : Colors.green[900],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(
                    key: ValueKey("hidden"), // 👈 key saat kosong
                  ),
        ),
      ),

      // ======= END DRAGGABLE BOTTOM SHEET =======
      Positioned(
        bottom: 0.2 * MediaQuery.of(context).size.height + 52,
        left: 16,
        right: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: model.zoomIn,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: model.zoomOut,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.remove),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: model.moveToCurrentLocation,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
