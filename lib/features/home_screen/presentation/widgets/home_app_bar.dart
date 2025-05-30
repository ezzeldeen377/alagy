import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 4,
      backgroundColor: AppColor.teal,
      leading: Container(
        margin: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1), // white border
        ),
        child: const CircleAvatar(
          radius: 30, // adjust size as needed
          backgroundImage: NetworkImage(
            "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?...",
          ),
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
                  color: AppColor.white,
                ),
          ),
          Text(
            context.l10n.howAreYou,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColor.white,
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
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  SearchBarHeaderDelegate({required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final searchCubit = context.read<HomeScreenCubit>();

    // Add a listener to trigger the cubit call
    _controller.addListener(() {
      final text = _controller.text;
      if (text.isNotEmpty) {
        searchCubit.getSearchDoctors(text);
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.teal,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          return RawAutocomplete<DoctorModel>(
            focusNode: _focusNode,
            textEditingController: _controller,
            displayStringForOption: (doctor) => doctor.name,
            optionsBuilder: (TextEditingValue value) {
              // Use current state, don't fetch here
              return state.searchDoctors ?? [];
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: AppColor.teal),
                    onPressed: () {
                      controller.clear();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  hintText: "ابحث هنا",
                  prefixIcon: const Icon(Icons.search, color: AppColor.teal),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.darkTeal.withOpacity(.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColor.lgGreyColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.darkTeal.withOpacity(.8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                ),
              );
            },
            onSelected: (selection) {
              context.push(DoctorDetailPage(
                doctor: selection,
              ));
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: AppColor.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColor.teal,
                        width: 1,
                      )),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32.w,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    12.r), // adjust as needed
                                child: Image.network(
                                  option.profileImage ??
                                      'https://via.placeholder.com/150',
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                option.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2.h),
                                  Text(option.specialization ??
                                      'Unknown Specialty'),
                                  SizedBox(height: 2.h),
                                  Text(
                                    option.hospitalName ?? '',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    option.city ?? '',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () => onSelected(option),
                            ),
                          );
                        }),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
