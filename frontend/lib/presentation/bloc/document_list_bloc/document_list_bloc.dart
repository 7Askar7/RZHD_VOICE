import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_checkdoc/domain/entities/document.dart';
import 'package:flutter_checkdoc/domain/use_cases/fetch_documents.dart';
import 'package:meta/meta.dart';

part 'document_list_event.dart';
part 'document_list_state.dart';

class DocumentListBloc extends Bloc<DocumentListEvent, DocumentListState> {
  final FetchDocuments fetchDocuments;
  DocumentListBloc({required this.fetchDocuments}) : super(DocumentListInitial()) {
    on<FetchDocumentEvent>((event, emit) async {
      emit(DocumentListLoading());

      try {
        // Perform the logic here
        // You can use services or APIs to fetch data
        // Simulating a delay for demonstration purposes
        fetchDocuments(const FetchDocumentsParams())
            .then((response) {
          response.fold(
            (failure) => emit(DocumentListError(failure.toString())),
            (documents) => emit(DocumentListLoaded(documents)),
          );
        });

        
      } catch (error) {
        // If login fails, yield LoginFailure with the error message
        emit(DocumentListError( error.toString()));
      }
    });
  }
}
