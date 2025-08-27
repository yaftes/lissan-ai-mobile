// domain/usecases/recognize_speech.dart
import '../../data/services/speech_to_text_service.dart';

class RecognizeSpeech {
  final SpeechToTextService service;

  RecognizeSpeech(this.service);

  Future<void> init() => service.init();
  Future<void> startListening() => service.startListening();
  Future<void> stopListening() => service.stopListening();

  Stream<String> get recognizedWords => service.recognizedWordsStream;
  Stream<String> get errors => service.errorStream;
  Stream<SpeechRecognizerState> get status => service.statusStream;
}
