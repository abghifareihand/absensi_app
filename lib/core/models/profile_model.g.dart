// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      user:
          json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  username: json['username'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  identityNumber: json['identity_number'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  deviceId: json['device_id'] as String?,
  fcmToken: json['fcm_token'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'username': instance.username,
  'email': instance.email,
  'role': instance.role,
  'identity_number': instance.identityNumber,
  'phone': instance.phone,
  'address': instance.address,
  'device_id': instance.deviceId,
  'fcm_token': instance.fcmToken,
};
