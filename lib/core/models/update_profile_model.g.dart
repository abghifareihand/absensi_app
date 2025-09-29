// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequest(
  name: json['name'] as String,
  username: json['username'] as String,
  email: json['email'] as String?,
  identityNumber: json['identity_number'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  UpdateProfileRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'username': instance.username,
  'email': instance.email,
  'identity_number': instance.identityNumber,
  'phone': instance.phone,
  'address': instance.address,
};
