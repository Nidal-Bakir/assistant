import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum ListeningStatus { Listening, NotListening }

class SpeechToTextRepository {
  /// sound level for UI
  final StreamController<double> _soundLevelSC = StreamController<double>();

  /// changes from listening to not listening.
  final StreamController<ListeningStatus> _statusSC =
      StreamController<ListeningStatus>();

  final StreamController<SpeechRecognitionError> _speechRecognitionErrorSC =
      StreamController<SpeechRecognitionError>();

  final StreamController<SpeechRecognitionResult> _speechRecognitionResultSC =
      StreamController<SpeechRecognitionResult>();

  final SpeechToText _speech = SpeechToText();

  bool _hasSpeech = false;

  SpeechToTextRepository() {
    init();
  }

  Stream<double> get soundLevelStream => _soundLevelSC.stream;

  Stream<SpeechRecognitionResult> get speechRecognitionStream =>
      _speechRecognitionResultSC.stream;

  Stream<SpeechRecognitionError> get speechRecognitionErrorStream =>
      _speechRecognitionErrorSC.stream;

  Stream<ListeningStatus> get statusStream => _statusSC.stream;

  /// return true if the initialization of STT was successful, false if not
  Future<bool> init() async {
    _hasSpeech = await _speech.initialize(
        onStatus: (status) => _statusSC.sink.add(
            status == SpeechToText.listeningStatus
                ? ListeningStatus.Listening
                : ListeningStatus.NotListening),
        onError: (errorNotification) =>
            _speechRecognitionErrorSC.sink.add(errorNotification),
        debugLogging: true,
        finalTimeout: Duration.zero);

    return _hasSpeech;
  }

  Future<void> cancelListening() async {
    if (!_hasSpeech) return;
    await _speech.cancel();
    _soundLevelSC.sink.add(0.0);
  }

  void startListening() {
    if (!_hasSpeech) return;
    _speech.listen(
        onResult: (result) => _speechRecognitionResultSC.sink.add(result),
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        onSoundLevelChange: (level) => _soundLevelSC.sink.add(level),
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  Future<void> dispose() async {
    await _soundLevelSC.close();
    await _statusSC.close();
    await _speechRecognitionErrorSC.close();
    await _speechRecognitionResultSC.close();
    if (!_hasSpeech) return;
    await _speech.cancel();
  }
}
