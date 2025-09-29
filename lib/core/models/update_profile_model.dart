import 'package:json_annotation/json_annotation.dart';

part 'update_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateProfileRequest {
  final String name;
  final String username;
  final String? email;
  final String? identityNumber;
  final String? phone;
  final String? address;

  UpdateProfileRequest({
    required this.name,
    required this.username,
    this.email,
    this.identityNumber,
    this.phone,
    this.address,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
