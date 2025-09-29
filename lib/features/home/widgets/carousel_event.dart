import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselEvent extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const CarouselEvent({super.key, required this.imageUrls, this.height = 180});

  @override
  State<CarouselEvent> createState() => _CarouselEventState();
}

class _CarouselEventState extends State<CarouselEvent> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items:
              widget.imageUrls.map((url) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder:
                          (context, _) => Container(color: AppColors.gray.withValues(alpha: 0.2)),
                      errorWidget: (context, _, __) => const Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                );
              }).toList(),
          options: CarouselOptions(
            height: widget.height,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
