import 'dart:developer';

import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/widgets/language_selection_bottom_sheet.dart';
import 'package:alagy/core/widgets/sign_in_required_widget.dart';
import 'package:alagy/features/settings/cubit/app_settings_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/dfareporting/v4.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Modern color scheme as requested
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentAmber = Color(0xFFC107);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
  static const Color cardWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : lightGrey,
      body: BlocListener<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state.state == AppUserStates.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            // Check if user is not signed in
            if (state.isNotLoggedIn || state.isNotLogin) {
              return SignInRequiredWidget();
            }

            final user = state.user;
            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(color: primaryBlue),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    // Profile Avatar Section
                    _buildProfileAvatar(user, isDarkMode),
                    SizedBox(height: 20.h),

                    // Name and Email
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: darkGrey,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // Edit Profile Button
                    _buildEditProfileButton(isDarkMode, context),
                    SizedBox(height: 20.h),

                    // Menu Options Section
                    _buildMenuOptionsSection(isDarkMode, context),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(user, bool isDarkMode) {
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: user.profileImage != null
                ? CachedNetworkImage(
                    imageUrl: user.profileImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: lightGrey,
                      child: const Center(
                        child: CircularProgressIndicator(color: primaryBlue),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        _buildDefaultAvatar(user.name),
                  )
                : _buildDefaultAvatar(user.name),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: primaryBlue,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? const Color(0xFF121212) : Colors.white,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileButton(bool isDarkMode, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (context.read<AppUserCubit>().state.user?.type ==
              Role.doctor.name) {
            log("1");
            Navigator.pushNamed(
              context,
              RouteNames.editDoctor,
              arguments: context.read<AppUserCubit>().state.user,
            );
          } else {
            log("2");
            Navigator.pushNamed(context, RouteNames.editProfile);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              context.l10n.editProfile,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptionsSection(bool isDarkMode, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.person_outline,
            title: context.l10n.personalData,
            subtitle: context.l10n.personalDataArabic,
            iconColor: const Color(0xFF64B5F6),
            isDarkMode: isDarkMode,
            onTap: () {
              // Navigate to personal data
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.account_balance_wallet_outlined,
            title: context.l10n.payment,
            subtitle: context.l10n.paymentArabic,
            iconColor: const Color(0xFF81C784),
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pushNamed(context, RouteNames.paymentHistory);
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.dark_mode_outlined,
            title: context.l10n.theme,
            subtitle: context.l10n.themeArabic,
            iconColor: const Color(0xFF90A4AE),
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                context.read<AppSettingsCubit>().toggleTheme();
              },
              activeColor: AppColor.primaryColor,
            ),
            onTap: null, // Disabled since we have switch
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.vpn_key_outlined,
            title: context.l10n.changePassword,
            subtitle: context.l10n.changePasswordArabic,
            iconColor: const Color(0xFF42A5F5),
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pushNamed(context, RouteNames.changePassword);
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.language,
            title: context.l10n.language,
            subtitle: context.l10n.languageArabic,
            iconColor: const Color(0xFFE57373),
            isDarkMode: isDarkMode,
            trailing: Text(
              context.read<AppSettingsCubit>().state.locale.languageCode == 'ar'
                  ? context.l10n.arabic
                  : context.l10n.english,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColor.greyColor,
                fontFamily: 'Inter',
              ),
            ),
            onTap: () {
              LanguageSelectionBottomSheet.show(context);
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.headset_mic_outlined,
            title: context.l10n.contactUs,
            subtitle: context.l10n.contactUsArabic,
            iconColor: const Color(0xFFFFD54F),
            isDarkMode: isDarkMode,
            onTap: () {
              // Navigate to contact us
              _showContactUsDialog(context);
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.privacy_tip_outlined,
            title: context.l10n.privacyPolicy,
            subtitle: context.l10n.privacyPolicyArabic,
            iconColor: const Color(0xFFAB47BC),
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pushNamed(context, RouteNames.privacyPolicy);
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.receipt_long_outlined,
            title: context.l10n.refundPolicy,
            subtitle: context.l10n.refundPolicyArabic,
            iconColor: const Color(0xFFFF7043),
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pushNamed(context, RouteNames.refundPolicy);
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.logout,
            title: context.l10n.logout,
            subtitle: context.l10n.logoutArabic,
            iconColor: const Color(0xFFE57373),
            isDarkMode: isDarkMode,
            onTap: () {
              // Show logout confirmation dialog
              _showLogoutDialog(context);
            },
          ),
          _buildDivider(isDarkMode),
          _buildMenuTile(
            icon: Icons.delete_forever,
            title: context.l10n.deleteAccount,
            subtitle: context.l10n.deleteAccountArabic,
            iconColor: const Color(0xFFEF5350),
            isDarkMode: isDarkMode,
            onTap: () {
              // Show delete account confirmation dialog
              _showDeleteAccountDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required bool isDarkMode,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      leading: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : Colors.black87,
          fontFamily: 'Inter',
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: darkGrey,
          ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      indent: 20.w,
      endIndent: 20.w,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showLogoutDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            context.l10n.logout,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
              fontFamily: 'Inter',
            ),
          ),
          content: Text(
            context.l10n.areYouSureLogout,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.l10n.cancel,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: darkGrey,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AppUserCubit>().onSignOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE57373),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                context.l10n.logout,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            context.l10n.deleteAccountConfirmation,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
              fontFamily: 'Inter',
            ),
          ),
          content: Text(
            context.l10n.areYouSureDeleteAccount,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.l10n.cancel,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: darkGrey,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AppUserCubit>().deleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                context.l10n.delete,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showContactUsDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.contactUs,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 24.h),
            _buildContactItem(
              context,
              icon: Icons.email_outlined,
              title: context.l10n.email,
              value: "support@alagy.com",
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 16.h),
            _buildContactItem(
              context,
              icon: Icons.phone_outlined,
              title: context.l10n.phoneNumber,
              value: "+20 123 456 7890",
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required bool isDarkMode,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: darkGrey,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
