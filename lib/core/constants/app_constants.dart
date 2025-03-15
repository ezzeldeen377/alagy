class AppConstants {
  static const String apiBaseUrl = 'https://api.alagy.com';
  static const int timeoutDuration = 30; // seconds
  static const int maxRetryAttempts = 3;
  static const String appName = 'Alagy';
  static const String appVersion = '1.0.0';
  
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