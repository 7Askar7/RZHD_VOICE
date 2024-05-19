part of 'document_list_bloc.dart';

@immutable
sealed class DocumentListState {}

final class DocumentListInitial extends DocumentListState {}

final class DocumentListLoading extends DocumentListState {}

final class DocumentListLoaded extends DocumentListState {
  final List<UserDocument> documents;

  DocumentListLoaded(this.documents);
}

final class DocumentListError extends DocumentListState {
  final String error;

  DocumentListError(this.error,);
}
