import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselEvent extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final void Function(int index)? onTap;

  const CarouselEvent({
    super.key,
    required this.imageUrls,
    this.height = 180,
    this.onTap,
  });

  @override
  State<CarouselEvent> createState() => _CarouselEventState();
}

class _CarouselEventState extends State<CarouselEvent> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider(
          items: widget.imageUrls.asMap().entries.map((entry) {
            final index = entry.key;
            final url = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => widget.onTap?.call(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, _) => Container(
                        color: AppColors.surfaceAlt,
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          ),
                        ),
                      ),
                      errorWidget: (context, _, __) => Container(
                        color: AppColors.surfaceAlt,
                        child: const Center(
                          child: Icon(Icons.image_outlined, size: 40, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.imageUrls.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        if (widget.imageUrls.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imageUrls.length, (index) {
              final isActive = currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
