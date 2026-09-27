import 'package:absensi_app/core/api/event_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/core/utils/formatter.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/event/event_detail_view.dart';
import 'package:absensi_app/features/event/event_view_model.dart';
import 'package:absensi_app/features/event/widgets/shimmer_event.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<EventViewModel>(
      model: EventViewModel(eventApi: Provider.of<EventApi>(context)),
      onModelReady: (EventViewModel model) => model.initModel(),
      onModelDispose: (EventViewModel model) => model.disposeModel(),
      builder: (BuildContext context, EventViewModel model, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Event Kampus'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EventViewModel model) {
  if (model.isBusy && model.events.isEmpty) {
    return const ShimmerEvent();
  }

  if (model.events.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum Ada Event',
              style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Saat ini belum ada event atau pengumuman yang dipublikasikan.',
              textAlign: TextAlign.center,
              style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => model.fetchEvent(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Muat Ulang'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async {
      await model.fetchEvent();
    },
    child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: model.events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 18.0),
      itemBuilder: (context, index) {
        final event = model.events[index];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailView(event: event),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Image
                  if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      child: CachedNetworkImage(
                        imageUrl: event.imageUrl!,
                        width: double.infinity,
                        height: 190,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 190,
                          color: AppColors.surfaceAlt,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Assets.images.placeholder.image(
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date & Time Pill
                        if (event.eventDate != null && event.eventDate!.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule_rounded, size: 13, color: AppColors.primary),
                                const SizedBox(width: 5),
                                Text(
                                  Formatter.toReadableDateTime(event.eventDate!),
                                  style: AppFonts.badge.copyWith(
                                    color: AppColors.primaryDark,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Title
                        Text(
                          event.title ?? '-',
                          style: AppFonts.semiBold.copyWith(
                            color: AppColors.textDark,
                            fontSize: 16,
                            height: 1.3,
                          ),
                        ),

                        // Description Preview
                        if (event.description != null && event.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            event.description!,
                            style: AppFonts.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 14),

                        // Action Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lihat Rincian Event',
                              style: AppFonts.semiBold.copyWith(
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primarySubtle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
