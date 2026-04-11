import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/features/home_screen/presentation/bloc/search/search_cubit.dart';
import 'package:alagy/features/home_screen/presentation/bloc/search/search_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [

            // Search field
            TextField(
              controller: cubit.controller,
              focusNode: cubit.focusNode,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: cubit.clearSearch,
                ),
                hintText: context.l10n.searchHere,
                prefixIcon: const Icon(Icons.search, color: AppColor.primaryColor),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: cubit.onSearchChanged,
            ),

            SizedBox(height: 20.h),

            // Results area
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                           Text(
                            context.l10n.noResultsFound,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final options = state.searchResults;

                  return ListView.builder(
                    padding: EdgeInsets.only(top: 12.h),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteNames.doctorDetails, arguments: option);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              SizedBox(
                                width: 80.w,
                                height: 80.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: CachedNetworkImage(
                                    imageUrl: option.profileImage ?? 'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),

                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      context.getSpecialty(option.specialization) ,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      option.hospitalName ?? '',
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                    ),
                                    Text(
                                      option.city ?? '',
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              // Arrow icon
                              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
