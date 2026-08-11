import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// 프로필 섹션
// ─────────────────────────────────────────
class ProfileSection extends StatelessWidget {
  final String profileImage;
  final String name;
  final String? rentalTitle;
  final int? rentalDaysLeft;
  final bool isUploadingImage;
  final VoidCallback onTapProfileImage;

  const ProfileSection({
    super.key,
    required this.profileImage,
    required this.name,
    required this.isUploadingImage,
    required this.onTapProfileImage,
    this.rentalTitle,
    this.rentalDaysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: isUploadingImage ? null : onTapProfileImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  child: isUploadingImage
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : profileImage.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 48,
                          color: Colors.grey.shade400,
                        )
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.grey600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          if (rentalTitle != null && rentalDaysLeft != null) ...[
            const SizedBox(height: 6),
            Text(
              '\'$rentalTitle\' 반납까지 $rentalDaysLeft일 남았습니다.',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
