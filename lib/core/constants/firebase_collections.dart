import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseCollections {
  static const doctorsCollection = 'doctors';
  static const doctorsRequestCollection = 'doctors request';
  static const usersCollection = 'users';
  static const favouriteCollection = 'favourite';
  static const appointmentsCollection = 'appointments';
  static const discountCodesCollection = 'discount_codes';
  static const paymentsCollection = 'payments';
}

class paymentKeys {
  static const String baseUrl = 'https://accept.paymob.com/v1/intention/';

  static const String publicKey =
      "egy_pk_test_cM7cfDWrtVyJR1SDDRBE8VBuGvjjIqt6";
  static String get clientSecret => dotenv.get('PAYMOB_CLIENT_SECRET', fallback: '');
  static const String integrationId = "5165268";
  static const String iFrame =
      "blob:https://accept.paymob.com/3e8d3292-0cb1-4728-9333-113a3cb88194";
}
