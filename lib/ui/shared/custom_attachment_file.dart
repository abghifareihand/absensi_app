import 'dart:io';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';

class CustomAttachmentFile extends StatelessWidget {
  final String? fileName;
  final File? file;
  final VoidCallback onPickFile;
  final String label;
  final VoidCallback? onClear;
  final String? errorText; 

  const CustomAttachmentFile({
    super.key,
    required this.onPickFile,
    required this.label,
    this.onClear,
    this.file,
    this.fileName,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null && fileName!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.semiBold.copyWith(
            color: AppColors.textDark,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPickFile,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: hasFile ? AppColors.primarySubtle : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasFile ? AppColors.primary : AppColors.border,
                width: hasFile ? 1.5 : 1.0,
              ),
              boxShadow: AppColors.softShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: hasFile ? AppColors.primary : AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    hasFile ? Icons.file_present_rounded : Icons.cloud_upload_outlined,
                    color: hasFile ? AppColors.white : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasFile ? fileName! : 'Pilih dokumen lampiran',
                        style: AppFonts.semiBold.copyWith(
                          color: hasFile ? AppColors.textDark : AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasFile ? 'Ketuk untuk mengganti file' : 'Format PDF, JPG, atau PNG (Maks 5MB)',
                        style: AppFonts.caption.copyWith(
                          color: hasFile ? AppColors.primaryDark : AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasFile && onClear != null) ...[
                  Material(
                    color: AppColors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onClear,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppFonts.regular.copyWith(color: AppColors.red, fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }
}
