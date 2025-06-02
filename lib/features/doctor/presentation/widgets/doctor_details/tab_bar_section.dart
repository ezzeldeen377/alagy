import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: AppColor.teal, width: .5)),
          child: TabBar(
            controller: _tabController,
            indicatorPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
            children: [
              BookingTab(),
              ReviewTab(),
            ],
          ),
        ),
      ],
    );
  }
}
