import 'package:flutter/material.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class Review {
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime createdAt;
  final String userImageUrl;

  Review({
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.userImageUrl,
  });
}

final List<Review> fakeReviews = [
  Review(
    userId: 'user1',
    userName: 'John Doe',
    comment: 'Excellent doctor, very professional and caring!',
    rating: 5.0,
    createdAt: DateTime(2025, 5, 21),
    userImageUrl: 'https://ui-avatars.com/api/?name=John+Doe',
  ),
  Review(
    userId: 'user2',
    userName: 'Jane Smith',
    comment: 'Good experience, but the wait time was a bit long.',
    rating: 4.0,
    createdAt: DateTime(2025, 5, 18),
    userImageUrl: 'https://ui-avatars.com/api/?name=Jane+Smith',
  ),
  Review(
    userId: 'user3',
    userName: 'Alex Johnson',
    comment: 'Highly recommend, great communication.',
    rating: 4.5,
    createdAt: DateTime(2025, 5, 13),
    userImageUrl: 'https://ui-avatars.com/api/?name=Alex+Johnson',
  ),
];

const double fakeAverageRating = 4.3;

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});



  @override
  Widget build(BuildContext context) {
    final reviews = fakeReviews;
    final avgRating = fakeAverageRating;

    final Map<double, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in reviews) {
      final rating = review.rating;
      if (ratingCounts.containsKey(rating)) {
        ratingCounts[rating] = ratingCounts[rating]! + 1;
      }
    }

    final Map<double, double> ratingPercentages = {};
    if (reviews.isNotEmpty) {
      for (final entry in ratingCounts.entries) {
        ratingPercentages[entry.key] = entry.value / reviews.length;
      }
    } else {
      for (final key in ratingCounts.keys) {
        ratingPercentages[key] = 0.0;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Rating Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242), // Colors.grey[800]
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          final starValue = index + 1;
                          final displayValue = avgRating - index;
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
                        context.l10n.reviewsCount?.call(reviews.length) ?? '${reviews.length} reviews',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575), // Colors.grey[600]
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: List.generate(5, (index) {
                        final starCount = 5 - index;
                        final percentage = ratingPercentages[starCount] ?? 0.0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                '$starCount',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percentage,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.l10n.ratingPercentage?.call((percentage * 100).toInt()) ??
                                    '${(percentage * 100).toInt()}%',
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
            // Review Form (Display Only)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  Text(
                    context.l10n.writeAReview ?? 'Write a Review',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242), // Colors.grey[800]
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      return Icon(
                        starValue <= 5 ? Icons.star : Icons.star_border, // Default 5 stars
                        color: Colors.amber,
                        size: 32,
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    enabled: false, // Disable input for static display
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: context.l10n.shareYourExperience ?? 'Share your experience',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.featureNotImplemented ?? 'Review submission not implemented',
                            ),
                            backgroundColor: AppColor.tealNew,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.tealNew,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.l10n.submitReview ?? 'Submit Review',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Review List
            reviews.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.noReviewsYet ?? 'No reviews yet',
                      style: const TextStyle(
                        color: Color(0xFF757575), // Colors.grey[600]
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                  backgroundImage: NetworkImage(review.userImageUrl),
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
                                          color: Color(0xFF424242), // Colors.grey[800]
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(review.createdAt, locale: "ar",),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF757575), // Colors.grey[600]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    review.rating.toInt(),
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              review.comment,
                              style: const TextStyle(
                                color: Color(0xFF616161), // Colors.grey[700]
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
      ),
    );
  }
}