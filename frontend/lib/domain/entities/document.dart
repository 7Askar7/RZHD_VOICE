import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class UserDocument extends Equatable {
  final String name;
  final String targetClass;
  final Uint8List content;

  const UserDocument({
    required this.name,
    required this.targetClass,
    required this.content,
  });

  @override
  List<Object?> get props => [
        name,
        content,
        targetClass,
      ];
}