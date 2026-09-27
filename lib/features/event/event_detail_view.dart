import 'package:absensi_app/core/models/event_model.dart';
import 'package:absensi_app/core/utils/formatter.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventDetailView extends StatelessWidget {
  final EventData event;

  const EventDetailView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final hasDate = event.eventDate != null && event.eventDate!.isNotEmpty;
    final hasImage = event.imageUrl != null && event.imageUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Detail Event'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image Hero
            if (hasImage)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: CachedNetworkImage(
                      imageUrl: event.imageUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 220,
                        color: AppColors.surfaceAlt,
                        child: const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Assets.images.placeholder.image(
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Info Badges Row
                  if (hasDate) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.primarySubtle,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                Formatter.toReadableDate(event.eventDate!),
                                style: AppFonts.badge.copyWith(
                                  color: AppColors.primaryDark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${Formatter.toReadableTime(event.eventDate!)} WIB',
                                style: AppFonts.badge.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Title
                  Text(
                    event.title ?? 'Informasi Event',
                    style: AppFonts.h2.copyWith(
                      color: AppColors.textDark,
                      fontSize: 20,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Divider
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppColors.borderLight,
                  ),

                  const SizedBox(height: 18),

                  // Section Header: Deskripsi
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Deskripsi & Rincian',
                        style: AppFonts.semiBold.copyWith(
                          color: AppColors.textDark,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description Text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Text(
                      event.description != null && event.description!.trim().isNotEmpty
                          ? event.description!
                          : 'Tidak ada deskripsi rincian untuk event ini.',
                      style: AppFonts.regular.copyWith(
                        color: AppColors.textDark.withValues(alpha: 0.88),
                        fontSize: 14,
                        height: 1.65,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Notice Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.blueSubtle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Informasi event dapat berubah sewaktu-waktu sesuai ketentuan instansi/kampus penyelenggara.',
                            style: AppFonts.caption.copyWith(
                              color: AppColors.blue,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
