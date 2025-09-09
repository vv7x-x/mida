import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/app_colors.dart';
import '../../../models/announcement_model.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type and time
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _getTypeText(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: _getTypeColor(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    announcement.formattedDateTime,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Title
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 8.h),
              
              // Body preview
              Text(
                announcement.body,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey700,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Attachments indicators
              if (announcement.hasImage || announcement.hasAttachment || announcement.hasLocation) ...[
                SizedBox(height: 12.h),
                Row(
                  children: [
                    if (announcement.hasImage) ...[
                      Icon(
                        Icons.image,
                        size: 16.sp,
                        color: AppColors.grey600,
                      ),
                      SizedBox(width: 4.w),
                    ],
                    if (announcement.hasAttachment) ...[
                      Icon(
                        Icons.attach_file,
                        size: 16.sp,
                        color: AppColors.grey600,
                      ),
                      SizedBox(width: 4.w),
                    ],
                    if (announcement.hasLocation) ...[
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: AppColors.grey600,
                      ),
                      SizedBox(width: 4.w),
                    ],
                    const Spacer(),
                    if (onTap != null)
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.sp,
                        color: AppColors.grey600,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (announcement.type) {
      case 'urgent':
        return AppColors.error;
      case 'schedule_change':
        return AppColors.warning;
      case 'account_status':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  String _getTypeText() {
    switch (announcement.type) {
      case 'urgent':
        return 'عاجل';
      case 'schedule_change':
        return 'تغيير جدول';
      case 'account_status':
        return 'حالة الحساب';
      default:
        return 'عام';
    }
  }
}
