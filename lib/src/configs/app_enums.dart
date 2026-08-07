/// Local mirror of useful Laravel `GET /enums` values.
/// We do **not** call the enums endpoint at runtime — these are documented
/// constants for app logic (filters, payment, version gate, etc.).
class AppEnums {
  AppEnums._();

  // UpdateStatus — POST /version
  static const updateMandatory = 'mandatory';
  static const updateUpToDate = 'up_to_date';
  static const updateOptional = 'optional';

  // PaymentMethod
  static const payCash = 'cash';
  static const payCard = 'card';
  static const payGooglePay = 'google_pay';
  static const payApplePay = 'apple_pay';
  static const payWallet = 'wallet';
  static const payPoint = 'point';

  // OrderStatus — now vs prev lists match backend helpers
  static const orderWaitingPayment = 'waiting_client_payment';
  static const orderNew = 'new';
  static const orderInPreparation = 'in_preparation';
  static const orderReady = 'ready_for_collection';
  static const orderDispatched = 'dispatched';
  static const orderDelivered = 'delivered';
  static const orderCanceled = 'canceled';
  static const orderFailed = 'failed';
  static const orderRejected = 'rejected';

  static const orderNowStatuses = {
    orderWaitingPayment,
    orderNew,
    orderInPreparation,
    orderReady,
    orderDispatched,
  };

  static const orderPrevStatuses = {
    orderDelivered,
    orderCanceled,
    orderFailed,
    orderRejected,
  };

  // MarketType
  static const marketStore = 'store';
  static const marketService = 'service';
  static const marketCinema = 'cinema';
  static const marketHotel = 'hotel';
  static const marketEntertainment = 'entertainment';
  static const marketTransport = 'transport';
  static const marketKioks = 'kioks';
  static const marketMall = 'mall';

  // Section.route_key — home service tile navigation
  static const sectionRouteHotel = 'hotel';
  static const sectionRouteCinema = 'cinema';
  static const sectionRouteEntertainment = 'entertainment';
  static const sectionRouteTransport = 'transport';
  static const sectionRouteService = 'service';
  static const sectionRouteTourism = 'tourism';
  static const sectionRouteGifts = 'gifts';
  static const sectionRouteMall = 'mall';
  static const sectionRouteCommercialCenter = 'commercial_center';
  static const sectionRouteKioks = 'kioks';
  static const sectionRouteStore = 'store';
  static const sectionRouteGrocery = 'grocery';
  static const sectionRouteCafe = 'cafe';

  static const sectionBookingRouteKeys = {
    sectionRouteHotel,
    sectionRouteCinema,
    sectionRouteEntertainment,
    sectionRouteTransport,
    sectionRouteService,
  };

  // OfferType
  static const offerGeneral = 'general';
  static const offerCumulativeDiscount = 'cumulative_discount';
  static const offerProductFixedPrice = 'product_fixed_price';

  // UsernameType (OTP identity)
  static const usernamePhone = 'phone';
  static const usernameEmail = 'email';

  // DeliveryType
  static const deliveryPickup = 'pickup';
  static const deliveryDelivery = 'delivery';
}
