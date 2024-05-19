import 'package:equatable/equatable.dart';

class UploadFileResponse extends Equatable{
  final String jobId;
  final String jobTry;
  final String docId;
  final String enqueueTime;

  UploadFileResponse({
    required this.jobId,
    required this.jobTry,
    required this.docId,
    required this.enqueueTime,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [jobId, jobTry, docId, enqueueTime];

}