import 'package:assistant/manager/stt_bloc/stt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FABStt extends StatelessWidget {
  const FABStt({Key  key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SttBloc, SttState>(
      listenWhen: (previous, current) =>
      current is SttIndexRecognitionFailure || current is SttFailure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (state is SttFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Something want wrong!')));
        } else if (state is SttIndexRecognitionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('I conn\'t recognize the question number...')));
        }
      },
      builder: (context, state) {
        if (state is SttChangeSoundLevel) {
          return Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .26,
                    spreadRadius: state.level * 1.5,
                    color: Colors.black.withOpacity(.05))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: IconButton(
              icon: Icon(Icons.cancel_outlined),
              onPressed: () =>
                  context.read<SttBloc>().add(SttListenCanceled()),
            ),
          );
        }

        return Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .26,
                  spreadRadius: 0,
                  color: Colors.black.withOpacity(.05))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: IconButton(
            icon: Icon(Icons.mic),
            onPressed: state is SttListening
                ? null
                : () => context.read<SttBloc>().add(SttListenStarted()),
          ),
        );
      },
    );
  }
}
