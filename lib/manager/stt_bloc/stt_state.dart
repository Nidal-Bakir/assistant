part of 'stt_bloc.dart';

abstract class SttState extends Equatable {
  const SttState();
}

class SttIdle extends SttState {
  @override
  List<Object> get props => [];
}

/// Indicate the listening state
///
/// The not Listening state indicated by [SttIdle] state
class SttListening extends SttState {
  @override
  List<Object> get props => [];
}

class SttChangeSoundLevel extends SttState {
  final double level;

  SttChangeSoundLevel(this.level);

  @override
  List<Object> get props => [level];
}

class SttFailure extends SttState {
  @override
  List<Object> get props => [];
}

class SttIndexRecognitionFailure extends SttState {
  @override
  List<Object> get props => [];
}

class SttRecognitionSuccess extends SttState {
  final String qIndex;

  SttRecognitionSuccess(this.qIndex);

  @override
  List<Object> get props => [qIndex];
}
