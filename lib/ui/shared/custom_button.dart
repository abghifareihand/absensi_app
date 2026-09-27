import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';

enum ButtonStyleType { filled, outlined }

class Button extends StatelessWidget {
  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.filled,
    this.color = AppColors.primary,
    this.sideColor = AppColors.primary,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 14.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding,
    this.isLoading = false,
  });

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.outlined,
    this.color = Colors.white,
    this.textColor = AppColors.primary,
    this.sideColor = AppColors.primary,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 14.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding,
    this.isLoading = false,
  });

  final Function()? onPressed;
  final String label;
  final ButtonStyleType style;
  final Color color;
  final Color textColor;
  final Color sideColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool disabled;
  final double fontSize;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveDisabled = disabled || isLoading || onPressed == null;

    final content = Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: style == ButtonStyleType.filled ? textColor : color,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Memuat...',
            style: AppFonts.semiBold.copyWith(
              color: style == ButtonStyleType.filled ? textColor : color,
              fontSize: fontSize,
            ),
          ),
        ] else ...[
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              style: AppFonts.semiBold.copyWith(
                color: effectiveDisabled
                    ? (style == ButtonStyleType.filled
                        ? AppColors.white.withValues(alpha: 0.8)
                        : AppColors.textMuted)
                    : textColor,
                fontSize: fontSize,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: 8),
            suffixIcon!,
          ],
        ],
      ],
    );

    return SizedBox(
      height: height,
      width: width,
      child: style == ButtonStyleType.filled
          ? ElevatedButton(
              onPressed: effectiveDisabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: color,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: content,
            )
          : OutlinedButton(
              onPressed: effectiveDisabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                elevation: 0,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: color,
                disabledBackgroundColor: Colors.transparent,
                side: BorderSide(
                  color: effectiveDisabled ? AppColors.border : sideColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: content,
            ),
    );
  }
}
