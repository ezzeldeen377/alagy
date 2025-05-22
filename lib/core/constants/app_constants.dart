class AppConstants {
  static const String apiBaseUrl = 'https://api.alagy.com';
  static const int timeoutDuration = 30; // seconds
  static const int maxRetryAttempts = 3;
  static const String appName = 'Alagy';
  static const String appVersion = '1.0.0';
  static const String darkMapStyle = '''
  [
    {"elementType":"geometry","stylers":[{"color":"#242f3e"}]},
    {"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},
    {"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},
    {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
    {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
    {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},
    {"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},
    {"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},
    {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},
    {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},
    {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},
    {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},
    {"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},
    {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},
    {"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},
    {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},
    {"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}
  ]
  ''';
  static List<String> specialtiesKeys = [
  "specialty_internal_medicine",
  "specialty_general_surgery",
  "specialty_pediatrics",
  "specialty_orthopedics",
  "specialty_urology",
  "specialty_ent",
  "specialty_ophthalmology",
  "specialty_dentistry",
  "specialty_radiology",
  "specialty_cardiothoracic_surgery",
  "specialty_neurosurgery",
  "specialty_oncology",
  "specialty_nephrology",
  "specialty_pulmonology",
  "specialty_psychiatry",
  "specialty_hematology",
  "specialty_vascular_surgery",
  "specialty_geriatrics",
  "specialty_neonatology"
];
  // Cache configuration
  static const int cacheDuration = 7; // days
  
  // Pagination
  static const int defaultPageSize = 10;
  
  // Animation durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 400; // milliseconds
  static const int longAnimationDuration = 600; // milliseconds
}
enum SignInMethods{
    emailAndPassword,
    google,
   
  }
  enum Role{
  patient,
  doctor
}