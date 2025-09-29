import 'dart:io';
import 'package:absensi_app/ui/shared/custom_button.dart';
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
        Text(label, style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray),
          ),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file,
                color: hasFile ? AppColors.primary : AppColors.gray,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName ?? 'Belum ada file',
                  style: AppFonts.medium.copyWith(
                    color: hasFile ? AppColors.black : AppColors.gray,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasFile && onClear != null) ...[
                GestureDetector(
                  onTap: onClear,
                  child: Icon(Icons.close, color: AppColors.gray),
                ),
                const SizedBox(width: 4),
              ],
            ],
          ),
        ),
        // ✅ Tampilkan error text di bawah container
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppFonts.regular.copyWith(color: Colors.red, fontSize: 12),
          ),
        ],
        const SizedBox(height: 12),
        Button.filled(onPressed: onPickFile, label: 'Pilih File', borderRadius: 50),
      ],
    );
  }
}
