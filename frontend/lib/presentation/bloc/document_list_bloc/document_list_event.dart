part of 'document_list_bloc.dart';

@immutable
sealed class DocumentListEvent {}

class FetchDocumentEvent extends DocumentListEvent {}