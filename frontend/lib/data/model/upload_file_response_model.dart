import 'dart:convert';

import '../../domain/entities/upload_file_response.dart';

class UploadFileResponseModel extends UploadFileResponse {
  UploadFileResponseModel({
    required super.jobId,
    required super.jobTry,
    required super.docId,
    required super.enqueueTime,
  });

  factory UploadFileResponseModel.fromRawJson(String str) =>
      UploadFileResponseModel.fromJson(json.decode(str));

  factory UploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadFileResponseModel(
      jobId: json["job_id"],
      jobTry: json["job_try"],
      docId: json["doc_id"],
      enqueueTime: json["enqueue_time"],
    );
  }
}