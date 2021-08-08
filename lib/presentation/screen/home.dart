import 'package:assistant/manager/tts_bloc/tts_bloc.dart';
import 'package:assistant/presentation/widget/FAB_stt.dart';
import 'package:assistant/presentation/widget/qList.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = '';
    return Scaffold(
        appBar: AppBar(
          title: Text('Your assistant'),
          centerTitle: true,
        ),
        body: BlocListener<TtsBloc, TtsState>(
          listenWhen: (_, listCurrent) => listCurrent is TtsPlaying,
          listener: (context, listState) async {
            if (listState is TtsPlaying) {
              text = '';
              await showModalBottomSheet(
                // isScrollControlled: true,
                context: context,
                builder: (context) {
                  return BlocBuilder<TtsBloc, TtsState>(
                    buildWhen: (previous, current) =>
                    current is TtsPlayInProgress ||
                        current is TtsStop ||
                        current is TtsFailure,
                    // ignore: missing_return
                    builder: (context, state) {
                      if (state is TtsPlayInProgress) {
                        text = text + state.word;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            text,
                            softWrap: true,
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              );
              context.read<TtsBloc>().add(TtsTextVoiceStopped());
            }
          },
          child: QList(),
        ),
        floatingActionButton: FABStt());
  }
}
