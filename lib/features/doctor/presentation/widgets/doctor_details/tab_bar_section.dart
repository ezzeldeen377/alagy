import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/theme/font_weight_helper.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/booking_tab.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/review_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarSection extends StatefulWidget {
  const TabBarSection({super.key});

  @override
  State<TabBarSection> createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
         
          child: TabBar(
            controller: _tabController,
           indicatorSize: TabBarIndicatorSize.tab,
                        dividerHeight: 0,
                        indicator: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryColor.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: AppColor.whiteColor,
                        unselectedLabelColor: AppColor.greyColor,
                        labelStyle: context.theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeightHelper.bold),
            tabs: [
              Tab(text: context.l10n.appointment),
              Tab(text: context.l10n.reviews),
            ],
          ),
        ),
        SizedBox(height:  15.h),
        SizedBox(
          height: 500.h, // Adjust the height as needed
          child: TabBarView(
            controller: _tabController,
            children:const  [
              BookingTab(),
              ReviewTab(),
            ],
          ),
        ),
      ],
    );
  }
}
