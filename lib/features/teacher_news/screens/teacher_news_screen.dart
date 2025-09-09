import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/app_colors.dart';
import '../../../config/localization.dart';
import '../../../core/providers/data_providers.dart';
import '../../../routes/app_router.dart';
import '../../dashboard/widgets/announcement_card.dart';

class TeacherNewsScreen extends ConsumerWidget {
  const TeacherNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final announcements = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.teacherNews),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(announcementsProvider);
        },
        child: announcements.when(
          data: (announcementList) => announcementList.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: announcementList.length,
                  itemBuilder: (context, index) {
                    final announcement = announcementList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: AnnouncementCard(
                        announcement: announcement,
                        onTap: () => context.go(
                          '${AppRouter.announcementDetail}/${announcement.id}',
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 64.sp,
                        color: AppColors.grey500,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'لا توجد إعلانات',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.grey600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'سيتم عرض الإعلانات الجديدة هنا',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
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
                  'خطأ في تحميل الإعلانات',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.error,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  error.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => ref.invalidate(announcementsProvider),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
