import 'package:get/get.dart';

/// Central GetX [Translations]. Keys are logical IDs; pass keys to UI and call [.tr].
class AppTranslations extends Translations {
  /// Global currency symbol, dynamically updated from store settings.
  static String appCurrency = 'IQD';

  @override
  Map<String, Map<String, String>> get keys => {'en': _en, 'ar': _ar};

  static const Map<String, String> _en = {
    // ── App ──
    'app_title': 'Nisba',

    // ── Auth: Login ──
    'skip': 'Skip',
    'login': 'Login',
    'enter_phone_instruction': 'Enter your registered phone number',
    'phone_number_hint': 'Phone number',
    'next': 'Next',
    'or': 'Or',
    'continue_with_email': 'Continue with email',
    'continue_with_google': 'Continue with Google',
    'continue_with_facebook': 'Continue with Facebook',
    'dont_have_account': "Don't have an account? ",
    'create_account': 'Create account',

    // ── Auth: OTP ──
    'auth_otp_title': 'OTP Verification',
    'auth_otp_subtitle_line1': 'Please enter the code we sent you',
    'auth_otp_subtitle_line2': 'consisting of 6 digits to your phone number',
    'auth_security_notice':
        'For your security, do not share the activation code with anyone',
    'auth_resend_link': 'Send new code',
    'auth_resend_countdown_prefix': 'You can request a new code in ',
    'auth_resend_countdown_suffix': ' seconds',

    // ── Auth: Register ──
    'register_personal_info_title': 'Personal Information',
    'register_personal_info_subtitle': 'Enter your personal details',
    'first_name_label': 'First Name *',
    'first_name_hint': 'Enter your first name',
    'last_name_label': 'Last Name *',
    'last_name_hint': 'Enter your last name',
    'email_label': 'Email *',
    'email_hint': 'Enter your email',
    'email_is_required': 'Email is required',
    'date_of_birth_label': 'Date of Birth *',
    'date_hint': 'Day / Month / Year',
    'gender_label': 'Gender *',
    'first_name': 'First Name',
    'last_name': 'Last Name',
    'email': 'Email',
    'name_is_required': 'Name is required',
    'enter_a_valid_email': 'Enter a valid email',
    'date_of_birth': 'Date of Birth',
    'gender': 'Gender',
    'male': 'Male',
    'female': 'Female',
    'please_select_gender': 'Please select your gender',

    // ── General ──
    'confirm': 'Confirm',
    'yes': 'Yes',
    'no': 'No',
    'retry': 'Retry',
    'exit_confirm': 'Press back again to exit',

    // ── Dialogs ──
    'dialog_success': 'Success',
    'dialog_error': 'Error',
    'dialog_alert': 'Alert',

    // ── Snackbar ──
    'snackbar_success': 'Success',
    'snackbar_error': 'Error',
    'snackbar_info': 'Info',
    'snackbar_otp_resent': 'OTP resent to {{phone}}',

    // ── Dio Errors ──
    'error_cancelled': 'Request To API Server Was Cancelled',
    'error_connection_timeout': 'Connection Time Out',
    'error_no_internet': 'No Internet Connection',
    'error_receive_timeout': 'Receive Time Out',
    'error_server': 'Server error ({{statusCode}})',
    'error_validation': 'Validation error',
    'error_send_timeout': 'Send Time Out',
    'error_connection': 'Connection Error',

    // ── Time Ago ──
    'time_ago_seconds': '{{count}} second(s) ago',
    'time_ago_minutes': '{{count}} minute(s) ago',
    'time_ago_hours': '{{count}} hour(s) ago',
    'time_ago_days': '{{count}} day(s) ago',
    'time_ago_years': '{{count}} year(s) ago',

    // ── Language Names ──
    'lang_arabic': 'العربية',
    'lang_english': 'English',

    // Favorites screen
    'no_favorites': 'No items in favorites',
    'profile_update_success': 'Profile updated successfully',
    'choose_color': 'Choose a color',
  };

  static const Map<String, String> _ar = {
    // ── App ──
    'app_title': 'نسبا',

    // ── Auth: Login ──
    'skip': 'تخطي',
    'login': 'تسجيل الدخول',
    'enter_phone_instruction': 'أدخل رقم الهاتف المسجل بالتطبيق',
    'phone_number_hint': 'رقم الهاتف',
    'next': 'التالي',
    'or': 'أو',
    'continue_with_email': 'المتابعة باستخدام البريد الإلكتروني',
    'continue_with_google': 'المتابعة باستخدام جوجل',
    'continue_with_facebook': 'المتابعة باستخدام فيسبوك',
    'dont_have_account': 'ليس لديك حساب؟ ',
    'create_account': 'إنشاء حساب',

    // ── Auth: OTP ──
    'auth_otp_title': 'أدخل رمز التفعيل',
    'auth_otp_subtitle_line1': 'الرجاء إدخال الرمز الذي أرسلناه إليك',
    'auth_otp_subtitle_line2': 'و المكون من 6 أرقام إلى رقم هاتفك',
    'auth_security_notice': 'لأمانك، لا تشارك رمز التفعيل مع أي شخص',
    'auth_resend_link': 'إرسال رمز جديد',
    'auth_resend_countdown_prefix': 'يمكنك طلب رمز جديد خلال ',
    'auth_resend_countdown_suffix': ' ثانية',

    // ── Auth: Register ──
    'register_personal_info_title': 'المعلومات الشخصية',
    'register_personal_info_subtitle': 'يرجى إدخال بياناتك الشخصية بعناية',
    'first_name_label': 'الاسم الأول *',
    'first_name_hint': 'أدخل اسمك الأول',
    'last_name_label': 'اسم العائلة *',
    'last_name_hint': 'أدخل اسمك الأخير',
    'email_label': 'البريد الإلكتروني *',
    'email_hint': 'أدخل بريدك الإلكتروني',
    'email_is_required': 'البريد الإلكتروني مطلوب',
    'date_of_birth_label': 'تاريخ الميلاد *',
    'date_hint': 'يوم / شهر / سنة',
    'gender_label': 'الجنس *',
    'first_name': 'الاسم الأول',
    'last_name': 'اسم العائلة',
    'email': 'البريد الإلكتروني',
    'name_is_required': 'الاسم مطلوب',
    'enter_a_valid_email': 'أدخل بريدًا إلكترونيًا صحيحًا',
    'date_of_birth': 'تاريخ الميلاد',
    'gender': 'الجنس',
    'male': 'ذكر',
    'female': 'أنثى',
    'please_select_gender': 'يرجى اختيار الجنس',

    // ── General ──
    'confirm': 'تأكيد',
    'yes': 'نعم',
    'no': 'لا',
    'retry': 'إعادة المحاولة',
    'exit_confirm': 'اضغط مرة أخرى للخروج',

    // ── Dialogs ──
    'dialog_success': 'نجاح',
    'dialog_error': 'خطأ',
    'dialog_alert': 'تنبيه',

    // ── Snackbar ──
    'snackbar_success': 'نجاح',
    'snackbar_error': 'خطأ',
    'snackbar_info': 'معلومات',
    'snackbar_otp_resent': 'تم إعادة إرسال رمز التحقق إلى {{phone}}',

    // ── Dio Errors ──
    'error_cancelled': 'تم إلغاء الطلب',
    'error_connection_timeout': 'انتهت مهلة الاتصال',
    'error_no_internet': 'لا يوجد اتصال بالإنترنت',
    'error_receive_timeout': 'انتهت مهلة الاستلام',
    'error_server': 'خطأ في الخادم ({{statusCode}})',
    'error_validation': 'خطأ في التحقق',
    'error_send_timeout': 'انتهت مهلة الإرسال',
    'error_connection': 'خطأ في الاتصال',

    // ── Time Ago ──
    'time_ago_seconds': 'منذ {{count}} ثانية',
    'time_ago_minutes': 'منذ {{count}} دقيقة',
    'time_ago_hours': 'منذ {{count}} ساعة',
    'time_ago_days': 'منذ {{count}} يوم',
    'time_ago_years': 'منذ {{count}} سنة',

    // ── Language Names ──
    'lang_arabic': 'العربية',
    'lang_english': 'English',

    // Favorites screen
    'no_favorites': 'لا يوجد منتجات مفضلة ل عرضها',
    'profile_update_success': 'تم تحديث الملف الشخصي بنجاح',
    'choose_color': 'اختر لونًا',
  };
}
