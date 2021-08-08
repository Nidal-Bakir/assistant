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
                        previous is TtsPlayInProgress ||
                        current is TtsPlayInProgress,
                    builder: (context, state) {
                      if (state is TtsPlayInProgress) {
                        print(
                            '6666666666666666666666666666666666666666666666666666666' +
                                text);
                        text = text + state.word;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            text,
                            softWrap: true,
                          ),
                        );
                      }
                      // throw 'UnHandled state TtsBloc: $state';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          text,
                          softWrap: true,
                        ),
                      );
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
