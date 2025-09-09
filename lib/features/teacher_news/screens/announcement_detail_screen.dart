import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_colors.dart';
import '../../../core/services/firebase_service.dart';
import '../../../models/announcement_model.dart';

class AnnouncementDetailScreen extends ConsumerWidget {
  final String announcementId;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcementId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الإعلان'),
      ),
      body: StreamBuilder<Announcement?>(
        stream: FirebaseService.announcementsCollection
            .doc(announcementId)
            .snapshots()
            .map((doc) => doc.exists ? Announcement.fromFirestore(doc) : null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'خطأ في تحميل الإعلان',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          }

          final announcement = snapshot.data;
          if (announcement == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.announcement_outlined,
                    size: 64.sp,
                    color: AppColors.grey500,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'الإعلان غير موجود',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type and date
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(announcement.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        _getTypeText(announcement.type),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _getTypeColor(announcement.type),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      announcement.formattedDateTime,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Title
                Text(
                  announcement.title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 16.h),

                // Body
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    announcement.body,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textPrimaryLight,
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Image if available
                if (announcement.hasImage) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      announcement.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200.h,
                          color: AppColors.grey200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 48.sp,
                                  color: AppColors.grey500,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'فشل في تحميل الصورة',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // Location link if available
                if (announcement.hasLocation) ...[
                  Card(
                    child: ListTile(
                      leading: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.accent,
                          size: 20.sp,
                        ),
                      ),
                      title: const Text('عرض الموقع'),
                      subtitle: const Text('اضغط لفتح الموقع في خرائط جوجل'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _launchUrl(announcement.locationLink!),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                // Attachment if available
                if (announcement.hasAttachment) ...[
                  Card(
                    child: ListTile(
                      leading: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          Icons.attach_file,
                          color: AppColors.info,
                          size: 20.sp,
                        ),
                      ),
                      title: const Text('مرفق'),
                      subtitle: const Text('اضغط لتحميل المرفق'),
                      trailing: const Icon(Icons.download),
                      onTap: () => _launchUrl(announcement.attachment!),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
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

  String _getTypeText(String type) {
    switch (type) {
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
