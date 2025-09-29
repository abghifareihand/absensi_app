import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileResponse {
  const ProfileResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  final bool status;
  final String message;
  final User? user;

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  const User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.role,
    this.identityNumber,
    this.phone,
    this.address,
    this.deviceId,
    this.fcmToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final String? role;
  final String? identityNumber;
  final String? phone;
  final String? address;
  final String? deviceId;
  final String? fcmToken;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
