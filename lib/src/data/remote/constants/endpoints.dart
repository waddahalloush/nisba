import '../../../configs/app_env.dart';

class EndPoints {
  static String get baseUrl => AppEnv.baseUrl;

  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration connectionTimeout = Duration(seconds: 120);

  // ── Auth ──
  static const sendCode = '/api/v1/send-verification-code';
  static const checkVerificationCode = '/api/v1/check-verification-code';
  static const completeAccount = '/api/v1/users/complete-account';
  static const logout = '/api/v1/logout';
  static const profile = '/api/v1/users/profile';
  static const updateProfile = '/api/v1/users/update-profile';

  // ── Home / Catalog ──
  static const home = '/api/v1/users/home';
  static const enums = '/api/v1/enums';
  static const basics = '/api/v1/basics';
  static const sections = '/api/v1/sections';
  static String sectionDetails(int id) => '/api/v1/sections/$id';
  static const meals = '/api/v1/meals';
  static String mealDetails(int id) => '/api/v1/meals/$id';
  static const markets = '/api/v1/markets';
  static const products = '/api/v1/products';
  static const offers = '/api/v1/offers';
  static String offerDetails(int id) => '/api/v1/offers/$id';
  static const categories = '/api/v1/categories';
  static const tags = '/api/v1/tags';
  static const services = '/api/v1/services';
  static String serviceDetails(int id) => '/api/v1/services/$id';
  static const kioks = '/api/v1/kioks';
  static const kiosks = '/api/v1/kiosks';
  static const malls = '/api/v1/malls';
  static String mallDetails(int id) => '/api/v1/malls/$id';
  static const commercialCenters = '/api/v1/commercial-centers';
  static String commercialCenterDetails(int id) =>
      '/api/v1/commercial-centers/$id';

  // ── Booking ──
  static String bookingResources(int marketId) =>
      '/api/v1/bookings/markets/$marketId/resources';
  static String bookingSlots(int marketId) =>
      '/api/v1/bookings/markets/$marketId/slots';
  static String bookingAvailability(int marketId) =>
      '/api/v1/bookings/markets/$marketId/availability';

  // ── Orders ──
  static const getMyOrders = '/api/v1/orders';
  static const storeOrder = '/api/v1/orders/store';
  static const orderInfo = '/api/v1/order-info';
  static const openPaymentPage = '/api/v1/orders/open-payment-page';
  static String cancelOrder(int id) => '/api/v1/orders/$id/cancel';
  static String rateOrder(int id) => '/api/v1/orders/$id/rate';
  static String payOrder(int id) => '/api/v1/orders/$id/pay';
  static String paymentStatus(String paymentRef) =>
      '/api/v1/orders/payment-status/$paymentRef';

  // ── Addresses ──
  static const addresses = '/api/v1/addresses';
  static const storeAddress = '/api/v1/addresses/store';

  // ── User cars ──
  static const userCars = '/api/v1/user-cars';
  static const storeUserCar = '/api/v1/user-cars/store';
  static const userCarsInfo = '/api/v1/user-cars/create/info';

  // ── Wallets ──
  static const wallets = '/api/v1/wallets';
  static const walletCards = '/api/v1/wallets/users/cards';
  static const chargeWallet = '/api/v1/wallets/users/charge';
  static const giftWallet = '/api/v1/wallets/users/gift';
  static String chargeStatus(String paymentRef) =>
      '/api/v1/wallets/users/charge-status/$paymentRef';

  // ── Points ──
  static const points = '/api/v1/points';
  static const giftPoints = '/api/v1/points/users/gift';
  static const convertPointsToWallet = '/api/v1/points/users/convert-to-wallet';

  // ── Visas ──
  static const visas = '/api/v1/visas';
  static const storeVisa = '/api/v1/visas/store';
  static String setDefaultVisa(int id) => '/api/v1/visas/$id/set-default';

  // ── Coupons / Favorites / Misc ──
  static const coupons = '/api/v1/coupons';
  static const checkCoupon = '/api/v1/coupons/check';
  static const favorites = '/api/v1/favorites';
  static String favMarket(int id) => '/api/v1/markets/$id/favorite';
  static String marketReviews(int id) => '/api/v1/markets/$id/reviews';
  static const faqs = '/api/v1/faqs';
  static const termPrivacy = '/api/v1/term-privacy';
  static const mapMarkets = '/api/v1/map';
  static const version = '/api/v1/version';
  static const loginEmail = '/api/v1/login';

  // ── Account extras ──
  static const deleteAccount = '/api/v1/users/delete-account';
  static const updateFcm = '/api/v1/users/update-fcm';
  static const updateLang = '/api/v1/users/update-lang';
  static const paymentSettings = '/api/v1/users/payment-settings';
  static const setDefaultPaymentMethod =
      '/api/v1/users/set-default-payment-method';
  static const setDailyPurchaseLimit =
      '/api/v1/users/set-maximum-limit-for-daily-purchases';
  static const infoUser = '/api/v1/info-user';

  // ── Security OTP flows ──
  static const changePaymentPassword = '/api/v1/users/change-payment-password';
  static const sendCodeForChangePayment =
      '/api/v1/send-verification-code-for-change-payment';
  static const checkCodeForChangePayment =
      '/api/v1/check-verification-code-for-change-payment';
  static const changePaymentPasswordByOtp =
      '/api/v1/users/change-payment-password-by-otp';

  static const sendCodeForEmailPassword =
      '/api/v1/users/email/send-verification-code-for-email-forget-password';
  static const checkCodeForEmailPassword =
      '/api/v1/users/email/check-verification-code-for-email-forget-password';
  static const changeEmailPasswordByOtp =
      '/api/v1/users/email/change-email-password-by-otp';

  static const sendCodeForEmailChange =
      '/api/v1/users/email/send-verification-code-for-email-change';
  static const checkCodeForEmailChange =
      '/api/v1/users/email/check-verification-code-for-email-change';
  static const changeEmailByOtp = '/api/v1/users/email/change-email-by-otp';
  static const changeVerificationCode = '/api/v1/users/change-verification-code';

  // ── Support / Reports / Inbox / Chat ──
  static const contactInfo = '/api/v1/contact-info';
  static const inquiries = '/api/v1/inquiries';
  static const reports = '/api/v1/reports';
  static const inboxes = '/api/v1/inboxes';
  static String orderChat(int orderId) => '/api/v1/chats/orders/$orderId';
  static const sendChatMessage = '/api/v1/chats/message';
  static const pusherAuth = '/api/v1/chats/pusher/auth';

  // ── Notifications ──
  static const getNotifications = '/api/v1/notifications';
  static const deleteAllNotifications = '/api/v1/notifications/all/delete';
}
