import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/app_colors.dart';
import '../../../config/localization.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../routes/app_router.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/lesson_card.dart';
import '../widgets/announcement_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final todayLessons = ref.watch(todayLessonsProvider);
    final recentAnnouncements = ref.watch(recentAnnouncementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(AppRouter.settings),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayLessonsProvider);
          ref.invalidate(recentAnnouncementsProvider);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              currentUser.when(
                data: (student) => student != null
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً، ${student.fullName}',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'المركز: ${student.center}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.white.withOpacity(0.9),
                              ),
                            ),
                            Text(
                              'المرحلة: ${student.stage}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.white.withOpacity(0.9),
                              ),
                            ),
                            if (student.isPending) ...[
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'في انتظار الموافقة',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => Container(
                  width: double.infinity,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => const SizedBox.shrink(),
              ),

              SizedBox(height: 24.h),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: localizations.qrCode,
                      icon: Icons.qr_code,
                      color: AppColors.primary,
                      onTap: () => context.go(AppRouter.qrCode),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: DashboardCard(
                      title: localizations.teacherNews,
                      icon: Icons.announcement,
                      color: AppColors.accent,
                      onTap: () => context.go(AppRouter.teacherNews),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Today's Lessons
              Text(
                'حصص اليوم',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              SizedBox(height: 12.h),
              todayLessons.when(
                data: (lessons) => lessons.isNotEmpty
                    ? Column(
                        children: lessons
                            .map((lesson) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: LessonCard(lesson: lesson),
                                ))
                            .toList(),
                      )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 48.sp,
                              color: AppColors.grey500,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'لا توجد حصص اليوم',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Container(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'خطأ في تحميل الحصص: $error',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Recent Announcements
              Text(
                'آخر الإعلانات',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              SizedBox(height: 12.h),
              recentAnnouncements.when(
                data: (announcements) => announcements.isNotEmpty
                    ? Column(
                        children: announcements
                            .take(3)
                            .map((announcement) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: AnnouncementCard(
                                    announcement: announcement,
                                    onTap: () => context.go(
                                      '${AppRouter.announcementDetail}/${announcement.id}',
                                    ),
                                  ),
                                ))
                            .toList(),
                      )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.notifications_off,
                              size: 48.sp,
                              color: AppColors.grey500,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'لا توجد إعلانات جديدة',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Container(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'خطأ في تحميل الإعلانات: $error',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // View All Announcements Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go(AppRouter.teacherNews),
                  child: Text('عرض جميع الإعلانات'),
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
