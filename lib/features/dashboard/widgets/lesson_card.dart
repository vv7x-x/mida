import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/app_colors.dart';
import '../../../models/lesson_model.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Time indicator
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: lesson.isToday 
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lesson.time.split(':')[0],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: lesson.isToday ? AppColors.primary : AppColors.grey600,
                    ),
                  ),
                  Text(
                    lesson.time.split(':')[1],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: lesson.isToday ? AppColors.primary : AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Lesson details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.subject,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.sp,
                        color: AppColors.grey600,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        lesson.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  if (lesson.teacherName != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14.sp,
                          color: AppColors.grey600,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          lesson.teacherName!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (lesson.duration != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14.sp,
                          color: AppColors.grey600,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${lesson.duration} دقيقة',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Status indicator
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: lesson.isToday 
                    ? AppColors.success.withOpacity(0.1)
                    : lesson.isPast
                        ? AppColors.grey300
                        : AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                lesson.isToday 
                    ? 'اليوم'
                    : lesson.isPast
                        ? 'انتهت'
                        : 'قادمة',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: lesson.isToday 
                      ? AppColors.success
                      : lesson.isPast
                          ? AppColors.grey600
                          : AppColors.info,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
