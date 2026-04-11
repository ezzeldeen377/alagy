import 'package:injectable/injectable.dart';
import 'legal_model.dart';

@lazySingleton
class LegalRepository {
  Future<LegalContent> getTermsOfUse(String languageCode) async {
    // Simulate API delay

    if (languageCode == 'ar') {
      return LegalContent(
        title: 'شروط استخدام الموقع',
        content: _arabicTerms,
      );
    } else {
      return LegalContent(
        title: 'Terms of Use',
        content: _englishTerms,
      );
    }
  }

  Future<LegalContent> getPrivacyPolicy(String languageCode) async {
    // For now, since only one text was provided, we use the same or a placeholder
    // In a real app, these would be different endpoints.

    if (languageCode == 'ar') {
      return LegalContent(
        title: 'سياسة الخصوصية',
        content: _arabicPrivacyPolicy,
      );
    } else {
      return LegalContent(
        title: 'Privacy Policy',
        content: _englishPrivacyPolicy,
      );
    }
  }

  Future<LegalContent> getRefundPolicy(String languageCode) async {
    if (languageCode == 'ar') {
      return LegalContent(
        title: 'سياسة الاسترداد',
        content: _arabicRefundPolicy,
      );
    } else {
      return LegalContent(
        title: 'Refund Policy',
        content: _englishRefundPolicy,
      );
    }
  }

  static const String _arabicTerms = '''
شكرًا لاستخدامك تطبيق روشته ("التطبيق").  
تهدف شروط الاستخدام هذه ("الشروط") إلى تنظيم العلاقة القانونية الناتجة عن استخدامك للتطبيق والخدمات التي يقدمها.  
تُعد هذه الشروط اتفاقية ملزمة قانونًا بينك، سواء بصفتك فردًا أو نيابةً عن جهة تمثلها قانونًا ("أنت" أو "المستخدم")، وبين شركة روشته ("روشته"، "نحن"، "لنا").

تنطبق هذه الشروط على جميع مستخدمي التطبيق، بما في ذلك على سبيل المثال لا الحصر المستخدمين، العملاء، ومقدمي الخدمات الصحية.  
باستخدامك للتطبيق أو أي جزء من خدماته، فإنك تقر بأنك قد قرأت هذه الشروط وفهمتها ووافقت على الالتزام بها، بالإضافة إلى سياسة الخصوصية المعروضة داخل التطبيق.  
إذا كنت لا توافق على هذه الشروط، يرجى عدم استخدام التطبيق.

1. طبيعة المحتوى والخدمات

1.1 المحتوى  
قد يحتوي التطبيق على نصوص، بيانات، صور، تقييمات، أو أي محتوى آخر ("المحتوى") يتم توفيره من قبل روشته أو من قبل أطراف ثالثة، بما في ذلك مقدمي الرعاية الصحية مثل الأطباء، العيادات، المستشفيات، المختبرات، مراكز الأشعة، والصيدليات.

1.2 الخدمات  
يوفر تطبيق روشته منصة رقمية عبر الهاتف المحمول فقط تتيح للمستخدمين البحث عن مقدمي الرعاية الصحية، حجز المواعيد، إدارة الحجوزات، واستلام بعض المعلومات أو النتائج الطبية عند توفرها.  
تهدف الخدمات فقط إلى تسهيل الحجز والتواصل، ولا تُعد بديلاً عن الاستشارة الطبية المباشرة.  
قد يتم تقديم بعض الخدمات من قبل مقدمي خدمات مستقلين، ولا تتحمل روشته مسؤولية جودة أو نتائج الخدمات الطبية المقدمة.

1.2.1 الخدمات العامة  
تتوفر بعض الخدمات دون الحاجة إلى إنشاء حساب ("الخدمات العامة")، ويُسمح باستخدامها للاستخدام الشخصي غير التجاري فقط.  
إدراج أي مقدم خدمة داخل التطبيق لا يُعد توصية أو ضمانًا لمستوى الخدمة أو المؤهلات، وتعتمد جميع المعلومات على ما يقدمه مقدم الخدمة نفسه.  
لا تتحمل روشته أي مسؤولية عن القرارات التي يتخذها المستخدم بناءً على هذا المحتوى.

1.2.2 الخدمات المحمية  
تتطلب بعض الخدمات إنشاء حساب مستخدم ("الخدمات المحمية")، وتشمل إنشاء ملف طبي إلكتروني واستلام نتائج أو تقارير طبية.  
تُعد هذه البيانات خاصة ومؤمنة، ويُعتبر المستخدم المالك الوحيد لها.  
بموافقتك، يجوز لمقدمي الخدمات إرسال معلوماتك الطبية إلى حسابك داخل التطبيق.  
يمكنك في أي وقت طلب عدم مشاركة بياناتك أو حذف ملفك الطبي.

1.3 التقييمات والمحتوى المقدم من المستخدمين  
قد يتيح التطبيق تقييمات وآراء المستخدمين.  
هذه التقييمات تعبر عن رأي أصحابها فقط، ولا تمثل رأي أو توصية روشته، ولا تُعد رأيًا طبيًا متخصصًا.  
استخدامك لهذه التقييمات يكون على مسؤوليتك الشخصية.

2. الخصوصية والأمان  
تولي روشته أهمية قصوى لحماية خصوصية وأمان بيانات المستخدمين، خاصة البيانات الصحية.  
نلتزم بالحفاظ على سرية بياناتك وعدم مشاركتها إلا وفق سياسة الخصوصية المعروضة داخل التطبيق.  
سيتم إخطارك في حال حدوث أي خرق أمني يؤثر على بياناتك.

3. الدفع

3.1 طرق الدفع  
جميع المدفوعات داخل تطبيق روشته تتم إلكترونيًا فقط من خلال التطبيق، ولا يدعم التطبيق الدفع النقدي تحت أي ظرف.  
تشمل وسائل الدفع بطاقات الائتمان أو الخصم، المحافظ الرقمية، أو أي وسائل دفع إلكترونية أخرى يتيحها التطبيق من وقت لآخر.  
أنت مسؤول عن جميع المبالغ المدفوعة من خلال حسابك.

3.2 سياسة الاسترداد  
جميع المدفوعات الإلكترونية نهائية وغير قابلة للاسترداد، ما لم يُنص على خلاف ذلك داخل التطبيق.  
يحق للمستخدم استرداد كامل المبلغ فقط في الحالات التالية:
- إلغاء الحجز قبل موعده.
- إلغاء الموعد من قبل مقدم الخدمة.
- عدم التزام مقدم الخدمة بتقديم الخدمة.  
لا يحق للمستخدم استرداد المبلغ في حال عدم رضاه عن الخدمة الطبية المقدمة.

4. الامتثال  
يلتزم المستخدم بالامتثال لهذه الشروط، وسياسة الخصوصية، وجميع القوانين واللوائح المعمول بها.

5. الملكية الفكرية  
جميع حقوق الملكية الفكرية المتعلقة بالتطبيق والمحتوى مملوكة لروشته.  
لا يجوز نسخ أو إعادة استخدام أي جزء من التطبيق دون إذن كتابي مسبق.

6. تسجيل المستخدم  
يتطلب استخدام بعض الميزات إنشاء حساب مستخدم.  
يجب أن تكون جميع البيانات المدخلة صحيحة ومحدثة، ويشترط ألا يقل عمر المستخدم عن 18 عامًا.  
أنت مسؤول عن الحفاظ على سرية بيانات تسجيل الدخول وعن جميع الأنشطة التي تتم من خلال حسابك.

7. التواصل  
بموافقتك على هذه الشروط، فإنك توافق على تلقي الإشعارات والتنبيهات المتعلقة بالخدمة عبر التطبيق أو عبر البريد الإلكتروني المسجل.
''';

  static const String _englishTerms = '''
Thank you for using the Rosheta mobile application ("App").  
These Terms of Use ("Terms") govern your access to and use of the App and the services provided through it.  
These Terms constitute a legally binding agreement between you, whether as an individual or on behalf of an entity you legally represent ("You", "User"), and Rosheta LLC ("Rosheta", "We", "Us").

These Terms apply to all users of the App, including but not limited to customers, service providers, and any other individuals who access or use the App.  
By accessing or using the App or any part of its services, you confirm that you have read, understood, and agreed to be bound by these Terms, as well as the Rosheta Privacy Policy and any additional policies displayed within the App.  
If you do not agree to these Terms, you must not access or use the App.

1. Nature of Content and Services

1.1 Content  
The App may include text, data, images, reviews, ratings, and other materials ("Content") provided by Rosheta or by third parties, including healthcare providers such as doctors, clinics, hospitals, laboratories, radiology centers, and pharmacies.

1.2 Services  
Rosheta is a mobile-only digital platform that enables users to search for healthcare providers, book appointments, manage bookings, and receive certain medical information or results when available.  
The services are provided solely to facilitate booking and communication and do not replace professional medical advice, diagnosis, or treatment.  
Some services may be provided by independent third-party healthcare providers, and Rosheta does not guarantee the quality or outcome of any medical service.

1.2.1 Public Services  
Certain features of the App may be accessed without creating an account ("Public Services").  
Any listing of a healthcare provider does not constitute an endorsement, recommendation, or guarantee of credentials or service quality.  
All information is provided as supplied by the healthcare providers, and Rosheta shall not be liable for any decisions made based on such information.

1.2.2 Protected Services  
Some features require user registration and authentication ("Protected Services"), including the creation of a personal electronic medical record and access to medical reports or results.  
All medical data is considered private and secure, and the user remains the sole owner of their data.  
By providing consent, you authorize healthcare providers to share medical information with you through your App account.  
You may request to restrict, stop sharing, or delete your medical data at any time.

1.3 User Reviews and Opinions  
The App may display reviews, ratings, or feedback submitted by users.  
Such content represents the opinions of the individual users only and does not reflect the views of Rosheta.  
Reviews are not medical advice and should not be relied upon as such.  
Use of this content is entirely at your own risk.

2. Privacy and Security  
Rosheta places high importance on protecting user privacy and securing personal and health-related information.  
We are committed to maintaining the confidentiality of your data and will not use or share it except as described in the Privacy Policy available within the App.  
You will be notified in the event of any data breach affecting your information.

3. Payments

3.1 Online Payments Only  
All payments within the Rosheta App must be made electronically through the App.  
Cash payments are not supported under any circumstances.  
Accepted payment methods may include credit or debit cards, digital wallets, or other electronic payment methods made available from time to time.  
You are responsible for all charges incurred through your account.

3.2 Refund Policy  
All electronic payments are final and non-refundable unless explicitly stated otherwise within the App.  
A full refund may be issued only in the following cases:
- The user cancels the appointment before its scheduled time.
- The healthcare provider cancels the appointment.
- The healthcare provider fails to deliver the scheduled service.  
No refunds will be issued due to dissatisfaction with the medical service provided.

4. Compliance  
You agree to comply with these Terms, the Privacy Policy, and all applicable laws and regulations when using the App.

5. Intellectual Property  
All intellectual property rights related to the App and its Content are owned by Rosheta.  
You may not copy, reproduce, distribute, or create derivative works from any part of the App without prior written permission.

6. User Registration  
Certain features require the creation of a user account.  
You must provide accurate and complete information and keep your login credentials confidential.  
You must be at least 18 years old to use the App.  
You are responsible for all activities conducted through your account.

7. Communications  
By using the App, you consent to receive service-related notifications, updates, and legally required communications via the App or the registered email address.
''';
  static const String _arabicPrivacyPolicy = '''
سياسة الخصوصية

1. مقدمة
مرحبًا بك في روشته ("التطبيق"). نحن ملتزمون بحماية خصوصيتك وضمان أمان بياناتك الشخصية والطبية. تشرح سياسة الخصوصية هذه كيفية جمع واستخدام والإفصاح عن وحماية معلوماتك عند استخدام تطبيقنا.

2. المعلومات التي نجمعها
نجمع المعلومات التي تحدد هويتك الشخصية والمعلومات التي لا تحدد هويتك.
- المعلومات الشخصية: الاسم، البريد الإلكتروني، رقم الهاتف، تاريخ الميلاد، ومعلومات الدفع.
- المعلومات الصحية: مواعيد الأطباء، السجل الطبي، الوصفات الطبية، ونتائج المختبرات المرفوعة على التطبيق.
- بيانات الاستخدام: معلومات حول جهازك، عنوان IP، وكيفية استخدامك للتطبيق (ملفات تعريف الارتباط).

3. كيفية استخدامنا لمعلوماتك
نستخدم معلوماتك من أجل:
- تسهيل حجز المواعيد مع مقدمي الرعاية الصحية وإدارتها.
- إرسال تذكيرات المواعيد، التحديثات الطبية، والإشعارات الإدارية.
- معالجة المدفوعات بشكل آمن ومنع الاحتيال.
- تحسين وظائف التطبيق، تحليل الأداء، وتطوير خدمات جديدة.
- الامتثال للالتزامات القانونية والتنظيمية.

4. مشاركة البيانات
نحن لا نبيع بياناتك الشخصية لأطراف ثالثة. قد نشارك معلوماتك فقط في الحالات التالية:
- مقدمي الرعاية الصحية: نشارك بياناتك مع الأطباء والعيادات والمستشفيات التي تحجز معها لتمكينهم من تقديم الخدمة الطبية.
- مقدمي الخدمات: نتعامل مع شركات موثوقة لمساعدتنا في معالجة المدفوعات، استضافة البيانات، وتحليل الخدمات.
- المتطلبات القانونية: قد نفصح عن معلوماتك إذا كان ذلك مطلوبًا بموجب القانون أو استجابة لطلبات حكومية صالحة.

5. أمان البيانات
نحن نطبق إجراءات أمان فنية وتنظيمية صارمة، بما في ذلك التشفير وبروتوكولات الأمان المتقدمة، لحماية بياناتك الشخصية والصحية من الوصول غير المصرح به أو التغيير أو الإفصاح. ومع ذلك، يرجى العلم أنه لا توجد وسيلة نقل عبر الإنترنت آمنة تمامًا.

6. حقوقك
بموجب القوانين المعمول بها، لديك الحق في:
- الوصول إلى معلوماتك الشخصية وتصحيحها أو تحديثها.
- طلب حذف حسابك وبياناتك المرتبطة به.
- الاعتراض على معالجة بياناتك أو تقييدها في ظروف معينة.
يمكنك ممارسة هذه الحقوق من خلال إعدادات التطبيق أو التواصل معنا.

7. خدمات الموقع الجغرافي
قد يطلب التطبيق الوصول إلى موقعك الجغرافي لتقديم خدمات تعتمد على الموقع، مثل العثور على أطباء قريبين. يمكنك التحكم في هذا الوصول من خلال إعدادات جهازك.

8. اتصل بنا
إذا كانت لديك أي أسئلة أو مخاوف بشأن سياسة الخصوصية هذه، يرجى الاتصال بنا عبر قنوات الدعم المتاحة داخل التطبيق.
''';

  static const String _englishPrivacyPolicy = '''
Privacy Policy

1. Introduction
Welcome to Rosheta ("App"). We are committed to protecting your privacy and ensuring the security of your personal and medical data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.

2. Information We Collect
We collect information that identifies you personally and information that does not.
- Personal Information: Name, email address, phone number, date of birth, and payment details.
- Health Information: Doctor appointments, medical history, prescriptions, and lab results uploaded or generated within the App.
- Usage Data: Information about your device, IP address, and how you interact with the App (cookies and analytics).

3. How We Use Your Information
We use your information to:
- Facilitate and manage appointment bookings with healthcare providers.
- Send you appointment reminders, medical updates, and administrative notifications.
- Process payments securely and prevent fraud.
- Improve App functionality, analyze performance, and develop new features.
- Comply with legal and regulatory obligations.

4. Data Sharing
We do not sell your personal data to third parties. We may share your information only in the following circumstances:
- Healthcare Providers: We share your data with the doctors, clinics, and hospitals you book with to enable them to provide medical services.
- Service Providers: We engage trusted third-party vendors to assist with payment processing, data hosting, and service analysis.
- Legal Requirements: We may disclose your information if required by law or in response to valid government requests.

5. Data Security
We implement strict technical and organizational security measures, including encryption and strict access controls, to protect your personal and health data from unauthorized access, alteration, or disclosure. However, please be aware that no method of transmission over the internet is completely secure.

6. Your Rights
Depending on applicable laws, you have the right to:
- Access, correct, or update your personal information.
- Request the deletion of your account and associated data.
- Object to or restrict the processing of your data in certain circumstances.
You can exercise these rights through the App settings or by contacting us.

7. Location Services
The App may request access to your location to provide location-based services, such as finding nearby healthcare providers. You can control this access through your device settings.

8. Contact Us
If you have any questions or concerns about this Privacy Policy, please contact us via the support channels available within the App.
''';

  static const String _arabicRefundPolicy = '''
سياسة الاسترداد واستخدام النقاط:

1. في حال إلغاء الموعد قبل أكثر من ثلاث ساعات من موعد الزيارة، يتم استرداد المبلغ كاملاً إلى محفظة النقاط الخاصة بك داخل التطبيق.

2. في حال إلغاء الموعد قبل أقل من ثلاث ساعات من موعد الزيارة، يخصم 50% من قيمة الحجز ويتم استرداد الباقي كنقاط.

3. في حال عدم الحضور في الموعد (No-show)، لا يحق للمستخدم المطالبة باسترداد المبلغ.

4. النقاط المستردة صالحة للاستخدام في أي حجوزات مستقبلية داخل التطبيق وغير قابلة للتحويل إلى مبالغ نقدية.

5. يحق لإدارة تطبيق (روشته) مراجعة أي حالات استثنائية واتخاذ القرار المناسب بما يحفظ حقوق المستخدم ومقدم الخدمة.
''';

  static const String _englishRefundPolicy = '''
Refund and Points Policy:

1. Appointments cancelled more than 3 hours before the scheduled time will be fully refunded to your in-app points wallet.

2. Appointments cancelled less than 3 hours before the scheduled time will incur a 50% cancellation fee, with the remainder refunded as points.

3. In case of a no-show, the user is not entitled to any refund.

4. Refunded points are valid for future bookings within the app and cannot be converted into cash.

5. The (Rosheta) management reserves the right to review exceptional cases and make decisions that protect the rights of both the user and the service provider.
''';
}
