class DoctorCardModel {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  DoctorCardModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });
}