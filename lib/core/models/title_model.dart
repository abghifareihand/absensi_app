import 'package:json_annotation/json_annotation.dart';

part 'title_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TitleResponse {
  const TitleResponse({
    this.status,
    this.message,
    this.title,
    this.subtitle,
  });

  factory TitleResponse.fromJson(Map<String, dynamic> json) =>
      _$TitleResponseFromJson(json);

  final bool? status;
  final String? message;
  final String? title;
  final String? subtitle;

  Map<String, dynamic> toJson() => _$TitleResponseToJson(this);
}
