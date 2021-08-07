import 'package:assistant/manager/qa_bloc/qa_bloc.dart';
import 'package:assistant/presentation/widget/qItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QList extends StatefulWidget {
  const QList({Key key}) : super(key: key);

  @override
  _QListState createState() => _QListState();
}

class _QListState extends State<QList> {
  @override
  void initState() {
    context.read<QaBloc>().add(QaLoaded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QaBloc, QaState>(
      builder: (context, state) {
        if (state is QaInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is QaLoadFailure) {
          return Center(
            child: Text('something want wrong! please try again later. '),
          );
        } else if (state is QaLoadSuccess) {
          return ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (_, int index) => QItem(
              index: index + 1,
              qa: state.qaList[index],
            ),
            itemCount: state.qaList.length,
          );
        }

        throw 'UnHandled state QaBloc: $state';
      },
    );
  }
}
