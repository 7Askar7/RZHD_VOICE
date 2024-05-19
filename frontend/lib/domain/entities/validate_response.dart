import 'package:equatable/equatable.dart';

class ValidateResponse extends Equatable{
  final String id;
  final bool? verified;
  final DateTime createdAt;
  final String name;
  final bool isDeleted;
  final String cancellationReason;

  ValidateResponse({
    required this.id,
    required this.verified,
    required this.createdAt,
    required this.name,
    required this.isDeleted,
    required this.cancellationReason,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [id, verified, createdAt, name, isDeleted, cancellationReason];
}