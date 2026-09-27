import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EventResponse {
  const EventResponse({
    this.status,
    this.message,
    this.data,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) =>
      _$EventResponseFromJson(json);

  final bool? status;
  final String? message;
  final List<EventData>? data;

  Map<String, dynamic> toJson() => _$EventResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class EventData {
  const EventData({
    this.id,
    this.title,
    this.description,
    this.image,
    this.imageUrl,
    this.eventDate,
  });

  factory EventData.fromJson(Map<String, dynamic> json) =>
      _$EventDataFromJson(json);

  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? imageUrl;
  final String? eventDate;
  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}
