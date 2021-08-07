import 'package:assistant/manager/qa_bloc/qa_bloc.dart';
import 'package:assistant/presentation/widget/FAB_stt.dart';
import 'package:assistant/presentation/widget/qList.dart';
import 'package:assistant/repositories/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<QaBloc>(
        create: (_) =>
            QaBloc(RepositoryProvider.of<FireStoreRepository>(context)),
        child: QList(),
      ),
      floatingActionButton: FABStt()
    );
  }
}
