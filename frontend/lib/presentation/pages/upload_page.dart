import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_checkdoc/presentation/widgets/dropzone_widget.dart';
// import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../bloc/document_list_bloc/document_list_bloc.dart';

class UploadPage extends StatelessWidget {
  UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentListBloc documentListBloc =
        BlocProvider.of<DocumentListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузка аудиофайла'),
      ),
      body: BlocListener<DocumentListBloc, DocumentListState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: BlocBuilder<DocumentListBloc, DocumentListState>(
          builder: (context, state) {
            if (state is DocumentListInitial) {
              documentListBloc.add(FetchDocumentEvent());
              return const Center(child: CircularProgressIndicator());
            } else if (state is DocumentListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DocumentListLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        height: 600,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 330,
                            // childAspectRatio: 1,
                            // crossAxisSpacing: 20,
                            // mainAxisSpacing: 20
                          ),
                          itemCount: state.documents.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(state.documents[index].name),
                                  DropzoneWidget(
                                    targetClass:
                                        state.documents[index].targetClass,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Продолжить'),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is DocumentListError) {
              return Center(
                child: Text(state.error),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
