import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/helpers/validators.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/doctor/data/models/doctor_model.dart';
import 'package:alagy/features/doctor/presentation/bloc/doctor_details/doctor_details_cubit.dart';
import 'package:alagy/features/doctor/presentation/widgets/doctor_details/star_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = context.watch<DoctorDetailsCubit>().state.selectedDoctor!;
    final reviews = doctor.reviews;
    final avgRating = doctor.rating;
    final ratingCounts = {for (var i = 1; i <= 5; i++) i.toDouble(): 0};

    for (final review in reviews) {
      if (ratingCounts.containsKey(review.rating)) {
        ratingCounts[review.rating] = ratingCounts[review.rating]! + 1;
      }
    }

    final ratingPercentages = {
      for (final key in ratingCounts.keys)
        key: reviews.isEmpty ? 0.0 : ratingCounts[key]! / reviews.length
    };

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: context.isDark
                      ? Colors.black12.withAlpha(100)
                      : Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(avgRating?.toStringAsFixed(1) ?? '0',
                        style: context.theme.textTheme.headlineLarge),
                    Row(
                      children: List.generate(5, (index) {
                        final displayValue = (avgRating ?? 0) - index;
                        return Icon(
                          displayValue >= 1
                              ? Icons.star
                              : displayValue > 0
                                  ? Icons.star_half
                                  : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.reviewsCount.call(reviews.length),
                      style: context.theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final starCount = 5 - index;
                      final percentage =
                          ratingPercentages[starCount.toDouble()] ?? 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text('$starCount',
                                style: const TextStyle(fontSize: 12)),
                            const Icon(Icons.star,
                                size: 12, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: percentage,
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.amber),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.l10n.ratingPercentage
                                  .call((percentage * 100).toInt()),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: context.isDark
                      ? Colors.black12.withAlpha(100)
                      : Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.writeAReview,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                StarRating(
                  maxRating: 5,
                  onRatingSelected: (rate) =>
                      context.read<DoctorDetailsCubit>().selectRating(rate),
                ),
                const SizedBox(height: 12),
                Form(
                  key: context.read<DoctorDetailsCubit>().ratingFormKey,
                  child: TextFormField(
                    validator: emptyValidator,
                    controller: context
                        .read<DoctorDetailsCubit>()
                        .ratingCommentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: context.l10n.shareYourExperience,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      final cubit = context.read<DoctorDetailsCubit>();
                      final user = context.read<AppUserCubit>().state.user;
                       if(context.read<AppUserCubit>().state.isNotLogin){
                        showLoginDialog(context);
                        return;
                       }
                      if (user != null &&
                          cubit.ratingFormKey.currentState!.validate() &&
                          cubit.state.userRate != null) {
                        cubit.addReview(
                          Review(
                            doctorId: doctor.uid,
                            userId: user.uid,
                            rating: cubit.state.userRate!.toDouble(),
                            comment: cubit.ratingCommentController.text,
                            createdAt: DateTime.now(),
                            userImageUrl: user.profileImage,
                            userName: user.name,
                          ),
                        );
                      } else {
                        showSnackBar(context, context.l10n.pleaseRate);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(context.l10n.submitReview,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          reviews.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      context.l10n.noReviewsYet,
                      style: const TextStyle(
                          color: Color(0xFF757575), fontSize: 16),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: review.userImageUrl != null
                                    ? CachedNetworkImageProvider(
                                        review.userImageUrl!)
                                    : const AssetImage(
                                            'assets/images/default_user.png')
                                        as ImageProvider,
                                radius: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF424242),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(review.createdAt,
                                          locale: "ar"),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  review.rating.toInt(),
                                  (index) => const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            review.comment,
                            style: const TextStyle(
                              color: Color(0xFF616161),
                              height: 1.5,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
