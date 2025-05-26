import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      elevation: 4,
    
      backgroundColor: AppColor.teal,
      leading: const CircleAvatar(
        backgroundImage: NetworkImage(
          "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?...",
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.greeting("ezzeldeen"),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            context.l10n.howAreYou,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColor.teal.withAlpha(100),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          icon: Icon(
            Icons.notifications,
            color: context.isDark ? AppColor.darkGray : AppColor.white,
          ),
          onPressed: () {},
        ),
      ],
    );

    // 💡 Add the pinned search bar here
    
  }
}

class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  SearchBarHeaderDelegate({required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
              color: AppColor.teal,

          borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        
      ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: context.l10n.searchPlaceholder,
          prefixIcon: const Icon(Icons.search, color: AppColor.teal),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}