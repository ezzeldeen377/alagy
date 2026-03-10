import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/constants/app_constants.dart';
import 'package:alagy/core/di/di.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/helpers/notification_service.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/home_screen/presentation/bloc/bookmark/cubit/bookmark_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home/home_screen_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/my_booking/my_booking_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/search/search_cubit.dart';
import 'package:alagy/features/home_screen/presentation/pages/bookmark_screen.dart';
import 'package:alagy/features/home_screen/presentation/pages/home_creen.dart';
import 'package:alagy/features/home_screen/presentation/pages/my_bookiing_screen.dart';
import 'package:alagy/features/home_screen/presentation/pages/search_screen.dart';
import 'package:alagy/features/settings/presentation/profile_screen.dart';
import 'package:alagy/features/settings/presentation/settings_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    if (context.read<AppUserCubit>().state.isNotLogin) {
      return;
    }
    context.read<AppUserCubit>().updateNotificationToken(
        context.read<AppUserCubit>().state.user!, NotificationService.fcmToken);
    context.read<AppUserCubit>().getAllFavouriteDoctors(
        context.read<AppUserCubit>().state.user?.uid ?? '');
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    const maxDuration = Duration(seconds: 2);

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > maxDuration) {
      _lastBackPressed = now;

      // Show snackbar
      showSnackBar(context, context.l10n.pressBackAgainToExit);

      return false; // Don't exit
    }

    // Exit the app
    SystemNavigator.pop();
    return true;
  }

  // Change the selected tab
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pop(); // Close drawer
  }

  // Get the appropriate screen based on the selected index
  Widget _getScreenForIndex() {
    switch (_currentIndex) {
      case 0:
        return BlocProvider(
          create: (context) => getIt<HomeScreenCubit>()
            ..getVipDoctors()
            ..getTopRatedDoctors(),
          child: const HomeScreen(),
        );
      case 1:
        return BlocProvider(
          create: (context) {
            if (context.read<AppUserCubit>().state.isNotLogin) {
              return getIt<BookmarkCubit>();
            }
            return getIt<BookmarkCubit>()
              ..getAllFavouriteDoctors(
                  context.read<AppUserCubit>().state.user?.uid ?? '');
          },
          child: const BookmarkScreen(),
        );
      case 2:
        return BlocProvider(
          create: (context) => getIt<SearchCubit>(),
          child: const SearchScreen(),
        );
      case 3:
        return BlocProvider(
          create: (context) => getIt<MyBookingCubit>()
            ..getMyBookings(context.read<AppUserCubit>().state.user?.uid ?? ''),
          child: const MyBookiingScreen(),
        );
      case 4:
        return const ProfileScreen();
      default:
        return BlocProvider(
          create: (context) => getIt<HomeScreenCubit>()
            ..getVipDoctors()
            ..getTopRatedDoctors(),
          child: const HomeScreen(),
        );
    }
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return context.l10n.home;
      case 1:
        return context.l10n.bookmarks;
      case 2:
        return context.l10n.search;
      case 3:
        return context.l10n.myBookings;
      case 4:
        return context.l10n.profile;
      default:
        return context.l10n.home;
    }
  }

  Widget _buildCustomAppBar() {
    final user = context.read<AppUserCubit>().state.user;

    return AppBar(
      elevation: 4,
      centerTitle: false,
      backgroundColor: AppColor.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: _currentIndex == 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.greeting(user?.name ?? ''),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.whiteColor,
                      ),
                ),
                Text(
                  context.l10n.howAreYou,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: AppColor.whiteColor,
                      ),
                ),
              ],
            )
          : Text(
              _getAppBarTitle(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColor.primaryColor.withAlpha(100),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          icon: const Icon(Icons.notifications),
          onPressed: () {
            context.pushNamed(RouteNames.notifications);
          },
        ),
        if (_currentIndex == 0)
          Container(
            margin: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.grey[200],
              child: GestureDetector(
                onTap: ()=>context.pushNamed(RouteNames.profile),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user?.profileImage ??
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                    width: 36.w,
                    height: 36.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 20.r,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildDrawer() {
    final user = context.read<AppUserCubit>().state.user;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      child: Column(
        children: [
          // Enhanced Drawer Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor,
                  AppColor.primaryColor.withOpacity(0.8),
                  const Color(0xFF1565C0)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Avatar with enhanced styling
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40.r,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user?.profileImage ??
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 45.r,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // User Name with enhanced typography
                    Text(
                      user?.name ?? context.l10n.guestUser,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // User Email with enhanced styling
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Enhanced Drawer Items
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                children: [
                  SizedBox(height: 8.h),
                  _buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: context.l10n.home,
                    index: 0,
                  ),
                  _buildDrawerItem(
                    icon: Icons.bookmark_rounded,
                    title: context.l10n.bookmarks,
                    index: 1,
                  ),
                  _buildDrawerItem(
                    icon: Icons.search_rounded,
                    title: context.l10n.search,
                    index: 2,
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today_rounded,
                    title: context.l10n.myBookings,
                    index: 3,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_rounded,
                    title: context.l10n.profile,
                    index: 4,
                  ),

                  // Enhanced Divider
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Enhanced Logout/Sign In Item
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.read<AppUserCubit>().state.isNotLogin
                            ? AppColor.primaryColor.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 4.h,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: context.read<AppUserCubit>().state.isNotLogin
                              ? AppColor.primaryColor.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          context.read<AppUserCubit>().state.isNotLogin
                              ? Icons.login_rounded
                              : Icons.logout_rounded,
                          color: context.read<AppUserCubit>().state.isNotLogin
                              ? AppColor.primaryColor
                              : Colors.red,
                          size: 20.r,
                        ),
                      ),
                      title: Text(
                        context.read<AppUserCubit>().state.isNotLogin
                            ? context.l10n.signIn
                            : (context.l10n.logout),
                        style: TextStyle(
                          color: context.read<AppUserCubit>().state.isNotLogin
                              ? AppColor.primaryColor
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (context.read<AppUserCubit>().state.isNotLogin) {
                          // Navigate to sign in screen
                          context.pushNamed(RouteNames.signIn);
                        } else {
                          // Show logout dialog
                          showLogoutDialog(context);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: isSelected
            ? AppColor.primaryColor.withOpacity(0.12)
            : Colors.transparent,
        border: isSelected
            ? Border.all(
                color: AppColor.primaryColor.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 4.h,
        ),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primaryColor.withOpacity(0.15)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColor.primaryColor : Colors.grey[600],
            size: 20.r,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColor.primaryColor
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 16.sp,
            letterSpacing: 0.2,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              )
            : null,
        onTap: () => _onTabSelected(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state.isClearUserData) {
          context.pushNamedAndRemoveAll(RouteNames.signIn);
        }
        if (state.isSignOut) {
          context.read<AppUserCubit>().clearUserData();
        }
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          drawerScrimColor: Colors.black.withOpacity(0.3),
          drawerEdgeDragWidth: 20.w,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: _buildCustomAppBar(),
          ),
          drawer: _buildDrawer(),
          body: _getScreenForIndex(),
        ),
      ),
    );
  }
}
