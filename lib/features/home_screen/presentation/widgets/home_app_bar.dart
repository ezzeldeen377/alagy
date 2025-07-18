import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/home_screen_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppUserCubit>().state.user;
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 4,
      backgroundColor: AppColor.primaryColor,
      leading: Container(
        margin: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1), // white border
        ),
        child: CircleAvatar(
          radius: 30, // adjust size as needed
          backgroundImage: CachedNetworkImageProvider(
            user?.profileImage ??
                'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
          ),
        ),
      ),
      title: Column(
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
          icon: const Icon(
            Icons.notifications,
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
      decoration: const BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.only(
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
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        controller.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    hintText: "ابحث هنا",
                    prefixIcon:
                        const Icon(Icons.search, color: AppColor.primaryColor),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ));
            },
            onSelected: (selection) {
              context.pushNamed(RouteNames.doctorDetails, arguments: selection);
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: context.theme.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColor.primaryColor,
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
                                child: CachedNetworkImage(
                                  imageUrl: option.profileImage ??
                                      'https://via.placeholder.com/150',
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
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
