import 'package:flutter_checkdoc/domain/entities/validate_response.dart';

class ValidateResponseModel extends ValidateResponse {
  ValidateResponseModel({
    required super.id,
    required super.verified,
    required super.createdAt,
    required super.name,
    required super.isDeleted,
    required super.cancellationReason,
  });

  factory ValidateResponseModel.fromJson(Map<String, dynamic> json) {
    return ValidateResponseModel(
      id: json["id"],
      verified: json["verified"] == null ? null : json["verified"],
      createdAt: DateTime.parse(json["created_at"]),
      name: json["name"],
      isDeleted: json["is_deleted"],
      cancellationReason: json["cancellation_reason"],
    );
  }
}