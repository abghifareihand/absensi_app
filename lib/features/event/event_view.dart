import 'package:absensi_app/core/api/event_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/core/utils/formatter.dart';
import 'package:absensi_app/features/base_view.dart';
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
          appBar: CustomAppBar(title: 'Event'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, EventViewModel model) {
  if (model.isBusy) {
    return ShimmerEvent();
  }

  if (model.events.isEmpty) {
    return Center(
      child: Text(
        'Belum ada data event',
        style: AppFonts.medium.copyWith(color: AppColors.primary, fontSize: 14),
      ),
    );
  }
  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchEvent();
    },
    child: ListView.separated(
      padding: EdgeInsets.all(20),
      itemCount: model.events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final event = model.events[index];
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorWidget:
                      (context, url, error) =>
                          Assets.images.placeholder.image(width: double.infinity, height: 200),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.title,
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 16),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    Formatter.toReadableTime(event.eventDate),
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
