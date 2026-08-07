import 'user_model.dart';

class ProfileUpdateResponse {
  final String status;
  final String message;
  final User user;

  const ProfileUpdateResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateResponse(
        status: json['status'] as String,
        message: json['message'] as String,
        user: User.fromJson(json['data']['user'] as Map<String, dynamic>),
      );
}
