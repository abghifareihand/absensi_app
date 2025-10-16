import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EventResponse {
  const EventResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) =>
      _$EventResponseFromJson(json);

  final bool status;
  final String message;
  final List<EventData> data;

  Map<String, dynamic> toJson() => _$EventResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class EventData {
  const EventData({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.imageUrl,
    required this.eventDate,
  });

  factory EventData.fromJson(Map<String, dynamic> json) =>
      _$EventDataFromJson(json);

  final int id;
  final String title;
  final String description;
  final String image;
  final String imageUrl;
  final String eventDate;
  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}
