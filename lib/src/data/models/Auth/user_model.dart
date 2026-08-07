class AuthResponse {
  final String status;
  final String message;
  final String token;
  final User user;

  const AuthResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    status: json['status'] as String,
    message: json['message'] as String,
    token: json['data']['token'] as String,
    user: User.fromJson(json['data']['user'] as Map<String, dynamic>),
  );
}

class User {
  final int id;
  final String qr;
  final String? name;
  final String? fName;
  final String? lName;
  final String key;
  final String phone;
  final String image;
  final String? email;
  final UserStatus status;
  final UserGender gender;
  final String? birthday;
  final UserCountry country;

  const User({
    required this.id,
    required this.qr,
    this.name,
    this.fName,
    this.lName,
    required this.key,
    required this.phone,
    required this.image,
    this.email,
    required this.status,
    required this.gender,
    this.birthday,
    required this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    qr: json['qr'] as String,
    name: json['name'] as String?,
    fName: json['f_name'] as String?,
    lName: json['l_name'] as String?,
    key: json['key'] as String,
    phone: json['phone'] as String,
    image: json['image'] as String,
    email: json['email'] as String?,
    status: UserStatus.fromJson(json['status'] as Map<String, dynamic>),
    gender: UserGender.fromJson(json['gender'] as Map<String, dynamic>),
    birthday: json['birthday'] as String?,
    country: UserCountry.fromJson(json['country'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'qr': qr,
    'name': name,
    'f_name': fName,
    'l_name': lName,
    'key': key,
    'phone': phone,
    'image': image,
    'email': email,
    'status': status.toJson(),
    'gender': gender.toJson(),
    'birthday': birthday,
    'country': country.toJson(),
  };
}



class UserStatus {
  final String value;
  final String desc;

  const UserStatus({required this.value, required this.desc});

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      UserStatus(value: json['value'] as String, desc: json['desc'] as String);

  Map<String, dynamic> toJson() => {'value': value, 'desc': desc};
}

class UserGender {
  final String value;
  final String desc;

  const UserGender({required this.value, required this.desc});

  factory UserGender.fromJson(Map<String, dynamic> json) =>
      UserGender(value: json['value'] as String, desc: json['desc'] as String);

  Map<String, dynamic> toJson() => {'value': value, 'desc': desc};
}

class UserCountry {
  final int id;
  final String name;
  final String currency;
  final String currencyEn;
  final String currencyAr;
  final String conversionRateToDollar;
  final String conversionRatePointMoney;

  const UserCountry({
    required this.id,
    required this.name,
    required this.currency,
    required this.currencyEn,
    required this.currencyAr,
    required this.conversionRateToDollar,
    required this.conversionRatePointMoney,
  });

  factory UserCountry.fromJson(Map<String, dynamic> json) => UserCountry(
    id: json['id'] as int,
    name: json['name'] as String,
    currency: json['currency'] as String,
    currencyEn: json['currency_en'] as String,
    currencyAr: json['currency_ar'] as String,
    conversionRateToDollar: json['conversion_rate_to_dollar'] as String,
    conversionRatePointMoney: json['conversion_rate_point_money'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'currency': currency,
    'currency_en': currencyEn,
    'currency_ar': currencyAr,
    'conversion_rate_to_dollar': conversionRateToDollar,
    'conversion_rate_point_money': conversionRatePointMoney,
  };
}
