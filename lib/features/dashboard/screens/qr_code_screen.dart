import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../config/app_colors.dart';
import '../../../config/localization.dart';
import '../../../core/providers/auth_provider.dart';

class QrCodeScreen extends ConsumerWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.qrCode),
      ),
      body: currentUser.when(
        data: (student) => student != null
            ? SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    
                    // Student Info Card
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40.r,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                student.fullName.substring(0, 1),
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              student.fullName,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'ID: ${student.id}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey600,
                              ),
                            ),
                            Text(
                              'المركز: ${student.center}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // QR Code
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          children: [
                            Text(
                              'رمز الحضور',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  width: 2,
                                ),
                              ),
                              child: QrImageView(
                                data: student.id,
                                version: QrVersions.auto,
                                size: 200.w,
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'اعرض هذا الرمز للمعلم لتسجيل الحضور',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Instructions
                    Card(
                      color: AppColors.info.withOpacity(0.1),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.info,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'تعليمات الاستخدام',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            _buildInstruction('1. اعرض الرمز للمعلم في بداية الحصة'),
                            _buildInstruction('2. تأكد من وضوح الرمز وعدم وجود انعكاسات'),
                            _buildInstruction('3. انتظر تأكيد المعلم لتسجيل الحضور'),
                            _buildInstruction('4. احتفظ بالهاتف مشحوناً لضمان عمل التطبيق'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text('لا يمكن تحميل بيانات الطالب'),
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
                'خطأ في تحميل البيانات',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            margin: EdgeInsets.only(top: 8.h, right: 8.w),
            decoration: BoxDecoration(
              color: AppColors.info,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
