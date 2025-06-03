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
   "internalMedicine",
    "vascularSurgery",
    "orthopedics",
    "specializations",
    "gynecologyAndObstetrics",
    "pediatricsAndNeonatology",
    "urology",
    "dentistry",
    "neurology",
    "cosmeticSurgery",
    "ophthalmology",
    "ent",
    "chestDiseases",
    "dermatology",
    "physiotherapy",
    "ivf",
    "speechAndLanguageTherapy",
];
 static String get internalMedicine => "internalMedicine";
 static String get vascularSurgery => "vascularSurgery";
 static String get orthopedics => "orthopedics";
 static String get specializations => "specializations";
 static String get gynecologyAndObstetrics => "gynecologyAndObstetrics";
 static String get pediatricsAndNeonatology => "pediatricsAndNeonatology";
 static String get urology => "urology";
 static String get dentistry => "dentistry";
 static String get neurology => "neurology";
static  String get cosmeticSurgery => "cosmeticSurgery";
static  String get ophthalmology => "ophthalmology";
static  String get ent => "ent";
 static String get chestDiseases => "chestDiseases";
static  String get dermatology => "dermatology";
 static String get physiotherapy => "physiotherapy";
 static String get ivf => "ivf";
 static String get speechAndLanguageTherapy => "speechAndLanguageTherapy";
static  const List<String> daysOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
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